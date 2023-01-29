import SwiftUI

// MARK: - View
extension HomeView {
  @ToolbarContentBuilder
  func toolbar()  -> some ToolbarContent {
    if vm.isEditing {
      editingToolbar()
    }
    else {
      nonEditingToolbar()
    }
  }
}

// MARK: - Helper Views
extension HomeView {
  
  @ToolbarContentBuilder
  private func editingToolbar() -> some ToolbarContent {
    ToolbarItemGroup(placement: .navigationBarLeading) {
      Button {
        vm.selectAllButtonTapped()
      } label: {
        Text(vm.hasSelectedAll ? "Deselect All" : "Select All")
      }
    }
    
    ToolbarItemGroup(placement: .primaryAction) {
      Button {
        vm.toolbarDoneButtonTapped()
      } label: {
        Text("Done")
      }
    }
    
    ToolbarItemGroup(placement: .bottomBar) {
      Button {
        vm.toolbarRenameSelectedButtonTapped()
      } label: {
        Image(systemName: "rectangle.and.pencil.and.ellipsis")
      }
      .disabled(vm.selectedFolders.count == 0)
      
      Spacer()
      
      Button {
        vm.toolbarMoveSelectedButtonTapped()
      } label: {
        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
      }
      .disabled(vm.selectedFolders.count == 0)
      
      Spacer()
      
      Button {
        vm.toolbarDeleteSelectedButtonTapped()
      } label: {
        Image(systemName: "trash")
      }
      .disabled(vm.selectedFolders.count == 0)
    }
  }

  @ToolbarContentBuilder
  private func nonEditingToolbar() -> some ToolbarContent {
    ToolbarItemGroup(placement: .primaryAction) {
      Button {
        vm.toolbarAppearEditSheetButtonTapped()
      } label: {
        Image(systemName: "ellipsis.circle")
      }
    }
    ToolbarItemGroup(placement: .bottomBar) {
      Button {
        vm.toolbarAddFolderButtonTappped()
      } label: {
        Image(systemName: "folder.badge.plus")
      }
      Spacer()
      Text("\(vm.userFolders.count) Folders")
        .font(.caption)
      Spacer()
      Button {
        vm.toolbarAddNoteButtonTappped()
      } label: {
        Image(systemName: "square.and.pencil")
      }
    }
  }
}

