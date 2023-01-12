import Foundation
import IdentifiedCollections

let mockFolders: [Folder] = (1...20).map {
  .init(
    id: .init(),
    name: "Folder \($0)",
    notes: .init(uniqueElements: (1...10).map {
        .init(id: .init(), title: "Note \($0)", body: "I ate \($0)g of protein today", lastEditDate: Date())
    })
  )
}

// MARK: - HomeViewModel
final class HomeViewModel: ObservableObject {
  @Published var folders: [Folder]
  @Published var search: String
  @Published var destination: Destination? {
    didSet { self.bind() }
  }
  
  init(
    folders: [Folder] = mockFolders,
    search: String = "",
    destination: Destination? = nil
  ) {
    self.folders = folders
    self.search = search
    self.destination = destination
  }
  
  func bind() {
        switch destination {
        case let .folder(folderVM):
          break
        case .none:
          break
        }
  }
  
  func folderTapped(_ folder: Folder) {
    destination = .folder(.init(folder: folder))
  }
}

extension HomeViewModel {
  enum Destination {
    case folder(FolderViewModel)
  }
}
