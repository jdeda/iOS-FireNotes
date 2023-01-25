import SwiftUI
import SwiftUINavigation
import CasePaths
import XCTestDynamicOverlay

enum FolderType: CaseIterable {
  case all
  case standard
  case recentlyDeleted
  case user
}
// MARK: - View
struct FolderEditSheet: View {
  @ObservedObject var vm: FolderEditSheetViewModel
  
  var body: some View {
    NavigationStack {
      Form {
        switch vm.folderVariant {
        case .all:
          sortPicker()
        case .standard:
          selectButton()
          sortPicker()
        case .recentlyDeleted:
          selectButton()
          sortPicker()
        case .user:
          selectButton()
          sortPicker()
          addButton()
          moveButton()
          renameButton()
        }
      }
      .foregroundColor(.black)
      .toolbar {
        toolbar()
      }
    }
  }
}

// MARK: - Helpers
extension FolderEditSheet {
  func selectButton() -> some View {
    Button {
      vm.selectButtonTapped()
    } label: {
      CustomLabel("Select", systemImage: "checkmark.circle")
    }
  }
  
  func sortPicker() -> some View {
    Menu {
      Picker("Sort", selection: $vm.sort) {
        ForEach(FolderViewModel.Sort.allCases, id: \.self) { sort in
          Text(sort.string)
        }
      }
      .onChange(of: vm.sort, perform: vm.sortPickerOptionTapped)
    } label: {
      CustomLabel("Sort", systemImage: "arrow.up.arrow.down")
    }
  }
  
  func addButton() -> some View {
    Button {
      vm.addSubfolderButtonTapped()
    } label: {
      CustomLabel("Add Subfolder", systemImage: "folder.badge.plus")
    }
  }
  
  func moveButton() -> some View {
    Button {
      vm.moveButtonTapped()
    } label: {
      CustomLabel("Move", systemImage: "folder")
    }
  }
  
  func renameButton() -> some View {
    Button {
      vm.renameButtonTapped()
    } label: {
      CustomLabel("Rename", systemImage: "pencil")
    }
  }
  
  @ToolbarContentBuilder
  func toolbar() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      HStack {
        Image(systemName: "folder.fill")
          .font(.title3)
          .foregroundColor(.yellow)
        Text(vm.folderName)
      }
    }
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        vm.dismissButtonTapped()
      } label: {
        Image(systemName: "xmark.circle.fill")
      }
      .foregroundColor(Color(UIColor.systemGray2))
    }
  }
}

// MARK: - Previews
struct FolderEditSheet_Previews: PreviewProvider {
  static var previews: some View {
    FolderEditSheet(vm: .init(folderVariant: .user, folderName: "Foo", sort: .title))
  }
}
