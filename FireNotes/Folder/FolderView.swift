import SwiftUI
import SwiftUINavigation
import CasePaths
import XCTestDynamicOverlay

// MARK: - View
struct FolderView: View {
  @ObservedObject var vm: FolderViewModel
  @Environment(\.isSearching) var isSearching
  
  var body: some View {
    List(selection: $vm.selectedNotes) {
      ForEach(vm.folder.notes) { note in
        VStack(alignment: .leading) {
          Text(note.title)
            .lineLimit(1)
            .fontWeight(.medium)
          HStack(spacing: 4)  {
            Text(note.formattedDate)
              .font(.caption)
              .foregroundColor(.secondary)
            Text(note.subTitle)
              .lineLimit(1)
              .font(.caption)
              .foregroundColor(.secondary)
          }
          if vm.folder.variant == .all {
            HStack(spacing: 4)  {
              Image(systemName: "folder")
              Text(note.folderName ?? "")
            }
            .font(.caption)
            .foregroundColor(.secondary)
          }
        }
        .padding(1)
        .tag(note.id)
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
      SearchView(vm: .init(query: vm.search, notes: vm.searchedNotes, noteTapped: vm.searchButtonTapped))
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
      case: /FolderViewModel.Destination.addSubfolderSheet
    ) { _ in
      Text("Add Subfolder Sheet")
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
  
  //        NoteRow(
  //          note: note,
  //          folderVariant: vm.folder.variant,
  //          deleteButtonTapped: vm.deleteNoteButtonTapped,
  //          rowTapped: vm.noteRowTapped
  //        )
  //          .padding(1)
  //          .tag(note.id)

  private struct NoteRow: View {
    let note: Note
    let folderVariant: Folder.Variant
    var deleteButtonTapped: (_ note: Note) -> Void = unimplemented("FolderView.NoteRow.deleteButtonTapped")
    var rowTapped: (_ note: Note) -> Void = unimplemented("FolderView.NoteRow.rowTapped")
    
    init(
      note: Note,
      folderVariant: Folder.Variant,
      deleteButtonTapped: @escaping (_ note: Note) -> Void,
      rowTapped: @escaping (_ note: Note) -> Void
    ) {
      self.note = note
      self.folderVariant = folderVariant
      self.deleteButtonTapped = deleteButtonTapped
      self.rowTapped = rowTapped
    }
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
      .swipeActions(edge: .trailing) {
        switch folderVariant {
        case .all:
          EmptyView()
        case .recentlyDeleted:
          Button { deleteButtonTapped(note) } label: {
            Label("Delete", systemImage: "trash")
          }.tint(.red)
        default:
          Button(role: .destructive) {
            deleteButtonTapped(note)
          } label: {
            Label("Delete", systemImage: "trash")
          }
        }
      }
      .onTapGesture { rowTapped(note) }
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
