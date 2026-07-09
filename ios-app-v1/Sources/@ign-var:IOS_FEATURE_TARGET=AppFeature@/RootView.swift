import SwiftUI

public struct RootView: View {
  @StateObject private var model: RootViewModel

  public init(model: RootViewModel) {
    _model = StateObject(wrappedValue: model)
  }

  public var body: some View {
    NavigationStack {
      VStack(alignment: .leading, spacing: 20) {
        VStack(alignment: .leading, spacing: 8) {
          Text(model.appName)
            .font(.largeTitle)
            .fontWeight(.semibold)

          Text("SwiftUI iOS app")
            .font(.headline)
            .foregroundStyle(.secondary)
        }

        VStack(alignment: .leading, spacing: 12) {
          Text("Launch count")
            .font(.subheadline)
            .foregroundStyle(.secondary)

          Text("\(model.launchCount)")
            .font(.system(.title, design: .rounded, weight: .bold))
            .contentTransition(.numericText())
        }

        Button {
          withAnimation(.snappy) {
            model.recordLaunch()
          }
        } label: {
          Label("Record Launch", systemImage: "plus.circle.fill")
        }
        .buttonStyle(.borderedProminent)

        Spacer()
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
      .navigationTitle(model.appName)
    }
  }
}

#Preview {
  RootView(model: RootViewModel(appName: "Preview"))
}
