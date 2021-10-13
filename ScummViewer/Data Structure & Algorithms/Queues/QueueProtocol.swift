//
//  QueueProtocol.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 13.10.21.
//

protocol Queue {
    
    associatedtype Element
    
    mutating func enqueue(_ element: Element) -> Bool
    mutating func dequeue() -> Element?
    
    var isEmpty: Bool { get }
    var peek: Element? { get }
}
