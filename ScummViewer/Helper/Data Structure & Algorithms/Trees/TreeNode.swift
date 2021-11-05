//
//  Tree.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

import Foundation

class TreeNode<T: Hashable>: Hashable {
    
    static func ==(lhs: TreeNode<T>, rhs: TreeNode<T>) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    var value: T
    var children: [TreeNode]? = nil
    weak var parent: TreeNode?
    
    init(with value: T) {
        self.value = value
    }
    
    func add(_ child: TreeNode) {
        
        child.parent = self
        
        if (children?.append(child)) == nil {
            children = [child]
        }
    }
}

// MARK: - Traversal algorithms

extension TreeNode {
    
    func depthFirstTraversal(visit: (TreeNode) -> Void) {
        
        visit(self)
        
        children?.forEach {
            $0.depthFirstTraversal(visit: visit)
        }
    }
    
    func levelOrderTraversal(visit: (TreeNode) -> Void) {
        
        visit(self)
        
        var queue = QueueStack<TreeNode>()
        
        children?.forEach { _ = queue.enqueue($0) }
        
        while  let node = queue.dequeue() {
            
            visit(node)
            
            node.children?.forEach { _ = queue.enqueue($0) }
        }
    }
}

// MARK: - Search

extension TreeNode where T: Equatable {
    
    func search(for value: T) -> TreeNode? {
        
        var result: TreeNode?
        
        levelOrderTraversal { node in
        
            if node.value == value {
                result = node
            }
        }
        
        return result
    }
    
    var root: TreeNode {
        
        var node: TreeNode<T> = self
        
        while node.parent != nil {
            if let parent = node.parent {
                node = parent
            }
        }
        
        return node
    }
    
    var level: Int? {
        
        guard let parentLevel = parent?.level else {
            return 1
        }
        
        return parentLevel + 1
    }
}
