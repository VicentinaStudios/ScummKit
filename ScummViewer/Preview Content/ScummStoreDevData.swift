//
//  ScummStoreDevData.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import Foundation

extension ScummStore {
  
    func createDevData() {
        
        let indexFile = TreeNode<String>(with: "MONKEY.000")
        
        indexFile.add(TreeNode<String>(with: "ROOM"))
        indexFile.add(TreeNode<String>(with: "MAXS"))
        indexFile.add(TreeNode<String>(with: "DROO"))
        indexFile.add(TreeNode<String>(with: "DSCR"))
        indexFile.add(TreeNode<String>(with: "DSOU"))
        indexFile.add(TreeNode<String>(with: "DCOS"))
        indexFile.add(TreeNode<String>(with: "DCHR"))
        indexFile.add(TreeNode<String>(with: "DOBJ"))
        
        let dataFile = TreeNode<String>(with: "MONKEY.001")
        
        let mainContainer = (TreeNode<String>(with: "LECF"))
        dataFile.add(mainContainer)
        
        let roomOffsetTable = (TreeNode<String>(with: "LOFF"))
        let diskBlock = (TreeNode<String>(with: "LFLF"))
        
        mainContainer.add(roomOffsetTable)
        mainContainer.add(diskBlock)
        
        let roomBlock = (TreeNode<String>(with: "ROOM"))
        let script = (TreeNode<String>(with: "SCRP"))
        let sound = (TreeNode<String>(with: "SOUN"))
        let costume = (TreeNode<String>(with: "COST"))
        let charset = (TreeNode<String>(with: "CHAR"))
        
        diskBlock.add(roomBlock)
        diskBlock.add(script)
        diskBlock.add(sound)
        diskBlock.add(costume)
        diskBlock.add(charset)
        
        let roomHeader = (TreeNode<String>(with: "RMHD"))
        let colorCycle = (TreeNode<String>(with: "CYCL"))
        let transparentColor = (TreeNode<String>(with: "TRNS"))
        let paletteData = (TreeNode<String>(with: "EPAL"))
        let roomImage = (TreeNode<String>(with: "RMIM"))
        let objectImage = (TreeNode<String>(with: "OBIM"))
        let objectScript = (TreeNode<String>(with: "OBCD"))
        let exitScript = (TreeNode<String>(with: "EXCD"))
        let entryScript = (TreeNode<String>(with: "ENCD"))
        let numberOfLocalScripts = (TreeNode<String>(with: "NLSC"))
        let localScript = (TreeNode<String>(with: "LSCR"))
        let boxData = (TreeNode<String>(with: "BOXD"))
        let boxMatrix = (TreeNode<String>(with: "BOXM"))
        let scale = (TreeNode<String>(with: "SCAL"))
        
        roomBlock.add(roomHeader)
        roomBlock.add(colorCycle)
        roomBlock.add(transparentColor)
        roomBlock.add(paletteData)
        roomBlock.add(roomImage)
        roomBlock.add(objectImage)
        roomBlock.add(objectScript)
        roomBlock.add(exitScript)
        roomBlock.add(entryScript)
        roomBlock.add(numberOfLocalScripts)
        roomBlock.add(localScript)
        roomBlock.add(boxData)
        roomBlock.add(boxMatrix)
        roomBlock.add(scale)
        
        scummFiles.append(indexFile)
        scummFiles.append(dataFile)
    }
}
