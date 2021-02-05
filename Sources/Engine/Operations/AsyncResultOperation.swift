//
//  AsyncResultOperation.swift
//  Engine
//
//  Created by Stefan Herold on 05.02.21.
//

import Foundation

/**
 Implementation of an operation providing a result type

     let queue = OperationQueue()
     let unfurlOperation = UnfurlURLOperation(shortURL: URL(string: "https://bit.ly/33UDb5L")!)
     queue.addOperations([unfurlOperation], waitUntilFinished: true)
     print("Operation finished with: \(unfurlOperation.result!)")

     // Prints: Operation finished with: success(https://www.avanderlee.com/)

 See also: [Advanced Asynchronous Operations Using Generics in Swift](https://medium.com/better-programming/advanced-asynchronous-operations-using-generics-in-swift-b55932a15f6a)
 */
open class AsyncResultOperation<Success, Failure>: AsyncOperation where Failure: Error {

    private(set) public var result: Result<Success, Failure>!

    /// Make sure that the default finish() method is no longer useful.
    final public override func finish() {
        guard !isCancelled else { return super.finish() }
        fatalError("Make use of finish(with:) instead to ensure a result")
    }

    /// New finish(with:) method that enforces implementers to set a result.
    public func finish(with result: Result<Success, Failure>) {
        self.result = result
        super.finish()
    }

    /// Make sure that the default cancel() method is no longer useful.
    open override func cancel() {
        fatalError("Make use of cancel(with:) instead to ensure a result")
    }

    /// New cancel(with:) method that enforces implementers to set a result.
    public func cancel(with error: Failure) {
        self.result = .failure(error)
        super.cancel()
    }
}
