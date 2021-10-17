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
    
    init(with value: T) {
        self.value = value
    }
    
    func add(_ child: TreeNode) {
        
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
}
