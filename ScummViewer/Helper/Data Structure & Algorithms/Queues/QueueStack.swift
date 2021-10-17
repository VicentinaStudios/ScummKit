//
//  QueueStack.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

struct QueueStack<T> : Queue {
  
    private var leftStack: [T] = []
    private var rightStack: [T] = []
    
    init() {}
    
    var isEmpty: Bool {
        leftStack.isEmpty && rightStack.isEmpty
    }
    
    var peek: T? {
        !leftStack.isEmpty ? leftStack.last : rightStack.first
    }
    
    mutating func enqueue(_ element: T) -> Bool {
        
        rightStack.append(element)
        return true
    }
    
    mutating func dequeue() -> T? {
        
        if leftStack.isEmpty {
            leftStack = rightStack.reversed()
            rightStack.removeAll()
        }
        
        return leftStack.popLast()
    }
}

// MARK: - Debug

extension QueueStack: CustomStringConvertible {
    
    public var description: String {
        String(describing: leftStack.reversed() + rightStack)
    }
}
