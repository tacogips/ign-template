import @ign-var:IOS_FEATURE_TARGET=AppFeature@
import SwiftUI

@main
struct @ign-var:IOS_APP_MAIN_TYPE=AppMain@: App {
  var body: some Scene {
    WindowGroup {
      RootView(model: RootViewModel(appName: "@ign-var:APP_DISPLAY_NAME={current_dir}@"))
    }
  }
}
