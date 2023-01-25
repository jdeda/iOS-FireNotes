import SwiftUI

// MARK: - View
struct AppView: View {
  @ObservedObject var vm: AppViewModel
  
  var body: some View {
    NavigationStack {
      HomeView(vm: .init(
        userFolders: .init(uniqueElements: [mockFolderA, mockFolderB, mockFolderC]),
        standardFolderNotes: mockFolderD.notes,
        recentlyDeletedNotes: .init(uniqueElements: mockNotes)
      ))
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
