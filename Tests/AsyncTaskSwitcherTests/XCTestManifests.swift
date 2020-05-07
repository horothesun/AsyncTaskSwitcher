#if !canImport(ObjectiveC)
import XCTest

extension AsyncTaskSwitcherDefaultTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__AsyncTaskSwitcherDefaultTests = [
        ("test_enqueueingSingleFailingTask_mustCallTaskAndFailingCompletion", test_enqueueingSingleFailingTask_mustCallTaskAndFailingCompletion),
        ("test_enqueueingSingleSuccedingIn1sTask_mustCallTaskAndSuccedingCompletion", test_enqueueingSingleSuccedingIn1sTask_mustCallTaskAndSuccedingCompletion),
        ("test_enqueueingSuccedingIn2500msTaskAndFailingIn500msTask_mustCallBothTasksButOnlySecondTaskCompletion", test_enqueueingSuccedingIn2500msTaskAndFailingIn500msTask_mustCallBothTasksButOnlySecondTaskCompletion),
        ("test_enqueueingSuccedingIn2500msTaskAndSuccedingIn500msTask_mustCallBothTasksButOnlySecondTaskCompletion", test_enqueueingSuccedingIn2500msTaskAndSuccedingIn500msTask_mustCallBothTasksButOnlySecondTaskCompletion),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AsyncTaskSwitcherDefaultTests.__allTests__AsyncTaskSwitcherDefaultTests),
    ]
}
#endif
