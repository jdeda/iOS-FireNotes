import SwiftUI
import SwiftUINavigation
import CasePaths

// MARK: - View
struct FolderView: View {
  @ObservedObject var vm: FolderViewModel
  @Environment(\.editMode) var editMode
  @Environment(\.isSearching) var isSearching

  var body: some View {
    List(selection: $vm.select) {
      ForEach(vm.folder.notes) { note in
        NoteRow(note: note)
          .padding(1)
          .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: { vm.deleteNote(note) } ) {
              Label("Delete", systemImage: "trash")
            }
          }
          .onTapGesture {
            vm.noteTapped(note)
          }
          .tag(note.id)
      }
      .deleteDisabled(true)
    }
    .bind(Binding<EditMode>(
      get: { vm.isEditing ? .active : .inactive },
      set: { vm.isEditing = $0 == .active }
    ),
    to: Binding<EditMode>(
      get: { editMode?.wrappedValue ?? .inactive },
      set: { editMode?.animation().wrappedValue = $0 }
    ))
    .toolbar {
      FolderViewToolbar(vm: vm)
    }
    .onChange(of: isSearching, perform: { newValue in
      if newValue { vm.clearSearchedNotes() }
    })
    /**
      Destinations collide...
      if i am in search...and i click a row...then my destination swaps to that note...which means the logic displaying the search,
      depends on the destination for the search, which means when u back out the search will be dismissed...
      so...you'd have to build logic so that doesnt happen
     also what happens if this is a global search...?and maybe u dont want that bottom toolbar button...i would though,
      but there'd be a side effect where adding a new note would have to be put into the global notes folder
     */
    .searchable(text: $vm.search, placement: .navigationBarDrawer(displayMode: .always)) {
      Search(vm: SearchViewModel(notes: vm.searchedNotes), query: vm.search)
    }
    .onSubmit(of: .search, { vm.performSearch() })
    .onChange(of: vm.search, perform: { _ in vm.performSearch() })
    .navigationBarTitle(vm.navigationBarTitle)
    .navigationBarBackButtonHidden(vm.isEditing)
    .navigationDestination(
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.note
    ) { $noteVM in
      NoteView(vm: noteVM)
    }
    .sheet(
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.userOptionsSheet
    ) { _ in
      UserSheet()
    }
    .sheet(
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.moveSheet
    ) { _ in
      Text("Move Sheet")
    }
    .sheet(
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.editSheet
    ) { $sheetVM in
      FolderEditSheet(vm: sheetVM)
      .presentationDetents([.fraction(0.55)])
    }
    .alert(
      title: { Text("Rename Folder") },
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.renameAlert,
      actions: { _ in
        RenameAlert(name: vm.folder.name, submitName: vm.renameAlertConfirmButtonTapped)
        .onAppear { UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(.yellow) }
      },
      message: { _ in }
    )
  }
}

// MARK: - Helper Views
extension FolderView {
  private struct NoteRow: View {
    let note: Note
    var body: some View {
      VStack(alignment: .leading) {
        Text(note.title)
          .fontWeight(.medium)
        HStack {
          Text(note.formattedDate)
            .font(.caption)
            .foregroundColor(.secondary)
          Text(note.subTitle)
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
    }
  }
}

// MARK: - Preview
struct FolderView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      FolderView(vm: .init(folder: mockFolderA))
    }
  }
}
