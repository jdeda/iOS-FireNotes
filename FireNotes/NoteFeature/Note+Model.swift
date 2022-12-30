import Foundation

final class NoteViewModel: ObservableObject {
  @Published var note: Note = .init(id: UUID(), title: "New Untitled Note", body: "", lastEditDate: Date())
  
  func tappedOptionsButton() {
    
  }
  
  func addNoteButtonTappped() {
    
  }
}

struct Note: Identifiable {
  let id: UUID
  var title: String
  var body: String
  var lastEditDate: Date
  
  
  var formattedDate: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YY/MM/dd"
    return dateFormatter.string(from: lastEditDate)
  }
  
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
