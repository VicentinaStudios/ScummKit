//
//  Queue.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

struct QueueArray<T>: Queue {
    
    private var array: [T] = []
    
    init() {}
    
    var isEmpty: Bool {
        array.isEmpty
    }

    var peek: T? {
        array.first
    }
    
    mutating func enqueue(_ element: T) -> Bool {
        array.append(element)
        return true
    }
    
    mutating func dequeue() -> T? {
        isEmpty ? nil : array.removeFirst()
    }
}

// MARK: - Debugging

extension QueueArray: CustomStringConvertible {
  
    public var description: String {
        String(describing: array)
    }
}
