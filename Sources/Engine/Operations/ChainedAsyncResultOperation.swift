//
//  ChainedAsyncResultOperation.swift
//  Engine
//
//  Created by Stefan Herold on 05.02.21.
//

import Foundation

/**
 Implementation of chainable operation

     let queue = OperationQueue()
     let unfurlOperation = UnfurlURLChainedOperation(shortURL: URL(string: "https://bit.ly/33UDb5L")!)
     let fetchTitleOperation = FetchTitleChainedOperation()
     fetchTitleOperation.addDependency(unfurlOperation)

     queue.addOperations([unfurlOperation, fetchTitleOperation], waitUntilFinished: true)

     print("Operation finished with: \(fetchTitleOperation.result!)")
     // Prints: Operation finished with: success("A weekly Swift Blog on Xcode and iOS Development - SwiftLee")

 See also: [Advanced Asynchronous Operations Using Generics in Swift](https://medium.com/better-programming/advanced-asynchronous-operations-using-generics-in-swift-b55932a15f6a)
 */
open class ChainedAsyncResultOperation<Input, Output, Failure>: AsyncResultOperation<Output, Failure> where Failure: Swift.Error {

    private(set) public var input: Input?

    public init(input: Input? = nil) {
        self.input = input
    }

    override public final func start() {
        updateInputFromDependencies()
        super.start()
    }

    /// Updates the input by fetching the output of its dependencies.
    /// Will always get the first output matching dependency.
    /// If `input` is already set, the input from dependencies will be ignored.
    private func updateInputFromDependencies() {
        guard input == nil else { return }
        input = dependencies.compactMap { dependency in
            let outputProviding = dependency as? ChainedOperationOutputProviding
            let output = outputProviding?.output
            let input = output as? Input
            return input
        }.first
    }
}

extension ChainedAsyncResultOperation: ChainedOperationOutputProviding {
    var output: Any? {
        return try? result?.get()
    }
}

protocol ChainedOperationOutputProviding {
    var output: Any? { get }
}
