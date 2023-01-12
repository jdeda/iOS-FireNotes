import SwiftUI
import SwiftUINavigation
import CasePaths

// TODO: read
// refactor, chunks in fileprivate views or ViewBuilder funcs
struct FolderView: View {
  @ObservedObject var vm: FolderViewModel
  @Environment(\.editMode) var editMode
  
  var body: some View {
    VStack(alignment: .leading) {
      TextField(vm.folder.name, text: $vm.folder.name)
        .font(.system(size: 34, weight: .bold))
        .padding([.leading], 18)
      
      Searchbar(searchText: $vm.search)
        .padding([.leading, .trailing], 18)
      
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
      .bind(Binding<EditMode>(
        get: { vm.isEditing ? .active : .inactive },
        set: { vm.isEditing = $0 == .active }
      ),to: Binding<EditMode>(
        get: { editMode?.wrappedValue ?? .inactive },
        set: { editMode?.animation().wrappedValue = $0 }
      ))
    }
    .navigationBarBackButtonHidden(vm.isEditing)
    .toolbar {
      if vm.isEditing {
        ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
          if !vm.hasSelectedAll {
            Button {
              vm.selectAllButtonTapped()
            } label: {
              Text("Select All")
            }
          }
          else {
            Button {
              vm.deselectAllButtonTapped()
            } label: {
              Text("Deselect All")
            }
          }
        }
      }
      ToolbarItemGroup(placement: .primaryAction) {
        if vm.isEditing {
          Button {
            vm.toggleEditMode()
          } label: {
            Text("Done")
          }
        }
        else {
          menu()
        }
      }
      
      ToolbarItemGroup(placement: .bottomBar) {
        if vm.isEditing {
          editingToolbar()
        }
        else {
          nonEditingToolbar()
        }
      }
    }
    .navigationBarTitle("")
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
      // Select Mode
      Button {
        vm.toggleEditMode()
      } label: {
        HStack {
          Text("Select")
          Image(systemName: "checkmark.circle.fill")
        }
      }
      
      // Sort by
      Button {
//        vm.toggleEditMode()
      } label: {
        HStack {
          Text("Sort")
          Image(systemName: "checkmark.circle.fill")
        }
      }
      
      // Filter by
      Button {
//            vm.toggleEditMode()
      } label: {
        HStack {
          Text("Filter")
          Image(systemName: "checkmark.circle.fill")
        }
      }

    } label: {
      Image(systemName: "ellipsis.circle")
    }
  }
  
  @ViewBuilder
  private func nonEditingToolbar() -> some View {
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
  private func editingToolbar() -> some View {
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
      FolderView(vm: {
        var rv = FolderViewModel()
        //        rv.editMode = EditMode.active
        return rv
      }())
    }
  }
}
