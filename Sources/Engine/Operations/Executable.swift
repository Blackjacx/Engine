//
//  Executable.swift
//  Engine
//
//  Created by Stefan Herold on 19.11.20.
//

import Foundation

/// Serial operation queue
private let concurrentQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
    return queue
}()

public protocol Executable: Operation {}

public extension Executable {

    func executeSync() {
        concurrentQueue.addOperations([self], waitUntilFinished: true)
    }

    func executeAsync(completion: @escaping () -> Void) {
        concurrentQueue.addOperation(self)
        concurrentQueue.addBarrierBlock { completion() }
    }
}

public extension Array where Element: Executable {

    func executeSync() {
        concurrentQueue.addOperations(self, waitUntilFinished: true)
    }

    func executeAsync(completion: @escaping () -> Void) {
        concurrentQueue.addOperations(self, waitUntilFinished: false)
        concurrentQueue.addBarrierBlock { completion() }
    }
}
