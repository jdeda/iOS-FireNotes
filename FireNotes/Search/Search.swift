import SwiftUI
import SwiftUINavigation
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

struct Search: View {
  @ObservedObject var vm: SearchViewModel
  let query: String
  
  var body: some View {
    Section {
      ForEach(vm.topHits) { note in
        Row(note: note, query: query)
          .onTapGesture {
            vm.noteTapped(note)
          }
      }
    } header: {
      HStack {
        Text("Top Hits")
          .font(.title2)
          .fontWeight(.medium)
          .foregroundColor(.black)
          . textCase(nil)
        
        Spacer()
        Text("\(vm.topHits.count) Found")
          .font(.body)
          .foregroundColor(.secondary)
          .textCase(nil)
      }
    }
    Section {
      ForEach(vm.notes) { note in
        Row(note: note, query: query)
      }
    } header: {
      HStack {
        Text("Notes")
          .font(.title2)
          .fontWeight(.medium)
          .foregroundColor(.black)
          . textCase(nil)
        Spacer()
        Text("\(vm.notes.count) Found")
          .font(.body)
          .foregroundColor(.secondary)
          .textCase(nil)
      }
    }
    }
}

extension Search {
  struct Row: View {
    let note: Note
    let query: String
    let length = 25
    
    var noteBodyQueryDescription: String {
      guard let result = stringSearchResult(
        source: note.body,
        query: query,
        length: length
      )
      else { return note.subTitle }
      if result.isEmpty  { return note.subTitle}
      return result
    }
    
    var body: some View {
      VStack(alignment: .leading) {
        HighlightedText(note.title, matching: query, caseInsensitive: true)
          .fontWeight(.medium)
        HStack {
          Text(note.formattedDate)
            .font(.caption)
            .foregroundColor(.secondary)
          HighlightedText(noteBodyQueryDescription, matching: query, caseInsensitive: true)
            .font(.caption)
            .foregroundColor(.secondary)
        }
        HStack(alignment: .center) {
          Image(systemName: "folder")
            .foregroundColor(.secondary)
          Text("folder")
            .foregroundColor(.black)
          Spacer()
        }
      }
    }
  }
}

struct SearchPreviews: PreviewProvider {
  static var previews: some View {
    Search(vm: .init(notes: mockFolder.notes), query: "")
  }
}

// MARK: - I have no idea how this works. Nice!
struct HighlightedText: View {
  let text: String
  let matching: String
  let caseInsensitive: Bool
  
  init(_ text: String, matching: String, caseInsensitive: Bool = false) {
    self.text = text
    self.matching = matching
    self.caseInsensitive = caseInsensitive
  }
  
  var body: some View {
    guard let regex = nsRegex(query: matching, caseInsensitive: caseInsensitive)
    else { return Text(text) }
    let range = NSRange(location: 0, length: text.count)
    let matches = regex.matches(in: text, options: .withTransparentBounds, range: range)
    
    return text.enumerated()
      .map { (char) -> Text in
        guard matches.filter({$0.range.contains(char.offset)}).count == 0
        else { return Text(String(char.element)).foregroundColor(.yellow) }
        return Text(String(char.element))
      }
      .reduce(Text("")) { (a, b) -> Text in
        return a + b
      }
  }
}
