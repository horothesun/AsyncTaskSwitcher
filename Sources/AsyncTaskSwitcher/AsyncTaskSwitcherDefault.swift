import Foundation
import ConcurrentDictionary

public final class AsyncTaskSwitcherDefault<TaskOutput> {

    private lazy var taskQueue = DispatchQueue(label: "taskQueueId-\(UUID())", attributes: .concurrent)

    private var startTimeByTaskId = ConcurrentDictionaryLock<UUID, Date>(
        from: [:],
        onSetValueForKey: { uuid, date in
            guard let date = date else { return }

            print(taskId: uuid, startTime: date)
        }
    )

    private lazy var lastCompletedTaskQueue = DispatchQueue(
        label: "timestampQueueId-\(UUID())",
        attributes: .concurrent
    )
    private var lastCompletedTaskId: UUID?

    private func set(lastCompletedTaskId taskId: UUID) {
        lastCompletedTaskQueue.async(flags: .barrier) { [weak self] in
            guard let nonNilSelf = self else { return }

            nonNilSelf.lastCompletedTaskId = taskId
            AsyncTaskSwitcherDefault.print(taskId: taskId, endTime: .init())
        }
    }

    private func areThereCompletedTasksIds(startedAfter startTime: Date) -> Bool {
        var result = false
        lastCompletedTaskQueue.sync { [weak self] in
            guard let nonNilSelf = self else { return }

            if let lastCompletedTaskId = nonNilSelf.lastCompletedTaskId,
               let taskStartTime = nonNilSelf.startTimeByTaskId[lastCompletedTaskId] {
                result = taskStartTime >= startTime
            } else {
                result = false
            }
        }
        return result
    }

    public init() { }
}

extension AsyncTaskSwitcherDefault: AsyncTaskSwitcher {

    public func enqueue(
        task closure: @escaping TaskClosure,
        completion: @escaping (TaskResult) -> Void
    ) {
        taskQueue.async { [weak self] in
            guard let nonNilSelf = self else { return }

            let taskId: UUID = .init()
            let startTime: Date = .init()
            nonNilSelf.startTimeByTaskId[taskId] = startTime
            defer {
                nonNilSelf.set(lastCompletedTaskId: taskId)
            }
            do {
                let taskOutput = try closure()
                nonNilSelf.whenNoCompletedTask(
                    startedAfter: startTime,
                    call: completion,
                    with: .success(taskOutput)
                )
            } catch {
                nonNilSelf.whenNoCompletedTask(
                    startedAfter: startTime,
                    call: completion,
                    with: .failure(error)
                )
            }
        }
    }

    private func whenNoCompletedTask(
        startedAfter startTime: Date,
        call completion: @escaping (TaskResult) -> Void,
        with taskResult: TaskResult
    ) {
        if !areThereCompletedTasksIds(startedAfter: startTime) {
            completion(taskResult)
        }
    }
}

extension AsyncTaskSwitcherDefault {

    private static func print(taskId: UUID, startTime: Date) {
        DispatchQueue.main.async {
            let startTimeMsSince1970 = 1000 * startTime.timeIntervalSince1970
            Swift.print("🔫 Task #\(taskId) started on \(startTime) (\(startTimeMsSince1970))")
        }
    }

    private static func print(taskId: UUID, endTime: Date) {
        DispatchQueue.main.async {
            let endTimeMsSince1970 = 1000 * endTime.timeIntervalSince1970
            Swift.print("🛑 Task #\(taskId) ended on \(endTime) (\(endTimeMsSince1970))")
        }
    }
}
