import SwiftUI

// MARK: - View
struct AppView: View {
  @ObservedObject var vm: AppViewModel
  
  var body: some View {
    NavigationStack {
      HomeView(vm: .init(folders: .init(uniqueElements: mockFolders)))
    }
    .accentColor(.yellow)
  }
}

// MARK: - Previews
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(vm: .init())
  }
}
