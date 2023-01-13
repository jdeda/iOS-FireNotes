//import SwiftUI
//import SwiftUINavigation
//import CasePaths
//
//// MARK: - View
//struct FolderViewToolbar: ToolbarContent {
//  @ObservedObject var vm: FolderViewModel
////  @ObservedObject var vm: FolderViewToolbarViewModel
//    
//  var body: some ToolbarContent {
//    if vm.isEditing {
//      editingToolbar()
//    }
//    else {
//      nonEditingToolbar()
//    }
//  }
//}
//
//// MARK: - Helper Views
//extension FolderViewToolbar {
//  
//  @ToolbarContentBuilder
//  func editingToolbar() -> some ToolbarContent {
//    ToolbarItemGroup(placement: .primaryAction) {
//      menu()
//    }
//    ToolbarItemGroup(placement: .bottomBar) {
//      nonEditingBottomToolbar()
//    }
//  }
//  
//  @ToolbarContentBuilder
//  func nonEditingToolbar() -> some ToolbarContent {
//    ToolbarItemGroup(placement: .primaryAction) {
//      Button {
//        vm.toggleEditButtonTapped()
//      } label: {
//        Text("Done")
//      }
//    }
//    ToolbarItemGroup(placement: .bottomBar) {
//      editingBottomToolbar()
//    }
//  }
//  
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
//      // TODO: Perform logic when a choice is selectedexecuted...
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
//        vm.addSubfolderButtonTapped()
//      } label: {
//        Label("Add Subfolder", systemImage: "folder.badge.plus")
//      }
//      
//      // Move
//      Button {
//        vm.moveButtonTapped()
//      } label: {
//        Label("Move", systemImage: "folder")
//      }
//      
//      // Rename
//      Button {
//        vm.renameButtonTapped()
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
//  @ViewBuilder
//  func editingBottomToolbar() -> some View {
//    Button {
//      vm.renameSelectedButtonTapped()
//    } label: {
//      Image(systemName: "rectangle.and.pencil.and.ellipsis")
//      
//    }
//    .disabled(vm.select.count == 0)
//    Spacer()
//    Button {
//      vm.moveSelectedButtonTapped()
//    } label: {
//      Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
//      
//    }
//    .disabled(vm.select.count == 0)
//    Spacer()
//    Button {
//      vm.deleteSelectedButtonTapped()
//    } label: {
//      Image(systemName: "trash")
//    }
//    .disabled(vm.select.count == 0)
//  }
//}
