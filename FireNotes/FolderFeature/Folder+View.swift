import SwiftUI
import SwiftUINavigation
import CasePaths

// TODO: read
// refactor, chunks in fileprivate views or ViewBuilder funcs
struct FolderView: View {
  @ObservedObject var vm: FolderViewModel
  @Environment(\.editMode) var editMode
  
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
  private func nonEditingToolbar() -> some View {
    Spacer()
    Text("\(vm.folder.notes.count) notes \(vm.editMode == .inactive ? "inactive" : "active" )")
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
      Text(vm.select.count == 0 ? "Rename all " : "Rename")
        .frame(alignment: .leading)
    }
    Spacer()
    Button {
      //          vm.moveSelectedTapped()
    } label: {
      Text(vm.select.count == 0 ? "Move all " : "Move")
        .frame(alignment: .center)
    }
    Spacer()
    Button {
      vm.deleteSelectedTapped()
    } label: {
      Text(vm.select.count == 0 ? "Delete all " : "Delete")
        .frame(alignment: .trailing)
    }
  }
  
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
      .bind($vm.editMode, to: Binding<EditMode?>(
        get: {
          guard let editMode = editMode
          else { return .none }
          return editMode.wrappedValue
        },
        set: { newValue  in
          // TODO: we don't know how to write the value to the environment. Nice.
        }
      ))
      .toolbar { EditButton() }
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
        if vm.editMode == .active || vm.editMode == .transient {
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
      case: /FolderViewModel.Destination.Note
    ) { $noteVM in
      NoteView(vm: noteVM)
    }
    .sheet(
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.UserOptionsSheet
    ) { _ in
      UserSheet()
    }
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
