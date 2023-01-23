import SwiftUI

@main
struct FireNotesApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(vm: .init())
        .onAppear {
          UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(.yellow)
        }
    }
  }
}
