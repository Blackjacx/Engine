//
//  AsyncOperationTests.swift
//  Engine
//
//  Created by Stefan Herold on 05.02.21.
//

import Foundation
import Quick
import Nimble
@testable import Engine

final class AsyncOperationTests: QuickSpec {

    override func spec() {

        describe("AsyncOperation") {

            let queue: OperationQueue = OperationQueue()

            beforeEach {
            }

            it("is asynchronous") {
                let operation = TestOperation()
                expect(operation.isAsynchronous) == true
            }
            
            context("state") {

                it("is ready after init") {
                    let operation = TestOperation()
                    expect(operation.state) == .ready
                }

                it("is executing after execution") {
                    let operation = TestOperation()
                    queue.addOperation(operation)
                    expect(operation.state).toEventually(equal(.executing))
                }

                it("is finished after execution finishes") {
                    let operation = TestOperation()
                    queue.addOperation(operation)
                    expect(operation.state).toEventually(equal(.finished))
                }

                it("is cancelled after cancel function is called") {
                    let operation = TestOperation()
                    queue.addOperation(operation)
                    operation.cancel()
                    expect(operation.isCancelled).toEventually(beTrue())
                }

                it("is finished after cancel function is called") {
                    let operation = TestOperation()
                    queue.addOperation(operation)
                    operation.cancel()
                    expect(operation.state).toEventually(equal(.finished))
                }
            }
        }
    }
}


final class TestOperation: AsyncOperation {

    override func main() {
        /// Use a dispatch after to mimic the scenario of a long-running task.
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.finish()
        }
    }
}
