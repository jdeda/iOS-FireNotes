import Foundation
import Combine
import IdentifiedCollections
import SwiftUINavigation
import SwiftUI
import Tagged
import XCTestDynamicOverlay

//MARK: - ViewModel
final class FolderViewModel: ObservableObject {
  @Published var folder: Folder
  @Published var sort: Sort // TODO: Move?
  @Published var isEditing: Bool
  @Published var selectedNotes: Set<Note.ID>
  @Published var searchedNotes: IdentifiedArrayOf<Note>
  @Published var search: String
  @Published var destinationCancellable: AnyCancellable?
  @Published var destination: Destination? {
    didSet { destinationBind() }
  }
  
  var hasSelectedAll: Bool {
    selectedNotes.count == folder.notes.count
  }
  
  var navigationBarTitle: String {
    isEditing && selectedNotes.count > 0 ? "\(selectedNotes.count) Selected": folder.name
  }
  
  var restoreNote: (_ note: Note) -> Void = unimplemented("FolderViewModel.restoreNote")
  
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
    self.performSort()
    self.destinationBind()
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
      noteVM.restoreButtonTapped = { [weak self] note in
        guard let self else { return }
        self.restoreNote(note)
      }
      // Listen for changes in the note when we are navigated in.
      self.destinationCancellable = noteVM.$note.sink { [weak self] newNote in
        guard let self else { return }
        self.folder.notes[id: newNote.id] = newNote
      }
      break
    case .some(.alert(_)):
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
      editSheetVM.addSubfolderButtonTapped = { [weak self] in
        guard let self else { return }
        self.editSheetAddSubfolderButtonTapped()
      }
      editSheetVM.moveButtonTapped = { [weak self] in
        guard let self else { return }
        self.editSheetMoveButtonTapped()
      }
      editSheetVM.renameButtonTapped = { [weak self] in
        guard let self else { return }
        self.editSheetRenameButtonTapped()
      }
      editSheetVM.dismissButtonTapped = { [weak self] in
        guard let self else { return }
        self.editSheetDismissButtonTapped()
      }
      break
    case .some(.addSubfolderSheet):
      break
    case .some(.moveSheet):
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
    case .some(.deleteSelectedAlert):
      break
    }
  }
  
  private func newNoteButtonTapped(newNote: Note) {
    folder.notes.append(newNote)
    destination = .note(.init(note: newNote, focus: .body))
  }
  
  private func performSort() {
    let newNotes: [Note] = {
      let notes = folder.notes.elements
      switch sort {
      case .editDate:
        return notes.sorted(using: KeyPathComparator(\.lastEditDate))
      case .creationDate:
        return notes.sorted(using: KeyPathComparator(\.creationDate))
      case .title:
        return notes.sorted(using: KeyPathComparator(\.title, comparator: .localizedStandard))
      }
    }()
    withAnimation {
      folder.notes = .init(uniqueElements: newNotes)
    }
  }
  
  func setSearch(_ newSearch: String) {
    self.search = newSearch
    performSearch()
  }
  
  func performSearch() {
    searchedNotes = .init(uniqueElements: folder.notes.filter {
      $0.title.lowercased().contains(search.lowercased()) ||
      $0.body.lowercased().contains(search.lowercased())
    })
  }
  
  func searchButtonTapped(_ note: Note) {
    destination = .note(.init(note: note))
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
    if folder.variant == .recentlyDeleted {
      destination = .alert(.init(
        title: TextState("Delete Selected Permanently"),
        message: TextState("Are you sure you want to delete the selected notes? These notes will be permanently deleted."),
        buttons: [
          .default(TextState("Nevermind")),
          .default(TextState("Yes"), action: .send(.confirmDelete)),
        ]
      ))

    }
    else {
      destination = .alert(.init(
        title: TextState("Delete Selected"),
        message: TextState("Are you sure you want to delete the selected notes?"),
        buttons: [
          .default(TextState("Nevermind")),
          .default(TextState("Yes"), action: .send(.confirmDelete)),
        ]
      ))

    }
  }
  
  func toolbarAppearEditSheetButtonTapped() {
    destination = .editFolderSheet(.init(
      folderVariant: folder.variant,
      folderName: folder.name,
      sort: sort
    ))
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
    destination = nil
    performSort()
  }
  
  private func editSheetAddSubfolderButtonTapped() {
    destination = nil
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // MARK: - Temp fix...?
      self.destination = .addSubfolderSheet
    }
  }
  
  private func editSheetMoveButtonTapped() {
    destination = nil
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // MARK: - Temp fix...?
      self.destination = .moveSheet
    }
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
    case let .confirmDeleteSingle(noteID):
      confirmDeleteSingle(noteID)
      break
    }
  }
  
  func renameAlertConfirmButtonTapped(_ newName: String) {
    folder.name = newName
  }
  
  func noteRowTapped(_ note: Note) {
    destination = .note(.init(note: note, focus: .body))
  }
  
  func deleteNoteButtonTapped(_ note: Note) {
    if folder.variant == .recentlyDeleted {
      destination = .alert(.init(
        title: TextState("Delete Permanently"),
        message: TextState("Are you sure you want to delete the selected note? This note will be permanently deleted."),
        buttons: [
          .default(TextState("Nevermind")),
          .default(TextState("Yes"), action: .send(.confirmDeleteSingle(note.id))),
        ]
      ))
    }
    else {
      _ = withAnimation {
        self.folder.notes.remove(id: note.id)
      }
    }
  }
  
  private func confirmDeleteSelected() {
    withAnimation {
      folder.notes = folder.notes.filter { !selectedNotes.contains($0.id) }
      destination = nil
      isEditing = false
    }
  }
  
  private func confirmDeleteSingle(_ noteID: Note.ID) {
    _ = withAnimation {
      folder.notes.remove(id: noteID)
    }
  }
}

extension FolderViewModel {
  enum Destination {
    case editFolderSheet(FolderEditSheetViewModel)
    case addSubfolderSheet
    case moveSheet
    case renameSelectedSheet(RenameSelectedSheetViewModel)
    case note(NoteViewModel)
    case alert(AlertState<AlertAction>)
    case renameAlert
    case deleteSelectedAlert
  }
  
  enum AlertAction {
    case confirmDelete
    case confirmDeleteSingle(Note.ID)
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

struct FolderRow: Identifiable {
  var id: Folder.ID { folder.id }
  var folder: Folder
  
  enum FolderVariant {
    case all
    case standard
    case user
    case recentlyDeleted
  }
}


//MARK: - Model
struct Folder: Identifiable, Equatable, Codable {
  typealias ID = Tagged<Self, UUID>

  let id: ID
  let variant: Variant
  var name: String
  var notes: IdentifiedArrayOf<Note>
  var folders: IdentifiedArrayOf<Folder>? = nil
  
  enum Variant: Codable {
    case all
    case standard
    case user
    case recentlyDeleted
  }
}

//struct Folder: Identifiable {
//  typealias ID = Tagged<Self, UUID>
//
//  let id: ID
//  var variant: Variant
//  var folder: FolderData
//
//    enum Variant: Codable {
//      case all
//      case standard
//      case user
//      case recentlyDeleted
//    }
//}
//
//struct FolderData: Identifiable, Codable {
//  typealias ID = Tagged<Self, UUID>
//
//  let id: ID
//  var name: String
//  var notes: IdentifiedArrayOf<Note>
//}
