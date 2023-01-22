import Foundation
import IdentifiedCollections
import XCTestDynamicOverlay

final class SearchViewModel: ObservableObject {
  @Published var notes: IdentifiedArrayOf<Note>
  
  var topHits: IdentifiedArrayOf<Note> {
    .init(notes.prefix(2))
  }
  
  var noteTapped: (Note) -> Void = unimplemented("SearchViewModel.noteTapped")
  
  init(notes: IdentifiedArrayOf<Note>) {
    self.notes = notes
  }
}
