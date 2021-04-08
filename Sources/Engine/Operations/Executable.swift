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

    func executeAsync(completion:  @escaping () -> Void) {
        let completionOperation = BlockOperation {
            DispatchQueue.main.async {
                completion()
            }
        }
        completionOperation.addDependency(self)
        concurrentQueue.addOperations([self, completionOperation], waitUntilFinished: false)
    }
}

public extension Array where Element: Executable {

    func executeSync() {
        concurrentQueue.addOperations(self, waitUntilFinished: true)
    }

    func executeAsync(completion: @escaping () -> Void) {
        let completionOperation = BlockOperation {
            DispatchQueue.main.async {
                completion()
            }
        }
        forEach { [unowned completionOperation] in completionOperation.addDependency($0) }
        concurrentQueue.addOperations(self + [completionOperation], waitUntilFinished: false)
    }
}
