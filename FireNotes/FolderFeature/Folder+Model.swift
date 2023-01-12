import Foundation
import Combine
import IdentifiedCollections
import SwiftUINavigation
import SwiftUI
import Tagged

//MARK: - FolderViewModel
final class FolderViewModel: ObservableObject {
  @Published var folder: Folder
  @Published var select: Set<Note.ID>
  @Published var search: String
  @Published var renameText: String
  @Published var isEditing: Bool
  @Published var sort: Sort {
    didSet { performSort() }
  }
  
  @Published var destination: Destination? {
    didSet { destinationBind() }
  }
  
  private var destinationCancellable: AnyCancellable?
  
  var hasSelectedAll: Bool {
    select.count == folder.notes.count
  }
  
  init(
    folder: Folder = mockFolder,
    select: Set<Note.ID> = [],
    search: String = "",
    destination: Destination? = nil,
    renameText: String = "",
    isEditing: Bool = false,
    sort: Sort = .editDate
  ) {
    self.folder = folder
    self.select = select
    self.search = search
    self.destination = destination
    self.renameText = renameText
    self.isEditing = isEditing
    self.sort = sort
  }
  
  func destinationBind() {
    switch destination {
    case .none:
      break
    case .home:
      break
    case let .note(noteVM):
      noteVM.newNoteButtonTapped = { [weak self] in
        guard let self else { return }
        let newNote = Note(
          id: .init(),
          title: "New Untitled Note",
          body: "",
          lastEditDate: Date()
        )
        self.folder.notes.append(newNote)
        self.destination = .note(.init(note: newNote, focus: .body))
      }
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
    }
  }
  
  private func performSort() {
    withAnimation {
      switch sort {
      case .editDate:
        folder.notes.sort(using: KeyPathComparator(\.lastEditDate))
      case .creationDate:
        folder.notes.sort(using: KeyPathComparator(\.lastEditDate))
      case .title:
        folder.notes.sort(using: KeyPathComparator(\.title, comparator: .localizedStandard))
      }
    }
  }
  
  func toggleEditButtonTapped() {
    isEditing.toggle()
  }
  
  func selectAllButtonTapped() {
    select = hasSelectedAll ? [] : .init(folder.notes.map(\.id))
  }
  
  func alertButtonTapped(_ action: AlertAction) {
    switch action {
    case .confirmDelete:
      confirmDeleteSelected()
      break
    }
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
    self.folder.notes.append(newNote)
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
    case note(NoteViewModel)
    case home
    case userOptionsSheet
    case alert(AlertState<AlertAction>)
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
      case .editDate:
        return "Date Edited"
      case .creationDate:
        return "Date Created"
      case .title:
        return "Title"
      }
    }
  }
  
  //  enum Sort: CaseIterable {
  //    static var allCases: [FolderViewModel.Sort] = [
  //      .editDate(chronological: true), .creationDate(chronological: true), .title(alphabetical: true)
  //    ]
  //
  //    case editDate(chronological: Bool)
  //    case creationDate(chronological: Bool)
  //    case title(alphabetical: Bool)
  //
  //    var string: String {
  //      switch self {
  //      case .editDate(_):
  //        return "Date Edited"
  //      case .creationDate(_):
  //        return "Date Created"
  //      case .title(_):
  //        return "Title"
  //      }
  //    }
  //  }
}

//MARK: - Folder
struct Folder: Identifiable, Codable {
  typealias ID = Tagged<Self, UUID>
  
  let id: ID
  var name: String
  var notes: IdentifiedArrayOf<Note>
}
