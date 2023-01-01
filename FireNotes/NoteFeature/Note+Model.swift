import Foundation
import SwiftUI

final class NoteViewModel: ObservableObject {
  @Published var note: Note
  @Published var destination: Destination?
//  @Published var focus: Focus?
  
  init(
    note: Note = .init(id: UUID(), title: "New Untitled Note", body: "", lastEditDate: Date()),
    destination: Destination? = nil
//    focus: Focus? = .title
  ) {
    self.note = note
    self.destination = destination
//    self.focus = focus
  }
  
  func tappedUserOptionsButton() {
    self.destination = .UserOptionsSheet
  }
  
  func addNoteButtonTappped() {
    
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

struct Note: Identifiable {
  let id: UUID
  var title: String
  var body: String
  var lastEditDate: Date
  
  
  // String representation of a date in "YY/MM/dd" format
  var formattedDate: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YY/MM/dd"
    return dateFormatter.string(from: lastEditDate)
  }
  
  // String representation of a date in "EEEE, MMM d, yyyy" format
  var formattedDateVerbose: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
    return dateFormatter.string(from: lastEditDate)
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
