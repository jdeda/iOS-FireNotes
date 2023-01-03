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
  
  var isEditing: Bool {
    let yah = (/FolderViewModel.Destination.Edit).extract(from: destination) != nil
    print(yah)
    return yah
  }
    
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
  
  func editButtonTapped() {
    let editing = (/FolderViewModel.Destination.Edit).extract(from: destination) != nil
    destination = editing ? nil : .Edit
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
    case Edit
//    case Edit(EditMode)
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

