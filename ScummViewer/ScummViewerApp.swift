//
//  ScummViewerApp.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import SwiftUI

@main
struct ScummViewerApp: App {
    
    @StateObject private var scummStore:  ScummStore
    @State private var showAlert = false
    @State private var isExportDisabled = true
    
    init() {
        _scummStore = StateObject(wrappedValue: ScummStore())
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .frame(minWidth: 1024, maxWidth: .infinity, minHeight: 768, maxHeight: .infinity, alignment: .center)
                .environmentObject(scummStore)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Couldn't load SCUMM game data.")
                    )
                }
        }.commands {
            
            CommandGroup(after: .newItem) {
                Button(action: openGame) {
                    Text("Open Game…")
                }
            }
            
            CommandGroup(after: .importExport) {
                Button(action: exportGame) {
                    Text("Export Game…")
                }.disabled(isExportDisabled)
            }
            
        }
    }
    
    private func openGame() {
        
        let panel = NSOpenPanel()
        
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        
        if panel.runModal() == .OK {
            
            guard let url = panel.url else {
                return
            }
            
            do {
                
                try scummStore.readDirectory(at: url)
                
                let urls = scummStore.scummFiles.map { $0.value.fileURL }
                scummStore.scummVersion = ScummVersion.dectect(files: urls )
                
                isExportDisabled = false
                
            } catch {
                showAlert = true
            }
                
        }
    }
    
    private func exportGame() {
                
        let panel = NSSavePanel()
                
        panel.title = "Export Game…"
        panel.prompt = "Export"
        panel.nameFieldLabel = "Game Name"
        panel.nameFieldStringValue = gameName ?? "Unknown"
        
        if panel.runModal() == .OK {
            
            scummStore.scummFiles
                .filter { file in file.value.type == .dataFile }
                .forEach { dataFile in
                    
                    var imageCount = 0
                    
                    dataFile.value.tree?.depthFirstTraversal { node in
                        
                        switch BlockType(rawValue: node.value.name) {
                        case .SMAP:
                            
                            let grandparent = BlockType(rawValue: node.parent?.parent?.value.name ?? "unknown")
                            if grandparent == .RMIM {
                                
                                guard
                                    let trnsNode = node.find(blockType: .TRNS),
                                    let clutNode = node.find(blockType: .CLUT),
                                    let rmhdNode = node.find(blockType: .RMHD)
                                else {
                                    return
                                }
                                
                                var buffer = try! trnsNode.read(in: scummStore.scummFiles.last?.value.fileURL)
                                let trns = TRNS.create(from: buffer)
                                
                                buffer = try! clutNode.read(in: scummStore.scummFiles.last?.value.fileURL)
                                let clut = CLUT.create(from: buffer)
                                
                                buffer = try! rmhdNode.read(in: scummStore.scummFiles.last?.value.fileURL)
                                let rmhd = RMHD.create(from: buffer)
                                
                                buffer = try! node.read(in: scummStore.scummFiles.last?.value.fileURL)
                                let smap = SMAP.create(from: buffer, imageWidth: rmhd.width)
                                
                                let image = ScummImage(from: smap, palette: clut, width: rmhd.width, height: rmhd.height)
                                let png = image.bitmap.cgImage?.pngData
                                let leadingZeros = String(format: "%03d", imageCount)
                                let filename = "image_\(leadingZeros).png"
                                print("Saving", filename)
                                try? png?.savePng(fileName: filename)
                                
                                imageCount += 1
                                
                            } else {
                                fallthrough
                            }
                        default:
                            break
                            //let whitespace = String(repeating: " ", count: node.level ?? 0)
                            //print(whitespace, node.value.name)
                        }
                        
                    }
                }
        }
    }
    
    private var gameName: String? {
        scummStore.scummFiles.first?.value.fileURL.deletingLastPathComponent().lastPathComponent
    }
}
