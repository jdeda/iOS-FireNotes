import SwiftUI
import SwiftUINavigation
import CasePaths

/**
 There are several different Folder types, each with their own functionality
 - user
 - rename folder
 - delete folder
 - move folder
 - sort notes
 - select notes
 - rename notes
 - delete notes
 - move notes
 - edit note
 
 - standard
 - sort notes
 - select notes
 - rename notes
 - delete notes
 - move notes
 - edit note
 
 - recentlyDeleted (restore means move note to standard)
 - sort notes
 - select notes
 - delete notes
 - move notes
 - restore note
 * note: when restoring a single note, you should already be in the nav for the note, but the back button should change to the standard folder
 
 - all (mutating notes must pullback to mutate specific folder)
 - sort notes
 - edit note
 - navigate to folder button
 */

// MARK: - View
struct FolderView: View {
  @ObservedObject var vm: FolderViewModel
  @Environment(\.isSearching) var isSearching
  
  var body: some View {
    List(selection: $vm.selectedNotes) {
      ForEach(vm.folder.notes) { note in
        NoteRow(note: note)
          .padding(1)
          .swipeActions(edge: .trailing) {
            switch vm.folder.variant {
            case .all:
              EmptyView()
            case .recentlyDeleted:
              Button { vm.deleteNoteButtonTapped(note) } label: {
                Label("Delete", systemImage: "trash")
              }.tint(.red)
            default:
              Button(role: .destructive) {
                vm.deleteNoteButtonTapped(note)
              } label: {
                Label("Delete", systemImage: "trash")
              }
            }
          }
          .onTapGesture { vm.noteRowTapped(note) }
          .tag(note.id)
      }
      .deleteDisabled(true)
    }
    .toolbar { toolbar() }
    .environment(\.editMode, .constant(vm.isEditing ? .active : .inactive))
    .animation(.default, value: vm.isEditing)
    .searchable(
      text: .init(get: { vm.search }, set: { vm.setSearch($0) }),
      placement: .navigationBarDrawer(displayMode: .always)
    ) {
      SearchView(vm: .init(query: vm.search, notes: vm.searchedNotes))
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
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.alert
    ) { alertAction in
      vm.alertButtonTapped(alertAction)
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
