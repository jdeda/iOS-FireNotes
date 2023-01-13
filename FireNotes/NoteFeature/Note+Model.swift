import Foundation
import SwiftUI
import Tagged
import XCTestDynamicOverlay

final class NoteViewModel: ObservableObject {
  @Published var note: Note
  @Published var destination: Destination?
  @Published var focus: Focus?
  
  var newNoteButtonTapped: (_ newNote: Note) -> Void = unimplemented()
  
  init(
    note: Note = .init(id: .init(), title: "New Untitled Note", body: ""),
    destination: Destination? = nil,
    focus: Focus? = .title
  ) {
    self.note = note
    self.destination = destination
    self.focus = focus
  }
  
  func tappedUserOptionsButton() {
    self.destination = .UserOptionsSheet
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
  enum Destination {
    case UserOptionsSheet
  }
  
  enum Focus: Hashable {
    case title
    case body
  }
}

struct Note: Identifiable, Codable {
  typealias ID = Tagged<Self, UUID>

  let id: ID
  var title: String
  var body: String
  let creationDate: Date
  var lastEditDate: Date
  
  init(
    id: ID,
    title: String,
    body: String = "",
    creationDate: Date = Date(),
    lastEditDate: Date = Date()
  ) {
    self.id = id
    self.title = title
    self.body = body
    self.creationDate = creationDate
    self.lastEditDate = lastEditDate
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
