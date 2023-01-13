import SwiftUI
import SwiftUINavigation
import CasePaths

struct FolderEditSheet: View {
  @ObservedObject var vm: FolderViewModel
  
  var body: some View {
    Form {
      Section {
        Button {
          vm.editSheetSelectButtonTapped()
        } label: {
          HStack {
            Text("View as Gallery")
            Spacer()
            Image(systemName: "square.grid.2x2")
          }
        }
      }
      Section {
        // Select
        Button {
          vm.editSheetSelectButtonTapped()
        } label: {
          HStack {
            Text("Select")
            Spacer()
            Image(systemName: "checkmark.circle")
          }
        }
        
        // Sort
        // TODO: Perform logic when a choice is selected executed...
        Menu {
          Picker("Sort", selection: $vm.sort) {
            ForEach(FolderViewModel.Sort.allCases, id: \.self) { sort in
              Text(sort.string)
            }
          }
        } label: {
          HStack {
            Text("Sort")
            Spacer()
            Image(systemName: "arrow.up.arrow.down")
          }
        }
        
        // Add
        Button {
          vm.editSheetAddSubfolderButtonTapped()
        } label: {
          HStack {
            Text("Select Subfolder")
            Spacer()
            Image(systemName: "folder.badge.plus")
          }
        }
        
        // Move
        Button {
          vm.editSheetMoveButtonTapped()
        } label: {
          HStack {
            Text("Move")
            Spacer()
            Image(systemName: "folder")
          }
        }
        
        // Rename
        Button {
          vm.editSheetRenameButtonTapped()
        } label: {
          HStack {
            Text("Rename")
            Spacer()
            Image(systemName: "pencil")
          }
        }
      }
    }
    .foregroundColor(.black)
  }
}

struct FolderMenuSheet_Previews: PreviewProvider {
  static var previews: some View {
    FolderEditSheet(vm: .init(folder: mockFolder))
  }
}
