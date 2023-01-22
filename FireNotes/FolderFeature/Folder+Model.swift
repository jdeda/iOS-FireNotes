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
  @Published var sort: Sort // TODO: Move?
  @Published var isEditing: Bool
  @Published var selectedNotes: Set<Note.ID>
  @Published var searchedNotes: IdentifiedArrayOf<Note>
  @Published var search: String
  @Published var destination: Destination? {
    didSet { destinationBind() }
  }
  
  @Published var destinationCancellable: AnyCancellable?
  
  var hasSelectedAll: Bool {
    selectedNotes.count == folder.notes.count
  }
  
  var navigationBarTitle: String {
    isEditing && selectedNotes.count > 0 ? "\(selectedNotes.count) Selected": folder.name
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
    self.selectedNotes = select
    self.search = search
    self.destination = destination
    self.isEditing = isEditing
    self.sort = sort
    self.searchedNotes = []
    destinationBind()
  }
  
  private func destinationBind() {
    switch destination {
    case .none:
      break
    case let .note(noteVM):
      noteVM.newNoteButtonTapped = { [weak self] newNote in
        guard let self else { return }
        self.newNoteButtonTapped(newNote: newNote)
      }
      // Listen for changes in the note when we are navigated in.
      self.destinationCancellable = noteVM.$note.sink { [weak self] newNote in
        guard let self else { return }
        self.folder.notes[id: newNote.id] = newNote
      }
      break
    case .some(.alert(_)):
      break
    case .some(.moveSheet):
      break
    case .some(.renameAlert):
      break
    case let .editFolderSheet(editSheetVM):
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
    }
  }
  
  private func newNoteButtonTapped(newNote: Note) {
    self.folder.notes.append(newNote)
    self.destination = .note(.init(note: newNote, focus: .body))
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
    selectedNotes = hasSelectedAll ? [] : .init(folder.notes.map(\.id))
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
    destination = .editFolderSheet(.init(folderName: folder.name))
  }
  
  func toolbarAddNoteButtonTappped() {
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
  
  private func editSheetSelectButtonTapped() {
    isEditing = true
    destination = nil
  }
  
  private func editSheetSortPickerOptionTapped(_ newSort: Sort) -> Void {
    sort = newSort
    performSort()
  }
  
  private func editSheetAddSubfolderButtonTapped() {
    
  }
  
  private func editSheetMoveButtonTapped() {
    
  }
  
  private func editSheetRenameButtonTapped() {
    self.destination = nil
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // MARK: - Temp fix...?
      self.destination = .renameAlert
    }
  }
  
  private func renameSelectedSheetConfirmButtonTapped(renameValues: RenameValues) {
    let orderedSelectedNotes = folder.notes.filter { selectedNotes.contains($0.id) }.elements
    let updatedNames = renameValues.rename(orderedSelectedNotes.map(\.title))
    let zipped = zip(orderedSelectedNotes, updatedNames)
    let updatedOrderedSelectedNotes = zipped.map { (note, newName) -> Note in
      var newNote = note
      newNote.title = newName
      return newNote
    }
    withAnimation {
      folder.notes = .init(uniqueElements: folder.notes.map { note in
        updatedOrderedSelectedNotes.first(where: { $0.id == note.id }) ?? note
      })
      destination = nil
      isEditing = false
    }
  }
  
  private func renameSelectedSheetCancelButtonTapped()  {
    destination = nil
  }
  
  private func editSheetDismissButtonTapped() {
    destination = nil
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
  
  func noteRowTapped(_ note: Note) {
    destination = .note(NoteViewModel(
      note: note,
      focus: .body
    ))
  }
  
  func deleteNoteButtonTapped(_ note: Note) {
    _ = withAnimation {
      self.folder.notes.remove(id: note.id)
    }
  }
  
  private func confirmDeleteSelected() {
    withAnimation {
      folder.notes = folder.notes.filter { !selectedNotes.contains($0.id) }
      destination = nil
      isEditing = false
    }
  }
}

extension FolderViewModel {
  enum Destination {
    case editFolderSheet(FolderEditSheetViewModel)
    case renameSelectedSheet(RenameSelectedSheetViewModel)
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
