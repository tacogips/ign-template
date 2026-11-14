import Testing
@testable import @ign-var:IOS_FEATURE_TARGET=AppFeature@

@MainActor
struct RootViewModelTests {
  @Test
  func recordLaunchIncrementsLaunchCount() {
    let model = RootViewModel(appName: "Test", launchCount: 2)

    model.recordLaunch()

    #expect(model.launchCount == 3)
  }
}
