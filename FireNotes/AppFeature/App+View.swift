import SwiftUI
//import SwiftUINavigation

//enum Destination {
//  case Auth
//  case Home
//  case Folder
//  case Note
//}

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
    NavigationView {
      NavigationLink("Nice") {
        NoteView()
      }
    }
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView()
  }
}
