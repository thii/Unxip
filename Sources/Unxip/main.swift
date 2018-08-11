import Foundation

#if canImport(UnxipKit)
import UnxipKit
#endif

let args = CommandLine.arguments

if args.count == 1 || args.contains("-h") || args.contains("--help") {
    print("Usage: unxip <input-xip-file> [<output-directory>]", terminator: "\n\n")
    print("       Extract a signed archive.")
    exit(0)
}

let inputXipFile = args[1]
let outputPath = args.count == 2 ? "." : args.last!
let inputUrl = URL(fileURLWithPath: inputXipFile)

// Remove 'file://'
let absoluteOutputPath = String(URL(fileURLWithPath: outputPath).absoluteString.dropFirst(7))

var runner = Runner()
runner.lock()

do {
    let container = try PKSignedContainer(forReadingFromContainerAt: inputUrl)

    container.startUnarchiving(
        atPath: absoluteOutputPath,
        notifyOn: .main,
        progress: { progress, progressText in
            if progress < 0 {
                // Verifying digital signature
                print(progressText)
            } else {
                print(progressText + ": \(Int(progress))%", terminator: "\r")
            }
    }) { _ in
        runner.unlock()
    }

    runner.wait()
} catch {
    print(error.localizedDescription)
    exit(1)
}
