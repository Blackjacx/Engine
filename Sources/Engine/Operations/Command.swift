//
//  Command.swift
//  Engine
//
//  Created by Stefan Herold on 19.11.20.
//

import Foundation

/// Serial operation queue
private let serialQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
}()

public extension Operation {

    func executeSync() {
        serialQueue.addOperations([self], waitUntilFinished: true)
    }

    func executeAsync(completion: @escaping () -> Void) {

        serialQueue.addOperation(self)
        serialQueue.addBarrierBlock { completion() }
    }
}

public extension Array where Element == Operation {

    func executeSync() {
        serialQueue.addOperations(self, waitUntilFinished: true)
    }

    func executeAsync(completion: @escaping () -> Void) {

        serialQueue.addOperations(self, waitUntilFinished: false)
        serialQueue.addBarrierBlock { completion() }
    }
}
