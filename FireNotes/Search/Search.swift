//import SwiftUI
//import SwiftUINavigation
//import IdentifiedCollections
//import XCTestDynamicOverlay
//
///**
// What is the search feature:
//    - search bar and its searches all the notes in all the folders, searching if any of the notes
//      contain the query in the title and or body
//    - optional, but convoluted, gives results representing the title and or body containg the query
// */
//
///**
// Question on parent-child relationships
//  should a parent listen to state changes in a child or use a callback?
// */
//final class SearchViewModel: ObservableObject {
//  @Published var notes: IdentifiedArrayOf<Note>
//  
//  @Published var destination: Destination? {
//    didSet { bindDestination() }
//  }
//  var topHits: IdentifiedArrayOf<Note> {
//    .init(notes.prefix(2))
//  }
//  
//  var noteTapped: (Note) -> Void = unimplemented("SearchViewModel.noteTapped")
//  
//  init(
//    notes: IdentifiedArrayOf<Note>,
//    destination: Destination? = nil
//  ) {
//    self.notes = notes
//    self.destination = destination
//    self.bindDestination()
//  }
//  
//  private func bindDestination() {
//    switch destination {
//    case .none:
//      break
//    case let .note(_):
////      noteVM.newNoteButtonTapped = { [weak self] newNote in
////        guard let self else { return }
////        self.folder.notes.append(newNote)
////        self.destination = .note(.init(note: newNote, focus: .body))
////      }
////      // when a note chanegs
////      self.destinationCancellable = noteVM.$note.sink { [weak self] newNote in
////        guard let self else { return }
////        self.folder.notes[id: newNote.id] = newNote
////      }
//      break
//    }
//  }
//  
////  func tappedRow(_ note: Note) {
////    destination = .note(.init(note: note))
////  }
//}
//
//extension SearchViewModel {
//  enum Destination {
//    case note(NoteViewModel)
//  }
//}
//
//struct Search: View {
//  @ObservedObject var vm: SearchViewModel
//  
//  var body: some View {
//    VStack {
//      Section {
//        ForEach(vm.topHits) { note in
//          Row(note: note)
////            .onTapGesture {
////              vm.tappedRow(note)
////            }
//        }
//      } header: {
//        HStack {
//          Text("Top Hits")
//            .font(.title2)
//            .fontWeight(.medium)
//            .foregroundColor(.black)
//            . textCase(nil)
//          
//          Spacer()
//          Text("\(vm.topHits.count) Found")
//            .font(.body)
//            .foregroundColor(.secondary)
//            .textCase(nil)
//        }
//      }
//      Section {
//        ForEach(vm.notes) { note in
//          Row(note: note)
//        }
//      } header: {
//        HStack {
//          Text("Notes")
//            .font(.title2)
//            .fontWeight(.medium)
//            .foregroundColor(.black)
//            . textCase(nil)
//          Spacer()
//          Text("\(vm.notes.count) Found")
//            .font(.body)
//            .foregroundColor(.secondary)
//            . textCase(nil)
//          
//        }
//      }
//    }
//    .navigationDestination(
//      unwrapping: $vm.destination,
//      case: /SearchViewModel.Destination.note
//    ) { $noteVM in
//      NoteView(vm: noteVM)
//    }
//  }
//}
//
//extension Search {
//  struct Row: View {
//    let note: Note
//    var body: some View {
//      VStack(alignment: .leading) {
//        Text(note.title)
//          .fontWeight(.medium)
//        HStack {
//          Text(note.formattedDate)
//            .font(.caption)
//            .foregroundColor(.secondary)
//          Text(note.subTitle)
//            .font(.caption)
//            .foregroundColor(.secondary)
//        }
//        HStack(alignment: .center) {
//          Image(systemName: "folder")
//            .foregroundColor(Color.yellow)
//          Text("folder")
//            .foregroundColor(.black)
//          Spacer()
//        }
//      }
//    }
//  }
//}
//
//struct SearchPreviews: PreviewProvider {
//  static var previews: some View {
//    Search(vm: .init(notes: mockFolder.notes))
//  }
//}
