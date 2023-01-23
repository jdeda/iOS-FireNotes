import SwiftUI

struct AppView: View {
  @ObservedObject var vm: AppViewModel
  
  var body: some View {
    NavigationStack {
      HomeView(vm: .init(folders: .init(uniqueElements: mockFolders)))
//      FolderView(vm: .init(folder: mockFolder))
    }
    .accentColor(.yellow)
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(vm: .init())
  }
}
