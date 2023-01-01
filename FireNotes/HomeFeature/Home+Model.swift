import Foundation

final class HomeViewModel: ObservableObject {
  @Published var folders: [Folder] = (1...20).map {
    .init(
      id: UUID(),
      name: "Folder \($0)",
      notes: (1...10).map {
        .init(id: UUID(), title: "Note \($0)", body: "I ate \($0)g of protein today", lastEditDate: Date()
        )
      })
  }
  @Published var search: String = "Search"
  @Published var destination: Destination?
  
  func addFolderButtonTappped() {
    
  }
  
  func addNoteButtonTapped() {
    
  }
  
  func tappedUserOptionsButton() {
    
  }
}

extension HomeViewModel {
  enum Destination {
    case folder(Folder)
  }
}
