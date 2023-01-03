import SwiftUI
import SwiftUINavigation

struct HomeView: View {
  @ObservedObject var vm: HomeViewModel = .init()
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Folders")
        .font(.system(size: 34, weight: .bold))
        .padding([.leading], 18)
      
      Searchbar(searchText: $vm.search)
        .padding([.leading, .trailing], 18)
      
      List {
        ForEach(vm.folders) { folder in
          HStack(alignment: .firstTextBaseline) {
            Image(systemName: "folder")
              .foregroundColor(Color.accentColor)
            Text(folder.name)
            Spacer()
            Text("\(folder.notes.count)")
              .foregroundColor(.secondary)
          }
        }
        .onDelete(perform: vm.delete)
        .listRowBackground(Color(UIColor.systemGray6))
      }
      .scrollContentBackground(Visibility.hidden)
    }
    .navigationDestination(
      unwrapping: $vm.destination,
      case: /HomeViewModel.Destination.Folder
    ) { $folderVM in
      FolderView(vm: folderVM)
    }
    .toolbar {
      ToolbarItemGroup(placement: .primaryAction) {
        Button {
          vm.tappedUserOptionsButton()
        } label: {
          Image(systemName: "ellipsis.circle")
        }
      }
      ToolbarItemGroup(placement: .bottomBar) {
        Button {
          vm.addFolderButtonTappped()
        } label: {
          Image(systemName: "folder.badge.plus")
        }
        Spacer()
        Text("\(vm.folders.count) notes")
        Spacer()
        Button {
          vm.addNoteButtonTapped()
        } label: {
          Image(systemName: "square.and.pencil")
        }
      }
    }
    .navigationBarTitle("")
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      HomeView()
    }
  }
}
