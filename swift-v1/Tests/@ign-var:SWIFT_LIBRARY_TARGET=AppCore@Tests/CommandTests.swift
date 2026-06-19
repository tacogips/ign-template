import Testing
@testable import @ign-var:SWIFT_LIBRARY_TARGET=AppCore@

@Test func commandReportsVersion() throws {
  let command = @ign-var:SWIFT_COMMAND_TYPE=AppCommand@(arguments: ["--version"])
  #expect(try command.run() == Version.current)
}

@Test func commandReportsUsage() throws {
  let command = @ign-var:SWIFT_COMMAND_TYPE=AppCommand@(arguments: ["--help"])
  #expect(try command.run().contains("Usage: @ign-var:EXECUTABLE_NAME={current_dir}@"))
}

@Test func commandRejectsUnknownFlags() throws {
  let command = @ign-var:SWIFT_COMMAND_TYPE=AppCommand@(arguments: ["--unknown"])
  do {
    _ = try command.run()
    Issue.record("Expected an unknown argument error")
  } catch @ign-var:SWIFT_COMMAND_TYPE=AppCommand@.Error.unknownArgument(let argument) {
    #expect(argument == "--unknown")
  } catch {
    Issue.record("Unexpected error: \(error)")
  }
}
