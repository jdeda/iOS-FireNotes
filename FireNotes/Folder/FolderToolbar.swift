import SwiftUI

// MARK: - View
extension FolderView {
  @ToolbarContentBuilder
  func toolbar()  -> some ToolbarContent {
    switch vm.folder.variant {
    case .all:
      allFolderToolbar()
    case .standard:
      standardFolderToolbar()
    case .recentlyDeleted:
      recentlyDeletedFolderToolbar()
    case .user:
      userFolderToolbar()
    }
  }
}

// MARK: - Helper Views
fileprivate extension FolderView {
  @ToolbarContentBuilder
  func allFolderToolbar() -> some ToolbarContent {
    ToolbarItemGroup(placement: .primaryAction) {
      editSheetButton()
    }
    ToolbarItemGroup(placement: .bottomBar) {
      addNoteButton()
    }
  }
  
  @ToolbarContentBuilder
  func standardFolderToolbar() -> some ToolbarContent {
    if vm.isEditing {
      ToolbarItemGroup(placement: .navigationBarLeading) {
        selectAllButton()
      }
      ToolbarItemGroup(placement: .primaryAction) {
        doneButton()
      }
      ToolbarItemGroup(placement: .bottomBar) {
        renameSelectedButton()
        Spacer()
        moveSelectedButton()
        Spacer()
        deleteSelectedButton()
      }
    }
    else {
      ToolbarItemGroup(placement: .primaryAction) {
        editSheetButton()
      }
      ToolbarItemGroup(placement: .bottomBar) {
        addNoteButton()
      }
    }
  }
  
  @ToolbarContentBuilder
  func recentlyDeletedFolderToolbar() -> some ToolbarContent {
    if vm.isEditing {
      ToolbarItemGroup(placement: .navigationBarLeading) {
        selectAllButton()
      }
      ToolbarItemGroup(placement: .primaryAction) {
        doneButton()
      }
      ToolbarItemGroup(placement: .bottomBar) {
        restoreSelectedButton()
        Spacer()
        moveSelectedButton()
        Spacer()
        deleteSelectedButton()
      }
    }
    else {
      ToolbarItemGroup(placement: .primaryAction) {
        editSheetButton()
      }
    }
  }
  
  @ToolbarContentBuilder
  func userFolderToolbar() -> some ToolbarContent {
    if vm.isEditing {
      ToolbarItemGroup(placement: .navigationBarLeading) {
        selectAllButton()
      }
      ToolbarItemGroup(placement: .primaryAction) {
        doneButton()
      }
      ToolbarItemGroup(placement: .bottomBar) {
        renameSelectedButton()
        Spacer()
        moveSelectedButton()
        Spacer()
        deleteSelectedButton()
      }
    }
    else {
      ToolbarItemGroup(placement: .primaryAction) {
        editSheetButton()
      }
      ToolbarItemGroup(placement: .bottomBar) {
        addNoteButton()
      }
    }
  }
  
  @ViewBuilder
  private func selectAllButton() -> some View {
    Button {
      vm.selectAllButtonTapped()
    } label: {
      Text(vm.hasSelectedAll ? "Deselect All" : "Select All")
    }
  }
  
  @ViewBuilder
  private func doneButton() -> some View {
    Button {
      vm.toolbarDoneButtonTapped()
    } label: {
      Text("Done")
    }
  }
  
  @ViewBuilder
  private func renameSelectedButton() -> some View {
    Button {
      vm.toolbarRenameSelectedButtonTapped()
    } label: {
      Image(systemName: "rectangle.and.pencil.and.ellipsis")
    }
    .disabled(vm.selectedNotes.count == 0)
  }
  
  @ViewBuilder
  private func moveSelectedButton() -> some View {
    Button {
      vm.toolbarMoveSelectedButtonTapped()
    } label: {
      Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
    }
    .disabled(vm.selectedNotes.count == 0)
  }
  
  @ViewBuilder
  private func deleteSelectedButton() -> some View {
    Button {
      vm.toolbarDeleteSelectedButtonTapped()
    } label: {
      Image(systemName: "trash")
    }
    .disabled(vm.selectedNotes.count == 0)
  }
  
  @ViewBuilder
  private func restoreSelectedButton() -> some View {
    Button {
      vm.toolbarRestoreSelectedButtonTapped()
    } label: {
      Image(systemName: "arrow.uturn.down")
    }
    .disabled(vm.selectedNotes.count == 0)
  }
  
  @ViewBuilder
  private func editSheetButton() -> some View {
    Button {
      vm.toolbarAppearEditSheetButtonTapped()
    } label: {
      Image(systemName: "ellipsis.circle")
    }
  }
  
  @ViewBuilder
  private func addNoteButton() -> some View {
    Spacer()
    Text("\(vm.folder.notes.count) Notes")
      .font(.caption)
    Spacer()
    Button {
      vm.toolbarAddNoteButtonTappped()
    } label: {
      Image(systemName: "square.and.pencil")
    }
  }
}

