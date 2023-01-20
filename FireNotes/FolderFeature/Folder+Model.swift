import Foundation
import Combine
import IdentifiedCollections
import SwiftUINavigation
import SwiftUI
import Tagged
import XCTestDynamicOverlay

// TODO: Selection highlight not appearing

//MARK: - ViewModel
final class FolderViewModel: ObservableObject {
  @Published var folder: Folder
  @Published var select: Set<Note.ID>
  @Published var search: String
  @Published var isEditing: Bool
  @Published var sort: Sort
  @Published var searchedNotes: IdentifiedArrayOf<Note>
  @Published var destination: Destination? {
    didSet { destinationBind() }
  }
  
  private var destinationCancellable: AnyCancellable?
  
  var hasSelectedAll: Bool {
    select.count == folder.notes.count
  }
  
  var navigationBarTitle: String {
    if isEditing && select.count > 0 {
      return "\(select.count) Selected"
    }
    else {
      return folder.name
    }
  }
  
  init(
    folder: Folder,
    select: Set<Note.ID> = [],
    search: String = "",
    destination: Destination? = nil,
    isEditing: Bool = false,
    sort: Sort = .editDate
  ) {
    self.folder = folder
    self.select = select
    self.search = search
    self.destination = destination
    self.isEditing = isEditing
    self.sort = sort
    self.searchedNotes = []
    destinationBind()
  }
  
  func destinationBind() {
    switch destination {
    case .none:
      break
    case .home:
      break
    case let .note(noteVM):
      noteVM.newNoteButtonTapped = { [weak self] newNote in
        guard let self else { return }
        self.folder.notes.append(newNote)
        self.destination = .note(.init(note: newNote, focus: .body))
      }
      // when a note chanegs
      self.destinationCancellable = noteVM.$note.sink { [weak self] newNote in
        guard let self else { return }
        self.folder.notes[id: newNote.id] = newNote
      }
      break
    case .userOptionsSheet:
      break
    case .some(.alert(_)):
      break
    case .some(.moveSheet):
      break
    case .some(.renameAlert):
      break
    case let .editSheet(editSheetVM):
//      editSheetVM.gridButtonTapped = { [weak self] in
//        guard let self else { return }
//        // TODO:
//        self.editSheetGridButtonTapped()
//      }
      editSheetVM.selectButtonTapped = { [weak self] in
        guard let self else { return }
        self.editSheetSelectButtonTapped()
      }
      editSheetVM.sortPickerOptionTapped = { [weak self] newSort in
        guard let self else { return }
        self.editSheetSortPickerOptionTapped(newSort)
      }
//      editSheetVM.addSubfolderButtonTapped = { [weak self] in
//        guard let self else { return }
//        self.editSheetAddSubfolderButtonTapped()
//      }
//      editSheetVM.moveButtonTapped = { [weak self] in
//        guard let self else { return }
//        self.editSheetMoveButtonTapped()
//      }
      editSheetVM.renameButtonTapped = { [weak self] in
        guard let self else { return }
        self.editSheetRenameButtonTapped()
      }
      editSheetVM.dismissButtonTapped = { [weak self] in
        guard let self else { return }
        self.editSheetDismissButtonTapped()
      }
      break
    }
  }
  
  private func performSort() {
    let newNotes: [Note] = {
      let notes = folder.notes.elements
      switch sort {
      case .editDate:
        return notes.sorted(using: KeyPathComparator(\.lastEditDate))
      case .creationDate:
        return notes.sorted(using: KeyPathComparator(\.lastEditDate))
      case .title:
        return notes.sorted(using: KeyPathComparator(\.title, comparator: .localizedStandard))
      }
    }()
    destination = nil
    withAnimation {
      folder.notes = .init(uniqueElements: newNotes)
    }
  }
  
  func performSearch() {
    searchedNotes = .init(uniqueElements: folder.notes.filter {
      $0.title.lowercased().contains(search.lowercased()) ||
      $0.body.lowercased().contains(search.lowercased())
    })
  }
  
  func clearSearchedNotes() {
    self.searchedNotes = []
  }
  
  
  func toolbarDoneButtonTapped() {
    isEditing = false
    destination = nil
  }
  
  func selectAllButtonTapped() {
    select = hasSelectedAll ? [] : .init(folder.notes.map(\.id))
  }
  
  func toolbarRenameSelectedButtonTapped() {
    destination = nil
  }
  
  func toolbarMoveSelectedButtonTapped() {
    destination = nil
  }
  
  func toolbarDeleteSelectedButtonTapped() {
    destination = nil
  }
  
  func editSheetDismissButtonTapped() {
    destination = nil
  }
  
  func editSheetAppearButtonTapped() {
    destination = .editSheet(.init(folderName: folder.name))
  }
  
  func editSheetGridButtonTapped() {
    
  }
  
  func editSheetSelectButtonTapped() {
    isEditing = true
    destination = nil
  }
  
  func editSheetSortPickerOptionTapped(_ newSort: Sort) -> Void {
    sort = newSort
    performSort()
  }
  
  func editSheetAddSubfolderButtonTapped() {
    
  }
  
  func editSheetMoveButtonTapped() {
    
  }
  
  // TODO: Need to dismiss the sheet, wait, then show the popup.
  func editSheetRenameButtonTapped() {
    self.destination = nil
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.destination = .renameAlert
    }
  }
  
  func alertButtonTapped(_ action: AlertAction) {
    switch action {
    case .confirmDelete:
      confirmDeleteSelected()
      break
    }
  }
  
  func renameAlertConfirmButtonTapped(_ newName: String) {
    folder.name = newName
  }
  
  func noteTapped(_ note: Note) {
    destination = .note(NoteViewModel(
      note: note,
      focus: .body
    ))
  }
  
  func addNoteButtonTappped() {
    let newNote = Note(
      id: .init(),
      title: "New Untitled Note",
      body: "",
      creationDate: Date(),
      lastEditDate: Date()
    )
    _ = withAnimation {
      self.folder.notes.append(newNote)
    }
    self.destination = .note(.init(note: newNote))
  }
  
  func tappedUserOptionsButton() {
    destination = .userOptionsSheet
  }
  
  func deleteNote(_ note: Note) {
    _ = withAnimation {
      self.folder.notes.remove(id: note.id)
    }
  }
  
  func renameSelectedTapped() {
    
  }
  
  /**
   Deletes selected notes. If no notes are selected, delete all.
   */
  func deleteSelectedTapped() {
    self.destination = .alert(.init(
      title: TextState("Delete?"),
      message: TextState("Are you sure you want to delete this folder?"),
      buttons: [
        .destructive(TextState("Yes"), action: .send(.confirmDelete)),
        .cancel(TextState("Nevermind"))
      ]
    ))
  }
  
  private func confirmDeleteSelected() {
    withAnimation {
      if select.count == 0 { self.folder.notes = [] }
      else {
        self.folder.notes = self.folder.notes.filter {
          !select.contains($0.id)
        }
      }
    }
  }
}

extension FolderViewModel {
  enum Destination {
    case editSheet(FolderEditSheetViewModel)
    case note(NoteViewModel)
    case home
    case userOptionsSheet
    case alert(AlertState<AlertAction>)
    case renameAlert
    case moveSheet
  }
  
  enum AlertAction {
    case confirmDelete
  }
}

extension FolderViewModel {
  enum Sort: CaseIterable {
    case editDate
    case creationDate
    case title
    
    var string: String {
      switch self {
      case .editDate: return "Date Edited"
      case .creationDate: return "Date Created"
      case .title: return "Title"
      }
    }
  }
}

//MARK: - Folder
struct Folder: Identifiable, Codable {
  typealias ID = Tagged<Self, UUID>
  
  let id: ID
  var name: String
  var notes: IdentifiedArrayOf<Note>
}
