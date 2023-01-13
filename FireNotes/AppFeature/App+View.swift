import SwiftUI

/**
 NavigationPaths
 Auth -------- Home ----| ---
 |                                  | ------- Folder  ------- Note
 Home -------------------|---
 */

struct AppView: View {
  @FocusState var focus: Bool
  @State var text: String = "Nice"
  var body: some View {
    NavigationStack {
      HomeView(vm: HomeViewModel(folders: mockFolders))
    }
    .accentColor(.yellow)
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView()
  }
}
