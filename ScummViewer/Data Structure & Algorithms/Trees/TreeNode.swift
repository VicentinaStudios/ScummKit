//
//  Tree.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

class TreeNode<T> {
    
    var value: T
    var children: [TreeNode] = []
    
    init(with value: T) {
        self.value = value
    }
    
    func add(_ child: TreeNode) {
      children.append(child)
    }
}

// MARK: - Traversal algorithms

extension TreeNode {
    
    func depthFirstTraversal(visit: (TreeNode) -> Void) {
        
        visit(self)
        
        children.forEach {
            $0.depthFirstTraversal(visit: visit)
        }
    }
    
    func levelOrderTraversal(visit: (TreeNode) -> Void) {
        
        visit(self)
        
        var queue = QueueStack<TreeNode>()
        
        children.forEach { _ = queue.enqueue($0) }
        
        while  let node = queue.dequeue() {
            
            visit(node)
            
            node.children.forEach { _ = queue.enqueue($0) }
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
