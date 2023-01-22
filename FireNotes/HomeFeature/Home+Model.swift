import Foundation
import IdentifiedCollections

// MARK: - HomeViewModel
final class HomeViewModel: ObservableObject {
  @Published var folders: [Folder]
  @Published var search: String
  @Published var destination: Destination? {
    didSet { self.bind() }
  }
  
  init(
    folders: [Folder],
    search: String = "",
    destination: Destination? = nil
  ) {
    self.folders = folders
    self.search = search
    self.destination = destination
  }
  
  func bind() {
    switch destination {
    case .folder(_):
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
