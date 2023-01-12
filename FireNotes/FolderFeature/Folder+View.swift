import SwiftUI
import SwiftUINavigation
import CasePaths

// TODO: read
// refactor, chunks in fileprivate views or ViewBuilder funcs
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
      .listRowBackground(Color(UIColor.systemGray6))
    }
    .scrollContentBackground(Visibility.hidden)
    
    // TODO: Bug where preview switches immediately back to non-edit mode when edit mode is activated
    .bind(Binding<EditMode>(
      get: { vm.isEditing ? .active : .inactive },
      set: { vm.isEditing = $0 == .active }
    ),to: Binding<EditMode>(
      get: { editMode?.wrappedValue ?? .inactive },
      set: { editMode?.animation().wrappedValue = $0 }
    ))
    .navigationBarBackButtonHidden(vm.isEditing)
    .toolbar {
      if vm.isEditing {
        ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
          Button {
            vm.selectAllButtonTapped()
          } label: {
            Text(vm.hasSelectedAll ? "Deselect All" : "Select All")
          }
        }
        ToolbarItemGroup(placement: .primaryAction) {
          Button {
            vm.toggleEditButtonTapped()
          } label: {
            Text("Done")
          }
        }
        ToolbarItemGroup(placement: .bottomBar) {
          editingBottomToolbar()
        }
      }
      else {
        ToolbarItemGroup(placement: .primaryAction) {
          menu()
        }
        ToolbarItemGroup(placement: .bottomBar) {
          nonEditingBottomToolbar()
        }
      }
    }
    .searchable(text: $vm.search)
    .navigationBarTitle(vm.folder.name)
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
    .alert(
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.alert
    ) { alertAction in
      vm.alertButtonTapped(alertAction)
    }
  }
}

extension FolderView {
  private struct NoteRow: View {
    let note: Note
    var body: some View {
      VStack(alignment: .leading) {
        Text(note.title)
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
  
  @ViewBuilder
  func menu() -> some View {
    Menu {
      // Select
      Button {
        vm.toggleEditButtonTapped()
      } label: {
        HStack {
          Text("Select")
          Image(systemName: "checkmark.circle")
        }
      }
      
      // Sort
      Button {
      } label: {
        HStack {
          Text("Sort")
          Image(systemName: "arrow.up.arrow.down")
        }
      }
      
      // Add
      Button {
      } label: {
        HStack {
          Text("Add Subfolder")
          Image(systemName: "folder.badge.plus")
        }
      }
      
      // Move
      Button {
      } label: {
        HStack {
          Text("Move")
          Image(systemName: "folder")
        }
      }
      
      // Rename
      Button {
      } label: {
        HStack {
          Text("Rename")
          Image(systemName: "pencil")
        }
      }
    } label: {
      Image(systemName: "ellipsis.circle")
    }
  }
  
  @ViewBuilder
  private func nonEditingBottomToolbar() -> some View {
    Spacer()
    Text("\(vm.folder.notes.count) notes")
    Spacer()
    Button {
      vm.addNoteButtonTappped()
    } label: {
      Image(systemName: "square.and.pencil")
    }
  }
  
  @ViewBuilder
  private func editingBottomToolbar() -> some View {
    Button {
      vm.renameSelectedTapped()
    } label: {
      Image(systemName: "rectangle.and.pencil.and.ellipsis")
      
    }
    .disabled(vm.select.count == 0)
    Spacer()
    Button {
      //          vm.moveSelectedTapped()
    } label: {
      Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
      
    }
    .disabled(vm.select.count == 0)
    Spacer()
    Button {
      vm.deleteSelectedTapped()
    } label: {
      Image(systemName: "trash")
    }
    .disabled(vm.select.count == 0)
  }
}

struct FolderView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      FolderView(vm: .init())
    }
  }
}
