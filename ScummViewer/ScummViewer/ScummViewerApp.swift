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
    @StateObject private var recentFilesManager = RecentFilesManager()
    
    @State private var showAlert = false
    @State private var isExportDisabled = true
    @State private var isRecentsDisabled = true
    
    init() {
        _scummStore = StateObject(wrappedValue: ScummStore())
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .frame(minWidth: 1024, maxWidth: .infinity, minHeight: 768, maxHeight: .infinity, alignment: .center)
                .environmentObject(scummStore)
                .onChange(of: scummStore.error) { change in
                    showAlert = !showAlert
                }
                .alert(isPresented: $showAlert, error: scummStore.error) { error in
                    Text(error.errorDescription ?? "Error Occured")
                } message: { error in
                    let message = [error.failureReason, error.recoverySuggestion]
                        .compactMap { $0 }
                        .joined(separator: "\n\n")
                    Text(message)
                }
        }.commands {
            
            CommandGroup(after: .newItem) {
                Button(action: openGame) {
                    Text("Open Game…")
                }
                .keyboardShortcut("o", modifiers: .command)
            }
            
            CommandGroup(after: .newItem) {
                Menu("Open Recent") {
                    ForEach(recentFilesManager.recentFiles.indices, id: \.self) { index in
                        Button {
                            openRecentFile(for: index)
                        } label: {
                            Text(recentFilesManager.recentFiles[index].lastPathComponent)
                        }
                        .keyboardShortcut(KeyEquivalent(Character(UnicodeScalar(0x0030+index + 1)!)) , modifiers: [.command])
                    }
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
                
                isExportDisabled = false
                recentFilesManager.recentFiles.insert(url, at: 0)
                
            } catch {
                scummStore.error = error as? RuntimeError
            }
                
        }
    }
    
    func openRecentFile(for index: Int) {
        
        do {
            
            let url = recentFilesManager.recentFiles[index]
            try scummStore.readDirectory(at: url)
            
            isExportDisabled = false
            
            recentFilesManager.recentFiles.remove(at: index)
            recentFilesManager.recentFiles.insert(url, at: 0)
            
        } catch {
            scummStore.error = error as? RuntimeError
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
