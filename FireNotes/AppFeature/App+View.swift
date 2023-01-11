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
      NavigationLink("Nice") {
        FolderView(vm: .init())
//        FolderView(vm: {
//          // This will not work properly as we do
//          // not have not properly binded the environment.
//          let rv = FolderViewModel()
//          rv.editMode = EditMode.active
//          return rv
//        }())
      }
    }
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView()
  }
}
