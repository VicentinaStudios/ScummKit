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
        
        panel.canCreateDirectories = true
        panel.title = "Export Game…"
        panel.prompt = "Export"
//        panel.nameFieldLabel = "Game Name"
//        panel.nameFieldStringValue = gameName ?? "Unknown"
        
        if panel.runModal() == .OK {
            
            scummStore.scummFiles
                .filter { file in file.value.type == .dataFile }
                .forEach { dataFile in
                    
                    var imageCount = 0
                    var objectCount = 0
                    var costumeCount = 0
                    var scriptCount = 0
                    var localScriptCount = 0
                    
                    dataFile.value.tree?.depthFirstTraversal { node in
                        
                        switch BlockType(rawValue: node.value.name) {
                        case .SMAP:
                            return
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
                                //try? png?.savePng(fileName: filename)
                                try? png?.savePng(fileName: filename, to: panel.url?.appendingPathComponent("rooms"))
                                
                                imageCount += 1
                            } else if grandparent == .OBIM {
                                
                                guard
                                    let trnsNode = node.find(blockType: .TRNS),
                                    let clutNode = node.find(blockType: .CLUT),
                                    let imhdNode = node.find(blockType: .IMHD, in: .OBIM)
                                else {
                                    return
                                }
                                
                                var buffer = try! trnsNode.read(in: scummStore.scummFiles.last?.value.fileURL)
                                let trns = TRNS.create(from: buffer)
                                
                                buffer = try! clutNode.read(in: scummStore.scummFiles.last?.value.fileURL)
                                let clut = CLUT.create(from: buffer)
                                
                                buffer = try! imhdNode.read(in: scummStore.scummFiles.last?.value.fileURL)
                                let imhd = IMHD.create(from: buffer)
                                
                                buffer = try! node.read(in: scummStore.scummFiles.last?.value.fileURL)
                                let smap = SMAP.create(from: buffer, imageWidth: imhd.width)
                                
                                let image = ScummImage(from: smap, palette: clut, width: imhd.width, height: imhd.height)
                                let png = image.bitmap.cgImage?.pngData
                                let leadingZeros = String(format: "%03d", objectCount)
                                
                                let filename = "object_\(leadingZeros).png"
                                print("Saving", filename)
                                //try? png?.savePng(fileName: filename)
                                try? png?.savePng(fileName: filename, to: panel.url?.appendingPathComponent("objects"))
                                
                                objectCount += 1
                                
                            } else {
                                fallthrough
                            }
                        case .COST:
                            
                            return
                            
                            guard
                                let roomNode = node.find(blockType: .ROOM, in: .LFLF),
                                let clutNode = roomNode.find(blockType: .CLUT, in: .ROOM)
                            else {
                                return
                            }
                            
                            var buffer = try! clutNode.read(in: scummStore.scummFiles.last?.value.fileURL)
                            let clut = CLUT.create(from: buffer)
                            
                            buffer = try! node.read(in: scummStore.scummFiles.last?.value.fileURL)
                            let cost = COST.create(from: buffer)
                            
                            
                            cost.images.enumerated().forEach { index, image in
                                
                                let texture = Texture(with: image, format: cost.format, clut: clut, colors: cost.colors)
                                
                                
                                let cgImage = texture.bitmap.cgImage
                                let png = cgImage?.pngData
                                
                                let costumeLeadingZeros = String(format: "%03d", costumeCount)
                                let indexLeadingZeros = String(format: "%03d", index)
                                    
                                let filename = "costume_\(costumeLeadingZeros)_\(indexLeadingZeros).png"
                                
                                try? png?.savePng(fileName: filename, to: panel.url?.appendingPathComponent("costumes"))
                            }
                             
                            costumeCount += 1
                            
                        case .SCRP:
                            
                            let buffer = try! node.read(in: scummStore.scummFiles.last?.value.fileURL)
                            let scrp = SCRP.create(from: buffer)
                            
                            let leadingZeros = String(format: "%03d", scriptCount)
                            let filename = "script_\(leadingZeros).o"
                            
                            if let path = panel.url?.appendingPathComponent("scripts") {
                                try? Data(buffer).saveScript(fileName: filename, to: path)
                            }
                            
                            scriptCount += 1
                            
                        case .LSCR:
                            
                            var buffer = try! node.read(in: scummStore.scummFiles.last?.value.fileURL)
                            let scrp = SCRP.create(from: buffer)
                            
                            let leadingZeros = String(format: "%03d", localScriptCount)
                            let filename = "lscript_\(leadingZeros).o"
                            
                            if let path = panel.url?.appendingPathComponent("lscripts") {
                                try? Data(buffer).saveScript(fileName: filename, to: path)
                            }
                            
                            localScriptCount += 1
                            
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
