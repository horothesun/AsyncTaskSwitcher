import XCTest
import AsyncTaskSwitcher

final class AsyncTaskSwitcherDefaultTests: XCTestCase {

    private typealias TaskOutput = String
    private struct FakeError: Error { }

    // Task01 -------🎬-------------------❌---->
    // Completion ------------------------❌---->
    func test_enqueueingSingleFailingTask_mustCallTaskAndFailingCompletion() {
        let sut = AsyncTaskSwitcherDefault<TaskOutput>()
        let task01CalledExpectation = XCTestExpectation(description: "task01 called")
        let task01CompletionCalledWithFailureExpectation = XCTestExpectation(description: "task01 completion called with failure")
        sut.enqueue(
            task: {
                task01CalledExpectation.fulfill()
                throw FakeError()
            },
            completion: { taskResult in
                if case .failure = taskResult {
                    task01CompletionCalledWithFailureExpectation.fulfill()
                }
            }
        )
        wait(
            for: [task01CalledExpectation, task01CompletionCalledWithFailureExpectation],
            timeout: 1
        )
    }

    // Task01 -------🎬-------------------📦---->
    // Completion ------------------------📦---->
    func test_enqueueingSingleSuccedingIn1sTask_mustCallTaskAndSuccedingCompletion() {
        let sut = AsyncTaskSwitcherDefault<TaskOutput>()
        let task01Output: TaskOutput = "📦"
        let task01CalledExpectation = XCTestExpectation(description: "task01 called")
        let task01CompletionCalledWithSuccessExpectation = XCTestExpectation(description: "task01 completion called with success")
        sut.enqueue(
            task: {
                task01CalledExpectation.fulfill()
                Thread.sleep(forTimeInterval: 1)
                return task01Output
            },
            completion: { taskResult in
                if case let .success(value) = taskResult,
                    value == task01Output {
                    task01CompletionCalledWithSuccessExpectation.fulfill()
                }
            }
        )
        wait(
            for: [task01CalledExpectation, task01CompletionCalledWithSuccessExpectation],
            timeout: 3
        )
    }

    // Task01 -------🎬-------------------1️⃣📦---->
    // Task02 --------------🎬---2️⃣📦------------->
    // Completion ---------------2️⃣📦------------->
    func test_enqueueingSuccedingIn2500msTaskAndSuccedingIn500msTask_mustCallBothTasksButOnlySecondTaskCompletion() {
        let sut = AsyncTaskSwitcherDefault<TaskOutput>()
        let task02Output: TaskOutput = "2️⃣📦"
        let task01CalledExpectation = XCTestExpectation(description: "task01 called")
        let task02CalledExpectation = XCTestExpectation(description: "task02 called")
        let task01CompletionNotCalledExpectation = XCTestExpectation(description: "task01 completion not called")
        task01CompletionNotCalledExpectation.isInverted = true
        let task02CompletionCalledWithSuccessExpectation = XCTestExpectation(description: "task02 completion called with success")
        sut.enqueue(
            task: {
                task01CalledExpectation.fulfill()
                Thread.sleep(forTimeInterval: 2.5)
                return "1️⃣📦"
            },
            completion: { _ in
                task01CompletionNotCalledExpectation.fulfill()
            }
        )
        Thread.sleep(forTimeInterval: 0.5) // to ensure task starting order
        sut.enqueue(
            task: {
                task02CalledExpectation.fulfill()
                Thread.sleep(forTimeInterval: 0.5)
                return task02Output
            },
            completion: { taskResult in
                if case let .success(value) = taskResult,
                    value == task02Output {
                    task02CompletionCalledWithSuccessExpectation.fulfill()
                }
            }
        )
        wait(
            for: [
                task01CalledExpectation,
                task02CalledExpectation,
                task01CompletionNotCalledExpectation,
                task02CompletionCalledWithSuccessExpectation
            ],
            timeout: 5
        )
    }

    // Task01 -------🎬-------------------📦------>
    // Task02 --------------🎬---❌--------------->
    // Completion ---------------❌--------------->
    func test_enqueueingSuccedingIn2500msTaskAndFailingIn500msTask_mustCallBothTasksButOnlySecondTaskCompletion() {
        let sut = AsyncTaskSwitcherDefault<TaskOutput>()
        let task01CalledExpectation = XCTestExpectation(description: "task01 called")
        let task02CalledExpectation = XCTestExpectation(description: "task02 called")
        let task01CompletionNotCalledExpectation = XCTestExpectation(description: "task01 completion not called")
        task01CompletionNotCalledExpectation.isInverted = true
        let task02CompletionCalledWithFailureExpectation = XCTestExpectation(description: "task02 completion called with failure")
        sut.enqueue(
            task: {
                task01CalledExpectation.fulfill()
                Thread.sleep(forTimeInterval: 2.5)
                return "📦" as TaskOutput
            },
            completion: { _ in
                task01CompletionNotCalledExpectation.fulfill()
            }
        )
        Thread.sleep(forTimeInterval: 0.5) // to ensure task starting order
        sut.enqueue(
            task: {
                task02CalledExpectation.fulfill()
                Thread.sleep(forTimeInterval: 0.5)
                throw FakeError()
            },
            completion: { taskResult in
                if case .failure = taskResult {
                    task02CompletionCalledWithFailureExpectation.fulfill()
                }
            }
        )
        wait(
            for: [
                task01CalledExpectation,
                task02CalledExpectation,
                task01CompletionNotCalledExpectation,
                task02CompletionCalledWithFailureExpectation
            ],
            timeout: 5
        )
    }
}
