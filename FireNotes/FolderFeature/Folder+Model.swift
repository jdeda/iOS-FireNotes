import Foundation

final class FolderViewModel: ObservableObject {
  @Published var folder: Folder = .init(id: UUID(), name: "Foo", notes: (1...10).map {
    .init(
      id: UUID(),
      title: "Note \($0)",
      body: "I ate \($0)g of protein today blahblahblahblahblahblahblahblahblah",
      lastEditDate: Date()
    )
  })
  
  @Published var search: String = "Search"
  
  func addNoteButtonTappped() {

  }
  
  func tappedOptionsButton() {
    
  }
}

extension FolderViewModel {
  enum Destination {
    case Note(Note)
    case Home
  }
}

struct Folder: Identifiable {
  let id: UUID
  var name: String
  var notes: [Note]
}

