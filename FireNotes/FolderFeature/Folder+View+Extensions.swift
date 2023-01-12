import SwiftUI
import SwiftUINavigation
import CasePaths

let mockFolder: Folder = .init(
  id: .init(),
  name: "Folder 1",
  notes: .init(uniqueElements: (1...20).map {
    .init(
      id: .init(),
      title: "Note \($0)",
      body: "I ate \($0)g of protein today"
      //      lastEditDate: Date().addingTimeInterval(TimeInterval(Int($0) * 60 * 60 * 24)),
      //      creationDate: Date().addingTimeInterval(TimeInterval(Int($0) * 60 * 60 * 24))
    )
  })
)

struct ToolBar: ToolbarContent {
  @ObservedObject var vm: FolderViewModel
  
  //  @ViewBuilder
  //  func menu() -> some View {
  //    Menu {
  //      // Select
  //      Button {
  //        vm.toggleEditButtonTapped()
  //      } label: {
  //        HStack {
  //          Text("Select")
  //          Image(systemName: "checkmark.circle")
  //        }
  //      }
  //
  //      // Sort
  //      Menu {
  //        Picker("Sort", selection: $vm.sort) {
  //          ForEach(FolderViewModel.Sort.allCases, id: \.self) { sort in
  //            Text(sort.string)
  //          }
  //        }
  //      } label: {
  //        Label("Sort", systemImage: "arrow.up.arrow.down")
  //      }
  //      .menuIndicator(.hidden)
  //
  //      // Add
  //      Button {
  //      } label: {
  //        Label("Add Subfolder", systemImage: "folder.badge.plus")
  //      }
  //
  //      // Move
  //      Button {
  //      } label: {
  //        Label("Move", systemImage: "folder")
  //      }
  //
  //      // Rename
  //      Button {
  //      } label: {
  //        Label("Rename", systemImage: "pencil")
  //      }
  //    } label: {
  //      Image(systemName: "ellipsis.circle")
  //    }
  //  }
  //
  //  @ViewBuilder
  //  func nonEditingBottomToolbar() -> some View {
  //    Spacer()
  //    Text("\(vm.folder.notes.count) notes")
  //    Spacer()
  //    Button {
  //      vm.addNoteButtonTappped()
  //    } label: {
  //      Image(systemName: "square.and.pencil")
  //    }
  //  }
  //
  @ViewBuilder
  func editingBottomToolbar() -> some View {
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
  
  var body: some ToolbarContent {
    ToolbarItemGroup {
      Button {
        vm.selectAllButtonTapped()
      } label: {
        Text(vm.hasSelectedAll ? "Deselect All" : "Select All")
      }
      
      if vm.isEditing {
        Button {
          vm.toggleEditButtonTapped()
        } label: {
          Text("Done")
        }
        editingBottomToolbar()
      }
      else {
      }
      //      else {
      ////        ToolbarItemGroup(placement: .primaryAction) {
      ////          menu()
      ////        }
      ////        ToolbarItemGroup(placement: .bottomBar) {
      ////          nonEditingBottomToolbar()
      ////        }
      //      }
    }
  }
}

extension FolderView {
  struct NoteRow: View {
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
}
