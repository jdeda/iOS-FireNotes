import Foundation
import XCTestDynamicOverlay

/**
 State I need to know:
  var isEditing: Bool <-- observing this value from the parent!
  var sort: Sort <-- observing this value from the parent!
  var noteCount: Int <-- observing this value from the parent!
  var selectCount: Int <-- observing this value from the parent!
 
 Callbacks:
  var toggleEditButtonTapped: () -> Void
  var sortOptionTapped: () -> Void
  var toggleEditButtonTapped: () -> Void
  var addSubfolderButtonTapped: () -> Void
  var moveButtonTapped: () -> Void
  var renameButtonTapped: () -> Void
 
 isEditing
 hasSelectedAll
 vm.select.count == 0
 selectAllButtonTapped
 doneButtonTapped
 renameSelectedButtonTapped
 moveSelectedButtonTapped
 deleteSelectedButtonTapped
 editSheetAppearButtonTapped
 addNoteButtonTappped
 */
final class FolderToolbarViewModel: ObservableObject {
  var isEditing: Bool = false
  var hasSelectedAll: Bool = false
  var selectCount: Int = 0
  var selectAllButtonTapped: () -> Void = unimplemented("FolderToolbarViewModel.selectAllButtonTapped")
  var doneButtonTapped: () -> Void = unimplemented("FolderToolbarViewModel.doneButtonTapped")
  var renameSelectedButtonTapped: () -> Void = unimplemented("FolderToolbarViewModel.renameSelectedButtonTapped")
  var moveSelectedButtonTapped: () -> Void = unimplemented("FolderToolbarViewModel.moveSelectedButtonTapped")
  var deleteSelectedButtonTapped: () -> Void = unimplemented("FolderToolbarViewModel.deleteSelectedButtonTapped")
  var editSheetAppearButtonTapped: () -> Void = unimplemented("FolderToolbarViewModel.editSheetAppearButtonTapped")
  var addNoteButtonTappped: () -> Void = unimplemented("FolderToolbarViewModel.addNoteButtonTappped")
}
