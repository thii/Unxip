import Foundation

class Runner {

    /// A poor man's mutex.
    private var count = 0

    /// Current run loop.
    private let runLoop = RunLoop.current

    /// Initializer.
    init() {}

    /// Lock the script runner.
    func lock() {
        count += 1
    }

    /// Unlock the script runner.
    func unlock() {
        count -= 1
    }

    /// Wait for all locks to unlock.
    func wait() {
        while count > 0 &&
            runLoop.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.1)) {
                // Run, run, run
        }
    }
}
