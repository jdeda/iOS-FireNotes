import SwiftUI
import SwiftUINavigation
import CasePaths

// MARK: - View
struct HomeView: View {
  @ObservedObject var vm: HomeViewModel
  @Environment(\.isSearching) var isSearching
  
  var body: some View {
    List(selection: vm.isEditing ? $vm.selectedFolders : .constant([])) {
      Section {
        RowView(folder: vm.allFolder)
          .onTapGesture { vm.folderRowTapped(vm.allFolder) }
        
        RowView(folder: vm.standardFolder)
          .onTapGesture { vm.folderRowTapped(vm.standardFolder) }
        
        RowView(folder: vm.recentlyDeletedFolder, imageName: "trash")
          .onTapGesture { vm.folderRowTapped(vm.recentlyDeletedFolder) }
      } header: {
        Text("System")
      }
      Section {
        ForEach(vm.userFolders) { folder in
          RowView(folder: folder)
            .onTapGesture { vm.folderRowTapped(folder) }
            .tag(folder.id)
            .swipeActions(edge: .trailing) {
              Button { vm.deleteFolderButtonTapped(folder) } label: {
                Label("Delete", systemImage: "trash")
              }.tint(.red)
            }
        }
        .deleteDisabled(true)
      } header: {
        Text("User")
      }
    }
    .listStyle(SidebarListStyle())
    .environment(\.editMode, .constant(vm.isEditing ? .active : .inactive))
    .animation(.default, value: vm.isEditing)
    .toolbar { toolbar() }
    .searchable(
      text: .init(get: { vm.search }, set: { vm.setSearch($0) }),
      placement: .navigationBarDrawer(displayMode: .always)
    ) {
      SearchView(vm: .init(query: vm.search, notes: vm.searchedNotes, noteTapped: vm.searchButtonTapped))
    }
    .navigationBarTitle(vm.navigationBarTitle)
    .navigationBarBackButtonHidden(vm.isEditing)
    .navigationDestination(
      unwrapping: $vm.destination,
      case: /HomeViewModel.Destination.folder
    ) { $folderVM in
      FolderView(vm: folderVM)
    }
    .navigationDestination(
      unwrapping: $vm.destination,
      case: /HomeViewModel.Destination.note
    ) { $noteVM in
      NoteView(vm: noteVM)
    }
    //    .sheet(
    //      unwrapping: $vm.destination,
    //      case: /FolderViewModel.Destination.moveSheet
    //    ) { _ in
    //      Text("Move Sheet")
    //    }
    .sheet(
      unwrapping: $vm.destination,
      case: /HomeViewModel.Destination.editHomeSheet
    ) { $sheetVM in
      HomeEditSheet(vm: sheetVM)
        .presentationDetents([.fraction(0.25)])
    }
    .alert(
      unwrapping: $vm.destination,
      case: /HomeViewModel.Destination.alert,
      action: vm.alertButtonTapped
    )
    .sheet(
      unwrapping: $vm.destination,
      case: /HomeViewModel.Destination.renameSelectedSheet
    ) { $sheetVM in
      RenameSelectedSheet(vm: sheetVM)
    }
    //    .alert(
    //      title: { Text("Rename Folder") },
    //      unwrapping: $vm.destination,
    //      case: /FolderViewModel.Destination.renameAlert,
    //      actions: { _ in
    //        RenameAlert(name: vm.folder.name, submitName: vm.renameAlertConfirmButtonTapped)
    //      },
    //      message: { _ in }
    //    )
  }
}
// MARK: - Helper Views
extension HomeView {
  private struct RowView: View {
    let folder: Folder
    let imageName: String
    
    init(folder: Folder, imageName: String = "folder") {
      self.folder = folder
      self.imageName = imageName
    }
    
    var body: some View {
      HStack(alignment: .center) {
        Image(systemName: imageName)
          .foregroundColor(.accentColor)
        Text(folder.name)
          .foregroundColor(Color(light: .black, dark: .white))
        Spacer()
        Text("\(folder.notes.count)")
          .foregroundColor(Color(UIColor.systemGray))
        Image(systemName: "chevron.right")
          .foregroundColor(Color(UIColor.systemGray3))
          .fontWeight(.bold)
          .font(.caption)
          .frame(alignment: .top)
      }
      .padding(1)
    }
  }
}

// MARK: - Previews
struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      HomeView(vm: .init(
        userFolders: .init(uniqueElements: [mockFolderA, mockFolderB, mockFolderC]),
        standardFolderNotes: mockFolderD.notes,
        recentlyDeletedNotes: .init(uniqueElements: mockNotes)
      ))
    }
  }
}
