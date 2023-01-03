import Foundation
import SwiftUINavigation

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
  @Published var search: String
  @Published var destination: Destination?
    
  init(
    folder: Folder = mockFolder,
    search: String = "",
    destination: Destination? = nil
  ) {
    self.folder = folder
    self.search = search
    self.destination = destination
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
  
  func delete(at offsets: IndexSet) {
    self.folder.notes.remove(atOffsets: offsets)
  }
}

extension FolderViewModel {
  enum Destination {
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

