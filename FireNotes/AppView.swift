import SwiftUI

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
    var body: some View {
      NavigationView {
        NavigationLink.init("Nice") {
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
