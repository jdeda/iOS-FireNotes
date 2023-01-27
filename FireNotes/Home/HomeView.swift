import SwiftUI
import SwiftUINavigation
import CasePaths

// MARK: - View
struct HomeView: View {
  @ObservedObject var vm: HomeViewModel
  @Environment(\.isSearching) var isSearching
  
  var body: some View {
    List(selection: $vm.selectedFolders) {
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
    .animation(Animation.spring(), value: vm.isEditing)
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

//import SwiftUI
//import SwiftUINavigation
//import CasePaths
//
//// MARK: - View
//struct HomeView: View {
//  @ObservedObject var vm: HomeViewModel
//  @State var isEditable = false
//  @Environment(\.isSearching) var isSearching
//
//  var body: some View {
//    List(selection: $vm.selectedFolders) {
//      Section {
//        RowView(folder: vm.allFolder)
//      } header: {
//        Text("All Notes")
//      }
//      Section {
//        ForEach(vm.folders) { folder in
//          RowView(folder: folder)
//            .tag(folder.id)
//            .swipeActions(edge: .trailing) {
//              Button(role: .destructive, action: { vm.deleteFolderButtonTapped(folder) } ) {
//                Label("Delete", systemImage: "trash")
//              }
//            }
//            .onTapGesture { vm.folderRowTapped(folder) }
//        }
//        .deleteDisabled(true)
//      } header: {
//        Text("Folders")
//
//      }
//      Section {
//        RowView(folder: vm.recentlyDeletedFolder, imageName: "trash")
//      } header: {
//        Text("Recently Deleted")
//      }
//    }
//    .accentColor(.yellow)
//    .environment(\.editMode, .constant(vm.isEditing ? .active : .inactive))
//    .animation(Animation.spring(), value: vm.isEditing)
//    .toolbar { toolbar() }
//    .onSubmit(of: .search, { vm.performSearch() })
//    .onChange(of: vm.search, perform: { _ in vm.performSearch() })
//    .onChange(of: isSearching, perform: { if $0 { vm.clearSearchedNotes() } })
//    .searchable(text: $vm.search, placement: .navigationBarDrawer(displayMode: .always)) {
//      //      Search(vm: SearchViewModel(notes: vm.searchedNotes), query: vm.search)
//    }
//    .navigationBarTitle(vm.navigationBarTitle)
//    .navigationBarBackButtonHidden(vm.isEditing)
//    .navigationDestination(
//      unwrapping: $vm.destination,
//      case: /HomeViewModel.Destination.folder
//    ) { $folderVM in
//      FolderView(vm: folderVM)
//    }
//    //    .navigationDestination(
//    //      unwrapping: $vm.destination,
//    //      case: /FolderViewModel.Destination.note
//    //    ) { $noteVM in
//    //      NoteView(vm: noteVM)
//    //    }
//    //    .sheet(
//    //      unwrapping: $vm.destination,
//    //      case: /FolderViewModel.Destination.moveSheet
//    //    ) { _ in
//    //      Text("Move Sheet")
//    //    }
//    .sheet(
//      unwrapping: $vm.destination,
//      case: /HomeViewModel.Destination.editHomeSheet
//    ) { $sheetVM in
//      HomeEditSheet(vm: sheetVM)
//        .presentationDetents([.fraction(0.25)])
//    }
//    .alert(
//      unwrapping: $vm.destination,
//      case: /HomeViewModel.Destination.alert,
//      action: vm.alertButtonTapped
//    )
//    .sheet(
//      unwrapping: $vm.destination,
//      case: /HomeViewModel.Destination.renameSelectedSheet
//    ) { $sheetVM in
//      RenameSelectedSheet(vm: sheetVM)
//    }
//    //    .alert(
//    //      title: { Text("Rename Folder") },
//    //      unwrapping: $vm.destination,
//    //      case: /FolderViewModel.Destination.renameAlert,
//    //      actions: { _ in
//    //        RenameAlert(name: vm.folder.name, submitName: vm.renameAlertConfirmButtonTapped)
//    //      },
//    //      message: { _ in }
//    //    )
//  }
//}
//// MARK: - Helper Views
//extension HomeView {
//  private struct RowView: View {
//    let folder: Folder
//    let imageName: String
//
//    init(folder: Folder, imageName: String = "folder") {
//      self.folder = folder
//      self.imageName = imageName
//    }
//
//    var body: some View {
//      HStack(alignment: .center) {
//        Image(systemName: imageName)
//          .foregroundColor(Color.yellow)
//        Text(folder.name)
//          .foregroundColor(.black)
//        Spacer()
//        Text("\(folder.notes.count)")
//          .foregroundColor(Color(UIColor.systemGray))
//        Image(systemName: "chevron.right")
//          .foregroundColor(Color(UIColor.systemGray3))
//          .fontWeight(.bold)
//          .font(.caption)
//          .frame(alignment: .top)
//      }
//      .padding(1)
//    }
//  }
//}
//
//// MARK: - Previews
//struct HomeView_Previews: PreviewProvider {
//  static var previews: some View {
//    NavigationStack {
//      HomeView(vm: .init(folders: .init(uniqueElements: mockFolders)))
//    }
//  }
//}
