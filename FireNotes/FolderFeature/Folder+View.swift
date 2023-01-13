import SwiftUI
import SwiftUINavigation
import CasePaths

// TODO: Jesse Deda
// Start a list of Swift things

// MARK: - View
struct FolderView: View {
  @ObservedObject var vm: FolderViewModel
  @Environment(\.editMode) var editMode
  
  var body: some View {
    List(selection: $vm.select) {
      ForEach(vm.folder.notes) { note in
        NoteRow(note: note)
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
    
    // TODO: Bug where preview switches immediately back to non-edit mode when edit mode is activated
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
    .searchable(text: $vm.search, placement: .navigationBarDrawer(displayMode: .always))
    .navigationBarTitle(vm.folder.name)
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
    ) { _ in
      NavigationStack {
        FolderEditSheet(vm: vm)
          .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
              HStack {
                Image(systemName: "folder.fill")
                  .font(.title3)
                  .foregroundColor(.yellow)
                Text(vm.folder.name)
              }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
              Button {
                 vm.editSheetDismissButtonTapped()
              } label: {
                Image(systemName: "xmark.circle.fill")
              }
              .foregroundColor(Color(UIColor.systemGray2))
            }
          }
      }
      .presentationDetents([.fraction(0.5)])
    }
    .alert(
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.alert
    ) { alertAction in
      vm.alertButtonTapped(alertAction)
    }
  }
}

// MARK: - Helper Views
extension FolderView {
  struct NoteRow: View {
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
      FolderView(vm: .init())
    }
  }
}
 
