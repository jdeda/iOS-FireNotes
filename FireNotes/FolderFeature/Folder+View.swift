import SwiftUI
import SwiftUINavigation

struct FolderView: View {
  @ObservedObject var vm: FolderViewModel = .init()
  
  var body: some View {
    VStack(alignment: .leading) {
      TextField(vm.folder.name, text: $vm.folder.name)
        .font(.system(size: 34, weight: .bold))
        .padding([.leading], 18)
      
      Searchbar(searchText: $vm.search)
        .padding([.leading, .trailing], 18)
      
      List {
        ForEach(vm.folder.notes) { note in
          VStack(alignment: .leading) {
            Text(note.title)
            
            HStack {
              Text(note.formattedDate)
                .font(.caption)
                .foregroundColor(.secondary)
              
              Text(note.subTitle)
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }
        }
        .onDelete(perform: vm.delete)
        .listRowBackground(Color(UIColor.systemGray6))
      }
      .scrollContentBackground(Visibility.hidden)
    }
    .navigationDestination(
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.Note
    ) { $noteVM in
      NoteView(vm: noteVM)
    }
    .toolbar {
      ToolbarItemGroup(placement: .primaryAction) {
        Button {
          vm.tappedUserOptionsButton()
        } label: {
          Image(systemName: "ellipsis.circle")
        }
      }
      ToolbarItemGroup(placement: .bottomBar) {
        Spacer()
        Text("\(vm.folder.notes.count) notes")
        Spacer()
          Button {
            vm.addNoteButtonTappped()
          } label: {
            Image(systemName: "square.and.pencil")
          }
      }
    }
    .navigationBarTitle("")
  }
}

struct FolderView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      FolderView()
    }
  }
}
