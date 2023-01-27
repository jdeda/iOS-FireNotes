import Foundation
import SwiftUI
import Tagged
import XCTestDynamicOverlay

// MARK: - ViewModel
final class NoteViewModel: ObservableObject {
  @Published var note: Note
  @Published var focus: Focus?
  
  var newNoteButtonTapped: (_ newNote: Note) -> Void = unimplemented("NoteViewModel.newNoteButtonTapped")
  
  init(
    note: Note,
    focus: Focus? = .title
  ) {
    self.note = note
    self.focus = focus
  }
  
  func titleSubmitKeyTapped() {
    focus = .body
  }
  
  func keyboardDismissButtonTapped() {
    focus = nil
  }
  
  func addNoteButtonTappped() {
    let newNote = Note(
      id: .init(),
      title: "New Untitled Note",
      body: "",
      lastEditDate: Date()
    )
    newNoteButtonTapped(newNote)
  }
}

extension NoteViewModel {
  enum Focus: Hashable {
    case title
    case body
  }
}


// MARK: - Model
struct Note: Identifiable, Equatable, Hashable, Codable {
  typealias ID = Tagged<Self, UUID>

  let id: ID
  let creationDate: Date
  var lastEditDate: Date
  var title: String
  var body: String
  var folderName: String?
  
  init(
    id: ID,
    title: String,
    body: String = "",
    creationDate: Date = Date(),
    lastEditDate: Date = Date(),
    folderName: String? = nil
  ) {
    self.id = id
    self.title = title
    self.body = body
    self.creationDate = creationDate
    self.lastEditDate = lastEditDate
    self.folderName = folderName
  }
  
  // String representation of a date in "YY/MM/dd" format
  var formattedDate: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YY/MM/dd"
    return dateFormatter.string(from: lastEditDate)
  }
  
  // String representation of a date in "EEEE MMM d, yyyy, h:mm a" format
  var formattedDateVerbose: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE MMM d, yyyy, h:mm a"
    return "Created \(dateFormatter.string(from: lastEditDate))"
  }
  
  // Gets the first few words of the body, or none.
  var subTitle: String {
    let split = self.body.split(separator: " ")
    return split.reduce("", { partial, next in
      let new = partial + " " + next
      return new.count > 20 ? partial : new
    })
  }
}
