import Foundation

public protocol AsyncTaskSwitcher {
    associatedtype TaskOutput

    typealias TaskClosure = () throws -> TaskOutput
    typealias TaskResult = Result<TaskOutput, Error>

    func enqueue(
        task closure: @escaping TaskClosure,
        completion: @escaping (TaskResult) -> Void
    )
}
