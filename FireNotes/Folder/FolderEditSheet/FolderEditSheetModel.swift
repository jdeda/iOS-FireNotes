import Foundation
import XCTestDynamicOverlay

final class FolderEditSheetViewModel: ObservableObject {
  let folderVariant: Folder.Variant
  let folderName: String
  @Published var sort: FolderViewModel.Sort
  
  init(
    folderVariant: Folder.Variant,
    folderName: String,
    sort: FolderViewModel.Sort
  ) {
    self.folderVariant = folderVariant
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

