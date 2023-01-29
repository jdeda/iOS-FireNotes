import Foundation
import SwiftUI
import Tagged
import XCTestDynamicOverlay
import SwiftUINavigation

// MARK: - ViewModel
final class NoteViewModel: ObservableObject {
  @Published var note: Note
  @Published var focus: Focus?
  @Published var destination: Destination?
  
  var newNoteButtonTapped: (_ newNote: Note) -> Void = unimplemented("NoteViewModel.newNoteButtonTapped")
  var restoreButtonTapped: (_ note: Note) -> Void = unimplemented("NoteViewModel.restoreButtonTapped")
  
  init(
    note: Note,
    focus: Focus? = .title
  ) {
    self.note = note
    if !note.recentlyDeleted {
      self.focus = focus
    }
    self.destination = nil
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
  
  func tappedView() {
    if !note.recentlyDeleted { return }
    destination = .restoreAlert(.init(
      title: TextState("Restore"),
      message: TextState("Recently deleted notes must be restored to edit. Would you like to restore this note?"),
      buttons: [
        .default(TextState("Nevermind")),
        .default(TextState("Yes"), action: .send(.confirmRestoreNote)),
      ]
    ))
  }
  
  func alertButtonTapped(_ action: AlertAction) {
    switch action {
    case .confirmRestoreNote:
      restoreButtonTapped(note)
      break
    }
  }
}

extension NoteViewModel {
  enum Destination {
    case restoreAlert(AlertState<AlertAction>)
  }
  
  enum AlertAction {
    case confirmRestoreNote
  }
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
  var recentlyDeleted: Bool
  
  init(
    id: ID,
    title: String,
    body: String = "",
    creationDate: Date = Date(),
    lastEditDate: Date = Date(),
    folderName: String? = nil,
    recentlyDeleted: Bool = false
  ) {
    self.id = id
    self.title = title
    self.body = body
    self.creationDate = creationDate
    self.lastEditDate = lastEditDate
    self.folderName = folderName
    self.recentlyDeleted = recentlyDeleted
  }
  
  // String representation of a date in "MM/dd/YY" format
  var formattedDate: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/YY"
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
