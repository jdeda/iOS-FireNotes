import Foundation
import SwiftUINavigation
import SwiftUI

let mockFolder: Folder = .init(
  id: UUID(),
  name: "Folder 1",
  notes: (1...10).map {
  .init(
    id: UUID(),
    title: "Note \($0)",
    body: "I ate \($0)g of protein today blahblahblahblahblahblahblahblahblah",
    lastEditDate: Date()
  )
})

//MARK: - FolderViewModel
final class FolderViewModel: ObservableObject {
  @Published var folder: Folder
  @Published var select: Set<UUID>
  @Published var search: String
  @Published var destination: Destination?
  
  init(
    folder: Folder = mockFolder,
    select: Set<UUID> = [],
    search: String = "",
    destination: Destination? = nil
  ) {
    self.folder = folder
    self.select = select
    self.search = search
    self.destination = destination
  }
  
  func noteTapped(_ note: Note) {
    destination = .Note(NoteViewModel(note: note))
  }
  
  func addNoteButtonTappped() {
    let newNote = Note(
      id: UUID(),
      title: "New Note!",
      body: "",
      lastEditDate: Date()
    )
    self.folder.notes.append(newNote)
    self.destination = .Note(.init(note: newNote))
  }
  
  func tappedUserOptionsButton() {
    
  }
  
  func moveNote(from source: IndexSet, to destination: Int) {
    folder.notes.move(fromOffsets: source, toOffset: destination)
  }
  
  func deleteNote(_ note: Note) {
    withAnimation {
      self.folder.notes.removeAll(where:  { $0.id == note.id })
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
struct Folder: Identifiable {
  let id: UUID
  var name: String
  var notes: [Note]
}

