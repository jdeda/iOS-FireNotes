import SwiftUI
import SwiftUINavigation
import CasePaths

// MARK: - View
struct FolderViewToolbar: ToolbarContent {
  @ObservedObject var vm: FolderViewModel
  
  var body: some ToolbarContent {
    if vm.isEditing {
      editingToolbar()
    }
    else {
      nonEditingToolbar()
    }
  }
}
// MARK: - Helper Views
extension FolderViewToolbar {
  
  @ToolbarContentBuilder
  func editingToolbar() -> some ToolbarContent {
    ToolbarItemGroup(placement: .primaryAction) {
      Button {
        vm.toolbarDoneButtonTapped()
      } label: {
        Text("Done")
      }
      .foregroundColor(.yellow)
    }
    
    ToolbarItemGroup(placement: .bottomBar) {
      Button {
        vm.toolbarRenameSelectedButtonTapped()
      } label: {
        Image(systemName: "rectangle.and.pencil.and.ellipsis")
      }
      .disabled(vm.select.count == 0)
      
      Spacer()
      
      Button {
        vm.toolbarMoveSelectedButtonTapped()
      } label: {
        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
      }
      .disabled(vm.select.count == 0)
      
      Spacer()
      
      Button {
        vm.toolbarDeleteSelectedButtonTapped()
      } label: {
        Image(systemName: "trash")
      }
      .disabled(vm.select.count == 0)
    }
  }
  
  @ToolbarContentBuilder
  func nonEditingToolbar() -> some ToolbarContent {
    ToolbarItemGroup(placement: .primaryAction) {
      Button {
        vm.editSheetAppearButtonTapped()
      } label: {
        Image(systemName: "ellipsis.circle")
      }
      .foregroundColor(.yellow)
    }
    ToolbarItemGroup(placement: .bottomBar) {
      Spacer()
      Text("\(vm.folder.notes.count) Notes")
        .font(.caption)
      Spacer()
      Button {
        vm.addNoteButtonTappped()
      } label: {
        Image(systemName: "square.and.pencil")
      }
    }
  }
}
