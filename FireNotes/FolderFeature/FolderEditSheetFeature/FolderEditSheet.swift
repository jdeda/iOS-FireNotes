import SwiftUI
import SwiftUINavigation
import CasePaths
import XCTestDynamicOverlay

final class FolderEditSheetViewModel: ObservableObject {
  let folderName: String
  @Published var sort: FolderViewModel.Sort
  
  init(
    folderName: String,
    sort: FolderViewModel.Sort = .editDate
  ) {
    self.folderName = folderName
    self.sort = sort
  }
  
  var selectButtonTapped: () -> Void = unimplemented("FolderEditSheetViewModel.selectButtonTapped")
  var sortPickerOptionTapped: (_ sort: FolderViewModel.Sort) -> Void = unimplemented("FolderEditSheetViewModel.sortPickerOptionTapped")
  var addSubfolderButtonTapped: () -> Void = unimplemented("FolderEditSheetViewModel.addSubfolderButtonTapped")
  var moveButtonTapped: () -> Void = unimplemented("FolderEditSheetViewModel.moveButtonTapped")
  var renameButtonTapped: () -> Void = unimplemented("FolderEditSheetViewModel.renameButtonTapped")
  var dismissButtonTapped: () -> Void = unimplemented("FolderEditSheetViewModel.dismissButtonTapped")
  
}

// MARK: - View
struct FolderEditSheet: View {
  @ObservedObject var vm: FolderEditSheetViewModel
  
  var body: some View {
    NavigationStack {
      Form {
          selectButton()
          sortPicker()
          addButton()
          moveButton()
          renameButton()
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

struct CustomLabel: View {
  let titleKey: String
  let systemImage: String
  
  init(
    _ titleKey: String,
    systemImage: String
  )
  {
    self.titleKey = titleKey
    self.systemImage = systemImage
  }
  
  var body: some View {
    HStack {
      Text(titleKey)
      Spacer()
      Image(systemName: systemImage)
    }
  }
}

struct FolderMenuSheet_Previews: PreviewProvider {
  static var previews: some View {
    FolderEditSheet(vm: .init(folderName: "Foo"))
  }
}
