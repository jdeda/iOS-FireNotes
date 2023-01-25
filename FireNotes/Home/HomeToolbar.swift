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
      .foregroundColor(.yellow)
    }
    
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
      .foregroundColor(.yellow)
      .disabled(vm.selectedFolders.count == 0)
      
      Spacer()
      
      Button {
        vm.toolbarMoveSelectedButtonTapped()
      } label: {
        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
      }
      .foregroundColor(.yellow)
      .disabled(vm.selectedFolders.count == 0)
      
      Spacer()
      
      Button {
        vm.toolbarDeleteSelectedButtonTapped()
      } label: {
        Image(systemName: "trash")
      }
      .foregroundColor(.yellow)
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
      .foregroundColor(.yellow)
    }
    ToolbarItemGroup(placement: .bottomBar) {
      Button {
        vm.toolbarAddFolderButtonTappped()
      } label: {
        Image(systemName: "folder.badge.plus")
      }
      .foregroundColor(.yellow)
      Spacer()
      Text("\(vm.folders.count) Folders")
        .font(.caption)
      Spacer()
      Button {
        vm.toolbarAddNoteButtonTappped()
      } label: {
        Image(systemName: "square.and.pencil")
      }
      .foregroundColor(.yellow)
    }
  }
}

