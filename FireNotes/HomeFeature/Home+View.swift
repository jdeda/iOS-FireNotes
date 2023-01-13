import SwiftUI
import SwiftUINavigation

struct HomeView: View {
  @ObservedObject var vm: HomeViewModel = .init()
  
  var body: some View {
    List {
      ForEach(vm.folders) { folder in
        Button {
          vm.folderTapped(folder)
        } label: {
          RowView(folder: folder)
        }
      }
    }
    .navigationDestination(
      unwrapping: $vm.destination,
      case: /HomeViewModel.Destination.folder
    ) { $folderVM in
      FolderView(vm: folderVM)
    }
    .searchable(text:$vm.search, placement: .navigationBarDrawer(displayMode: .always))
    .navigationTitle("Folders")
  }
}

extension HomeView {
  private struct RowView: View {
    let folder: Folder
    var body: some View {
      HStack(alignment: .center) {
        Image(systemName: "folder")
          .foregroundColor(Color.yellow)
        Text(folder.name)
          .foregroundColor(.black)
        Spacer()
        Text("\(folder.notes.count)")
          .foregroundColor(Color(UIColor.systemGray))
        Image(systemName: "chevron.right")
          .foregroundColor(Color(UIColor.systemGray3))
          .fontWeight(.bold)
          .font(.caption)
          .frame(alignment: .top)
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
