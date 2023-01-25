import Foundation
import Combine
import IdentifiedCollections
import SwiftUINavigation
import SwiftUI
import Tagged
import XCTestDynamicOverlay

//MARK: - ViewModel
final class HomeViewModel: ObservableObject {
  @Published var folders: IdentifiedArrayOf<Folder>
  @Published var allFolder: Folder
  @Published var recentlyDeletedFolder: Folder
  @Published var sort: Sort
  @Published var isEditing: Bool
  @Published var selectedFolders: Set<Folder.ID>
  @Published var searchedFolders: IdentifiedArrayOf<Folder>
  @Published var search: String
  @Published var destinationCancellable: AnyCancellable?
  @Published var destination: Destination? {
    didSet { destinationBind() }
  }
  
  var hasSelectedAll: Bool {
    selectedFolders.count == folders.count
  }
  
  var navigationBarTitle: String {
    isEditing && selectedFolders.count > 0 ? "\(selectedFolders.count) Selected": "Folders"
  }
  
  init(
    folders: IdentifiedArrayOf<Folder>,
    selectedFolders: Set<Folder.ID> = [],
    search: String = "",
    destination: Destination? = nil,
    isEditing: Bool = false,
    sort: Sort = .alphabetical
  ) {
    self.folders = folders
    self.allFolder = .init(id: .init(), name: "All Firebase", notes: [])
    self.recentlyDeletedFolder = .init(id: .init(), name: "Recently Deleted", notes: [])
    self.selectedFolders = selectedFolders
    self.search = search
    self.destination = destination
    self.isEditing = isEditing
    self.sort = sort
    self.searchedFolders = []
    performSort()
    destinationBind()
  }
  
  private func destinationBind() {
    switch destination {
    case .none:
      break
    case let .note(noteVM):
      break
    case .some(.alert(_)):
      break
    case .some(.moveSheet):
      break
    case .some(.renameAlert):
      break
    case let .editHomeSheet(editSheetVM):
      editSheetVM.selectButtonTapped = { [weak self] in
        guard let self else { return }
        self.editSheetSelectButtonTapped()
      }
      editSheetVM.sortPickerOptionTapped = { [weak self] newSort in
        guard let self else { return }
        self.editSheetSortPickerOptionTapped(newSort)
      }
      editSheetVM.dismissButtonTapped = { [weak self] in
        guard let self else { return }
        self.editSheetDismissButtonTapped()
      }
    case .some(.deleteSelectedAlert):
      break
    case let .renameSelectedSheet(renameSheetVM):
      renameSheetVM.submitButtonTapped = { [weak self] renameValues in
        guard let self else { return }
        self.renameSelectedSheetConfirmButtonTapped(renameValues: renameValues)
      }
      renameSheetVM.cancelButtonTapped = { [weak self] in
        guard let self else { return }
        self.renameSelectedSheetCancelButtonTapped()
      }
      break
    case let .folder(folderVM):
      self.destinationCancellable = folderVM.$folder.sink { [weak self] newFolder in
        guard let self else { return }
        self.folders[id: newFolder.id] = newFolder
      }
      break
    }
  }
  
  //  private func newNoteButtonTapped(newNote: Note) {
  //    self.folder.notes.append(newNote)
  //    self.destination = .note(.init(note: newNote, focus: .body))
  //  }
  
  private func performSort() {
        let newFolders: [Folder] = {
          switch sort {
          case .alphabetical:
            return folders.sorted { $0.name < $1.name }
          case .alphabeticalR:
            return folders.sorted { $0.name > $1.name }
          }
        }()
        destination = nil
        withAnimation {
          folders = .init(uniqueElements: newFolders)
        }
  }
  
  func performSearch() {
//        searchedFolders = .init(uniqueElements: folders.filter {
//          $0.name.lowercased().contains(search.lowercased()) ||
//          $0.body.lowercased().contains(search.lowercased())
//        })
  }
  
  func clearSearchedNotes() {
    self.searchedFolders = []
  }
  
  func toolbarDoneButtonTapped() {
    isEditing = false
    destination = nil
  }
  
  func selectAllButtonTapped() {
    selectedFolders = hasSelectedAll ? [] : .init(folders.map(\.id))
  }
  
  func toolbarRenameSelectedButtonTapped() {
    destination = .renameSelectedSheet(.init())
  }
  
  func toolbarMoveSelectedButtonTapped() {
    destination = nil
  }
  
  func toolbarDeleteSelectedButtonTapped() {
    destination = .alert(.init(
      title: TextState("Delete Selected"),
      message: TextState("Are you sure you want to delete the selected notes?"),
      buttons: [
        .default(TextState("Nevermind")),
        .default(TextState("Yes"), action: .send(.confirmDelete)),
      ]
    ))
  }
  
  func toolbarAppearEditSheetButtonTapped() {
    destination = .editHomeSheet(.init(sort: sort))
  }
  
  func toolbarAddFolderButtonTappped() {
    let newFolder = Folder(
      id: .init(),
      name: "Untitled Folder",
      notes: .init()
    )
    _ = withAnimation {
      self.folders.append(newFolder)
    }
    self.destination = .folder(.init(folder: newFolder))
  }
  
  func toolbarAddNoteButtonTappped() {
    //    let newNote = Note(
    //      id: .init(),
    //      title: "New Untitled Note",
    //      body: "",
    //      creationDate: Date(),
    //      lastEditDate: Date()
    //    )
    //    _ = withAnimation {
    //      self.folder.notes.append(newNote)
    //    }
    //    self.destination = .note(.init(note: newNote))
  }
  
  private func editSheetSelectButtonTapped() {
    isEditing = true
    destination = nil
  }
  
  private func editSheetSortPickerOptionTapped(_ newSort: Sort) {
    sort = newSort
    performSort()
  }
  
  private func editSheetDismissButtonTapped() {
    destination = nil
  }
  
  private func renameSelectedSheetConfirmButtonTapped(renameValues: RenameValues) {
    let orderedSelectedFolders = folders.filter { selectedFolders.contains($0.id) }.elements
    let updatedNames = renameValues.rename(orderedSelectedFolders.map(\.name))
    let zipped = zip(orderedSelectedFolders, updatedNames)
    let updatedOrderedSelectedFolders = zipped.map { (folder, newName) -> Folder in
      var newFolder = folder
      newFolder.name = newName
      return newFolder
    }
    withAnimation {
      folders = .init(uniqueElements: folders.map { folder in
        updatedOrderedSelectedFolders.first(where: { $0.id == folder.id }) ?? folder
      })
      destination = nil
      isEditing = false
    }
  }
  
  private func renameSelectedSheetCancelButtonTapped()  {
    destination = nil
  }
  
  func alertButtonTapped(_ action: AlertAction) {
    switch action {
    case .confirmDelete:
      confirmDeleteSelected()
      break
    }
  }
  
  //  func renameAlertConfirmButtonTapped(_ newName: String) {
  //    folder.name = newName
  //  }
  
  func folderRowTapped(_ folder: Folder) {
    destination = .folder(FolderViewModel(folder: folder))
  }
  
  func deleteFolderButtonTapped(_ folder: Folder) {
    _ = withAnimation {
      folders.remove(id: folder.id)
    }
  }
  
  private func confirmDeleteSelected() {
    withAnimation {
      folders = folders.filter { !selectedFolders.contains($0.id) }
      destination = nil
      isEditing = false
    }
  }
}

extension HomeViewModel {
  enum Destination {
    case editHomeSheet(HomeEditSheetViewModel)
    case renameSelectedSheet(RenameSelectedSheetViewModel)
    case folder(FolderViewModel)
    case note(NoteViewModel)
    case alert(AlertState<AlertAction>)
    case renameAlert
    case deleteSelectedAlert
    case moveSheet
  }
  
  enum AlertAction {
    case confirmDelete
  }
}

extension HomeViewModel {
  enum Sort: CaseIterable {
    case alphabetical
    case alphabeticalR
    
    var string: String {
      switch self {
      case .alphabetical: return "Alphabetical (A -> Z)"
      case .alphabeticalR: return "Reverse Alphabetical (Z -> A)"
      }
    }
  }
}
