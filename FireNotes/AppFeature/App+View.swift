import SwiftUI

struct AppView: View {
  @FocusState var focus: Bool
  @State var text: String = "Nice"
  var body: some View {
    NavigationStack {
      HomeView(vm: HomeViewModel(
        folders: mockFolders,
        destination: HomeViewModel.Destination.folder(
          FolderViewModel(
            folder: mockFolders.first! // MARK: This can lead to invalid states! linking looks weird now...
//            destination: FolderViewModel.Destination.editSheet(
//              FolderEditSheetViewModel(folderName: mockFolders.first!.name)
//            )
          )
        )
      ))
    }
    .accentColor(.yellow)
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView()
  }
}
