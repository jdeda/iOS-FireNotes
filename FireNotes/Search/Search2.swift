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
  
  var body: some View {
    Section {
      ForEach(vm.topHits) { note in
        Row(note: note)
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
        Row(note: note)
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
          . textCase(nil)
        
      }
    }
  }
}

extension Search {
  struct Row: View {
    let note: Note
    var body: some View {
      VStack(alignment: .leading) {
        Text(note.title)
          .fontWeight(.medium)
        HStack {
          Text(note.formattedDate)
            .font(.caption)
            .foregroundColor(.secondary)
          Text(note.subTitle)
            .font(.caption)
            .foregroundColor(.secondary)
        }
        HStack(alignment: .center) {
          Image(systemName: "folder")
            .foregroundColor(Color.yellow)
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
    Search(vm: .init(notes: mockFolder.notes))
  }
}
