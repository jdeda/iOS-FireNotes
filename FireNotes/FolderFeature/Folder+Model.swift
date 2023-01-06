import Foundation
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
      body: "I ate \($0)g of protein today blahblahblahblahblahblahblahblahblah",
      lastEditDate: Date()
    )
  }))

//MARK: - FolderViewModel
final class FolderViewModel: ObservableObject {
  @Published var folder: Folder
  @Published var select: Set<Note.ID>
  @Published var search: String
  @Published var destination: Destination? {
    didSet { bind() }
  }
  
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
  
  func bind() {
    switch destination {
    case .none:
      break
    case .Home:
      break
    case .Edit:
      break
    case .Note(_):
      break
    }
  }
  
  func noteTapped(_ note: Note) {
    destination = .Note(NoteViewModel(note: note))
  }
  
  func addNoteButtonTappped() {
    let newNote = Note(
      id: .init(),
      title: "New Note!",
      body: "",
      lastEditDate: Date()
    )
    self.folder.notes.append(newNote)
    self.destination = .Note(.init(note: newNote))
  }
  
  func tappedUserOptionsButton() {
    
  }
  
  // Uh oh...
  func moveNote(from source: IndexSet, to destination: Int) {
    folder.notes.move(fromOffsets: source, toOffset: destination)
  }
  
  func deleteNote(_ note: Note) {
    withAnimation {
      self.folder.notes.remove(id: note.id)
    }
  }
}

extension FolderViewModel {
  enum Destination {
    case Edit
    case Note(NoteViewModel)
    case Home
  }
}

//MARK: - Folder
struct Folder: Identifiable, Codable {
  typealias ID = Tagged<Self, UUID>

  let id: ID
  var name: String
  var notes: IdentifiedArrayOf<Note>
  
}

