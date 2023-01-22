import SwiftUI
import SwiftUINavigation
import CasePaths

// MARK: - View
struct FolderView: View {
  @ObservedObject var vm: FolderViewModel
  @Environment(\.editMode) var editMode
  @Environment(\.isSearching) var isSearching

  var body: some View {
    List(selection: $vm.selectedNotes) {
      ForEach(vm.folder.notes) { note in
        NoteRow(note: note)
          .padding(1)
          .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: { vm.deleteNoteButtonTapped(note) } ) {
              Label("Delete", systemImage: "trash")
            }
          }
          .onTapGesture { vm.noteRowTapped(note) }
          .tag(note.id)
      }
      .deleteDisabled(true)
    }
    .toolbar { toolbar() } 
    .bind(Binding<EditMode>(
      get: { vm.isEditing ? .active : .inactive },
      set: { vm.isEditing = $0 == .active }
    ),
    to: Binding<EditMode>(
      get: { editMode?.wrappedValue ?? .inactive },
      set: { editMode?.animation().wrappedValue = $0 }
    ))
    .onSubmit(of: .search, { vm.performSearch() })
    .onChange(of: vm.search, perform: { _ in vm.performSearch() })
    .onChange(of: isSearching, perform: { if $0 { vm.clearSearchedNotes() } })
    .searchable(text: $vm.search, placement: .navigationBarDrawer(displayMode: .always)) {
      Search(vm: SearchViewModel(notes: vm.searchedNotes), query: vm.search)
    }
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
      case: /FolderViewModel.Destination.moveSheet
    ) { _ in
      Text("Move Sheet")
    }
    .sheet(
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.editFolderSheet
    ) { $sheetVM in
      FolderEditSheet(vm: sheetVM)
      .presentationDetents([.fraction(0.55)])
    }
    .sheet(
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.renameSelectedSheet
    ) { $sheetVM in
      RenameSelectedSheet(vm: sheetVM)
    }
    .alert(
      title: { Text("Rename Folder") },
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.renameAlert,
      actions: { _ in
        RenameAlert(name: vm.folder.name, submitName: vm.renameAlertConfirmButtonTapped)
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
