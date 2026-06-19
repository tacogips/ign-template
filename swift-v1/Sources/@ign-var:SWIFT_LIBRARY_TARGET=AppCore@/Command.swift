import Foundation

public struct @ign-var:SWIFT_COMMAND_TYPE=AppCommand@: Sendable {
  public enum Error: Swift.Error, Equatable, Sendable {
    case unknownArgument(String)
  }

  public let arguments: [String]

  public init(arguments: [String]) {
    self.arguments = arguments
  }

  public func run() throws -> String {
    if arguments.contains("--version") {
      return Version.current
    }

    if arguments.contains("--help") || arguments.contains("-h") {
      return usage
    }

    if let firstUnknown = arguments.first(where: { $0.hasPrefix("-") }) {
      throw Error.unknownArgument(firstUnknown)
    }

    return "Hello from @ign-var:EXECUTABLE_NAME={current_dir}@"
  }

  public var usage: String {
    """
    Usage: @ign-var:EXECUTABLE_NAME={current_dir}@ [--help] [--version]
    """
  }
}
