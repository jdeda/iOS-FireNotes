import Foundation

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
 */
final class FolderViewToolbarViewModel: ObservableObject {
  
}
