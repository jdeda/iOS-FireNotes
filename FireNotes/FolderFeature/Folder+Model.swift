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
    case .Home:
      break
    case let .Note(noteVM):
      noteVM.newNoteButtonTapped = { [weak self] in
        guard let self else { return }
        let newNote = Note(
          id: .init(),
          title: "New Untitled Note",
          body: "",
          lastEditDate: Date()
        )
        self.folder.notes.append(newNote)
        self.destination = .Note(.init(note: newNote, focus: .body))
      }
      self.destinationCancellable = noteVM.$note.sink { [weak self] newNote in
        guard let self else { return }
        self.folder.notes[id: newNote.id] = newNote
      }
      break
    case .UserOptionsSheet:
      break
    }
  }
  
  func noteTapped(_ note: Note) {
    destination = .Note(NoteViewModel(
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
    self.destination = .Note(.init(note: newNote))
  }
  
  func tappedUserOptionsButton() {
    destination = .UserOptionsSheet
  }
  
  func deleteNote(_ note: Note) {
    _ = withAnimation {
      self.folder.notes.remove(id: note.id)
    }
  }
}

// TODO: camelCase
extension FolderViewModel {
  enum Destination {
    case Note(NoteViewModel)
    case Home
    case UserOptionsSheet
  }
}

//MARK: - Folder
struct Folder: Identifiable, Codable {
  typealias ID = Tagged<Self, UUID>

  let id: ID
  var name: String
  var notes: IdentifiedArrayOf<Note>
  
}

