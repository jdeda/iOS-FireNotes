import SwiftUI

// MARK: - View
struct AppView: View {
  @ObservedObject var vm: AppViewModel
  var body: some View {
    NavigationStack {
      HomeView.init(vm: .init(
        userFolders: .init(uniqueElements: mockFoldersV2),
        standardFolderNotes: mockFolderB.notes,
        recentlyDeletedNotes: .init(uniqueElements: mockFolderC.notes)
      ))
    }
  }
}

// MARK: - Previews
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(vm: .init())
  }
}
