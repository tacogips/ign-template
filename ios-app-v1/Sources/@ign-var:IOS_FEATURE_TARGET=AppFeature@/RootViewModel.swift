import Foundation

@MainActor
public final class RootViewModel: ObservableObject {
  @Published public private(set) var launchCount: Int

  public let appName: String

  public init(appName: String, launchCount: Int = 0) {
    self.appName = appName
    self.launchCount = launchCount
  }

  public func recordLaunch() {
    launchCount += 1
  }
}
