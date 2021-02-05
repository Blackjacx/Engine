//
//  AsyncOperation.swift
//  Engine
//
//  Created by Stefan Herold on 18.11.20.
//

import Foundation

/// Operation subclass that can be used as base for any async operation. Just subclass this AsyncOperation, execute
/// your async task and set state = .finished when finished. Doing so enables you to extract any async task into its
/// own operation object and just add the operation to an OperationQueue. See how ReverseGeocodeOperation is
/// implemented and used to get an idea.
/// - https://withintent.com/blog/basics-of-operations-and-operation-queues-in-ios/
/// - https://www.avanderlee.com/swift/asynchronous-operations/
/// - https://gist.github.com/Sorix/57bc3295dc001434fe08acbb053ed2bc
/// - https://www.raywenderlich.com/5293-operation-and-operationqueue-tutorial-in-swift
/// - https://aplus.rs/2018/asynchronous-operation/
open class AsyncOperation: Operation, Executable {

    private let lockQueue = DispatchQueue(label: "com.stherold.async_operaton_lock_queue", attributes: .concurrent)

    // MARK: - State Management

    public enum State: String {
        case ready, executing, finished

        fileprivate var keyPath: String {
            "is" + rawValue.capitalized
        }
    }

    public override var isAsynchronous: Bool { true }
    public override var isExecuting: Bool { state == .executing }
    public override var isFinished: Bool { state == .finished }

    /// Thread-safe computed state value
    var state: State {
        get {
            lockQueue.sync { stateStore }
        }
        set {
            let oldValue = state
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
            lockQueue.sync(flags: [.barrier]) {
                stateStore = newValue
            }
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }

    /// Non thread-safe state storage, use only with locks
    private var stateStore: State = .ready

    /// Trigger fatal error when main() executed by a subclass.
    open override func main() {
        preconditionFailure("Subclasses must implement `main` without overriding super.")
    }

    public override func start() {

        guard !isCancelled else {
            state = .finished
            return
        }
        state = .executing
        main()
    }

    public func finish() {
        state = .finished
    }
}
