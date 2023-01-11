import Foundation
import Combine
import IdentifiedCollections
import SwiftUINavigation
import SwiftUI
import Tagged

let mockFolder: Folder = .init(
  id: .init(),
  name: "Folder 1",
  notes: .init(uniqueElements: (1...10).map {
    .init(
      id: .init(),
      title: "Note \($0)",
      body: "I ate \($0)g of protein today",
      lastEditDate: Date()
    )
  }))

//MARK: - FolderViewModel
final class FolderViewModel: ObservableObject {
  @Published var folder: Folder
  @Published var select: Set<Note.ID>
  @Published var search: String
  @Published var editMode: EditMode?
  
  var isEditing: Bool {
    editMode != .inactive
  }
  
  @Published var destination: Destination? {
    didSet { destinationBind() }
  }
  
  private var destinationCancellable: AnyCancellable?
  
  init(
    folder: Folder = mockFolder,
    select: Set<Note.ID> = [],
    search: String = "",
    destination: Destination? = nil
  ) {
    self.folder = folder
    self.select = select
    self.search = search
    self.destination = destination
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
    if select.count == 0 { self.folder.notes = [] }
    else {
      self.folder.notes = self.folder.notes.filter {
        !select.contains($0.id)
      }
    }
  }
}

extension FolderViewModel {
  enum AlertAction {
    case confirmRename
  }
}

// TODO: camelCase
extension FolderViewModel {
  enum Destination {
    case note(NoteViewModel)
    case home
    case userOptionsSheet
//    case Alert(AlertState<AlertAction>)
  }
}

//MARK: - Folder
struct Folder: Identifiable, Codable {
  typealias ID = Tagged<Self, UUID>
  
  let id: ID
  var name: String
  var notes: IdentifiedArrayOf<Note>
}

