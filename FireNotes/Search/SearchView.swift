import SwiftUI
import SwiftUINavigation
import IdentifiedCollections
import XCTestDynamicOverlay

// MARK: - View
struct SearchView: View {
  @ObservedObject var vm: SearchViewModel
  
  var body: some View {
      Section {
        ForEach(vm.topHits) { note in
          Row(note: note, query: vm.query)
            .onTapGesture {
              vm.noteTapped(note)
            }
        }
      } header: {
        HStack {
          Text("Top Results")
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
          Row(note: note, query: vm.query)
        }
      } header: {
        HStack {
          Text("All Results")
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

// MARK: - Helper Views
extension SearchView {
  struct Row: View {
    let note: Note
    let query: String
    let length = 25
    
    var noteBodyQueryDescription: String {
      guard let result = stringSearchResult(source: note.body, query: query, length: length)
      else { return note.subTitle }
      if result.isEmpty { return note.subTitle}
      return result
    }
    
    var body: some View {
      VStack(alignment: .leading) {
        HighlightedText(note.title, matching: query, caseInsensitive: true)
          .lineLimit(1)
          .fontWeight(.medium)
        HStack {
          Text(note.formattedDate)
            .font(.caption)
            .foregroundColor(.secondary)
          HighlightedText(noteBodyQueryDescription, matching: query, caseInsensitive: true)
            .lineLimit(1)
            .font(.caption)
            .foregroundColor(.secondary)
        }
        HStack(spacing: 4)  {
          Image(systemName: "folder")
          Text(note.folderName ?? "folder")
        }
        .font(.caption)
        .foregroundColor(.secondary)
        .font(.caption)
        .foregroundColor(.secondary)
      }
    }
  }
}

// MARK: - HighlightedText View
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


// MARK: - Previews
struct SearchViewSearchPreviews: PreviewProvider {
  static var previews: some View {
    Form {
      SearchView(vm: .init(query: "", notes: mockFolder.notes))
    }
  }
}
