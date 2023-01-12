import SwiftUI
import SwiftUINavigation

struct HomeView: View {
  @ObservedObject var vm: HomeViewModel = .init()
  
  var body: some View {
    List {
      ForEach(vm.folders) { folder in
        RowView(folder: folder)
          .onTapGesture {
            vm.folderTapped(folder)
          }
      }
      .listRowBackground(Color(UIColor.systemGray6))
    }
    .scrollContentBackground(Visibility.hidden)
    .navigationDestination(
      unwrapping: $vm.destination,
      case: /HomeViewModel.Destination.folder
    ) { $folderVM in
      FolderView(vm: folderVM)
    }
    .navigationTitle("Folders")
    .searchable(text: $vm.search)
  }
}

extension HomeView {
  private struct RowView: View {
    let folder: Folder
    var body: some View {
      HStack(alignment: .firstTextBaseline) {
        Image(systemName: "folder")
          .foregroundColor(Color.accentColor)
        Text(folder.name)
        Spacer()
        Text("\(folder.notes.count)")
          .foregroundColor(.secondary)
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      HomeView()
    }
  }
}
