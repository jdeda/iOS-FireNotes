import Foundation
import Combine
import IdentifiedCollections
import SwiftUINavigation
import SwiftUI
import Tagged
import XCTestDynamicOverlay

//MARK: - ViewModel
final class HomeViewModel: ObservableObject {
  var allFolder: Folder {
    let folders = userFolders.elements + [standardFolder, recentlyDeletedFolder]
    let notes = folders.flatMap { folder in
      folder.notes.map { note in
        var newNote = note
        newNote.folderName = folder.name
        return newNote
      }
    }
    return .init(id: .init(), variant: .all, name: "All Folder", notes: .init(uniqueElements: notes))
  }
  @Published var standardFolder: Folder
  @Published var recentlyDeletedFolder: Folder
  @Published var userFolders: IdentifiedArrayOf<Folder>
  @Published var sort: Sort
  @Published var isEditing: Bool
  @Published var selectedFolders: Set<Folder.ID>
  @Published var searchedNotes: IdentifiedArrayOf<Note>
  @Published var search: String
  @Published var destinationCancellable: AnyCancellable?
  @Published var destination: Destination? {
    didSet { destinationBind() }
  }
  
  var hasSelectedAll: Bool {
    selectedFolders.count == userFolders.count
  }
  
  var navigationBarTitle: String {
    isEditing && selectedFolders.count > 0 ? "\(selectedFolders.count) Selected": "Folders"
  }
  
  init(
    userFolders: IdentifiedArrayOf<Folder>,
    standardFolderNotes: IdentifiedArrayOf<Note>,
    recentlyDeletedNotes: IdentifiedArrayOf<Note>,
    selectedFolders: Set<Folder.ID> = [],
    search: String = "",
    destination: Destination? = nil,
    isEditing: Bool = false,
    sort: Sort = .alphabetical
  ) {
    self.standardFolder = .init(id: .init(), variant: .standard, name: "Notes", notes: standardFolderNotes)
    self.recentlyDeletedFolder = .init(id: .init(), variant: .recentlyDeleted, name: "Recently Deleted", notes: recentlyDeletedNotes)
    self.userFolders = userFolders
    self.selectedFolders = selectedFolders
    self.search = search
    self.destination = destination
    self.isEditing = isEditing
    self.sort = sort
    self.searchedNotes = []
    performSort()
    destinationBind()
  }
  
  private func destinationBind() {
    switch destination {
    case .none:
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
      // TODO: This code looks very pernicious...how do we trust the variant property is being used right?
      self.destinationCancellable = folderVM.$folder.sink { [weak self] newFolder in
        guard let self else { return }
        self.updateFolder(folder: newFolder)
      }
      break
    case let .note(noteVM):
      noteVM.newNoteButtonTapped = { [weak self] newNote in
        guard let self else { return }
        self.newNoteButtonTapped(newNote: newNote)
      }
      // Listen for changes in the note when we are navigated in.
      self.destinationCancellable = noteVM.$note.sink { [weak self] newNote in
        guard let self else { return }
        self.updateFolder(note: newNote)
      }
      break
    }
  }
  
  private func performSort() {
    let newFolders: [Folder] = {
      switch sort {
      case .alphabetical:
        return userFolders.sorted(using: KeyPathComparator(\.name, comparator: .localizedStandard, order: .forward))
      case .alphabeticalR:
        return userFolders.sorted(using: KeyPathComparator(\.name, comparator: .localizedStandard, order: .reverse))
      }
    }()
    withAnimation {
      userFolders = .init(uniqueElements: newFolders)
    }
  }
  
  func setSearch(_ newSearch: String) {
    self.search = newSearch
    performSearch()
  }
  
  private func performSearch() {
    searchedNotes = .init(uniqueElements: allFolder.notes
      .filter { $0.folderName != nil }
      .filter {
        $0.title.lowercased().contains(search.lowercased()) ||
        $0.body.lowercased().contains(search.lowercased())
      }
    )
  }
  
  func searchButtonTapped(_ note: Note) {
    destination = .note(.init(note: note))
  }
  
  private func newNoteButtonTapped(newNote: Note) {
    updateFolder(note: newNote)
    destination = .note(.init(note: newNote))
  }
  
  private func updateFolder(note: Note) {
    var foundNote = standardFolder.notes[id: note.id]
    if foundNote != nil {
      standardFolder.notes[id: note.id] = note
    }
    foundNote = recentlyDeletedFolder.notes[id: note.id]
    if foundNote != nil {
      recentlyDeletedFolder.notes[id: note.id] = note
    }
    for folder in userFolders {
      foundNote = folder.notes[id: note.id]
      if foundNote != nil {
        userFolders[id: folder.id]!.notes[id: note.id] = note
      }
    }
  }
  
  private func updateFolder(folder: Folder) {
    switch folder.variant {
    case .all:
      if standardFolder.id == folder.id {
        standardFolder = folder
      }
      if recentlyDeletedFolder.id == folder.id {
        standardFolder = folder
      }
      if userFolders[id: folder.id] != nil {
        userFolders[id: folder.id] = folder
      }
    case .standard:
      self.standardFolder = folder
    case .user:
      self.userFolders[id: folder.id] = folder
    case .recentlyDeleted:
      self.recentlyDeletedFolder = folder
    }
  }
  
//  func searchButtonTapped(_ note: Note) {
//    var foundNote = standardFolder.notes[id: note.id]
//    if foundNote != nil {
//      destination = .folder(.init(
//        folder: standardFolder,
//        destination: .note(.init(note: foundNote!))
//      ))
//      return
//    }
//    foundNote = recentlyDeletedFolder.notes[id: note.id]
//    if foundNote != nil {
//      destination = .folder(.init(
//        folder: recentlyDeletedFolder,
//        destination: .note(.init(note: foundNote!))
//      ))
//      return
//    }
//    for folder in userFolders {
//      foundNote = folder.notes[id: note.id]
//      if foundNote != nil {
//        destination = .folder(.init(
//          folder: folder,
//          destination: .note(.init(note: foundNote!))
//        ))
//        return
//      }
//    }
//  }
  
  func toolbarDoneButtonTapped() {
    isEditing = false
    destination = nil
  }
  
  func selectAllButtonTapped() {
    selectedFolders = hasSelectedAll ? [] : .init(userFolders.map(\.id))
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
      message: TextState("Are you sure you want to delete the selected folders?"),
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
      variant: .user,
      name: "Untitled Folder",
      notes: .init()
    )
    _ = withAnimation {
      self.userFolders.append(newFolder)
    }
    self.destination = .folder(.init(folder: newFolder))
  }
  
  func toolbarAddNoteButtonTappped() {
    let newNote = Note(
      id: .init(),
      title: "New Untitled Note",
      body: "",
      creationDate: Date(),
      lastEditDate: Date()
    )
    standardFolder.notes.append(newNote)
    destination = .folder(.init(folder: standardFolder, destination: .note(.init(note: newNote))))
  }
  
  private func editSheetSelectButtonTapped() {
    isEditing = true
    destination = nil
  }
  
  private func editSheetSortPickerOptionTapped(_ newSort: Sort) {
    sort = newSort
    performSort()
    destination = nil
  }
  
  private func editSheetDismissButtonTapped() {
    destination = nil
  }
  
  private func renameSelectedSheetConfirmButtonTapped(renameValues: RenameValues) {
    let orderedSelectedFolders = userFolders.filter { selectedFolders.contains($0.id) }.elements
    let updatedNames = renameValues.rename(orderedSelectedFolders.map(\.name))
    let zipped = zip(orderedSelectedFolders, updatedNames)
    let updatedOrderedSelectedFolders = zipped.map { (folder, newName) -> Folder in
      var newFolder = folder
      newFolder.name = newName
      return newFolder
    }
    withAnimation {
      userFolders = .init(uniqueElements: userFolders.map { folder in
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
    case let .confirmDeleteSingle(folderID):
      confirmDeleteSingle(folderID)
      break
    }
  }
  
  func folderRowTapped(_ folder: Folder) {
    destination = .folder(FolderViewModel(folder: folder))
  }
  
  func deleteFolderButtonTapped(_ folder: Folder) {
    destination = .alert(.init(
      title: TextState("Delete"),
      message: TextState("Are you sure you want to delete the selected folder?"),
      buttons: [
        .default(TextState("Nevermind")),
        .default(TextState("Yes"), action: .send(.confirmDeleteSingle(folder.id))),
      ]
    ))
  }
  
  private func confirmDeleteSelected() {
    withAnimation {
      userFolders = userFolders.filter { !selectedFolders.contains($0.id) }
      destination = nil
      isEditing = false
    }
  }
  
  private func confirmDeleteSingle(_ folderID: Folder.ID) {
    _ = withAnimation {
      userFolders.remove(id: folderID)
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
    case confirmDeleteSingle(Folder.ID)
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
