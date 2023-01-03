import SwiftUI
import SwiftUINavigation
import CasePaths

struct FolderView: View {
  @ObservedObject var vm: FolderViewModel = .init()
  
  var body: some View {
    VStack(alignment: .leading) {
      TextField(vm.folder.name, text: $vm.folder.name)
        .font(.system(size: 34, weight: .bold))
        .padding([.leading], 18)
      
      Searchbar(searchText: $vm.search)
        .padding([.leading, .trailing], 18)
      
      List(selection: $vm.select) {
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
          .tag(note.id)
        }
        .onDelete(perform: vm.delete)
        .deleteDisabled(!vm.isEditing)
//        .deleteDisabled(
//          (/FolderViewModel.Destination.Edit).extract(from: vm.destination) != nil
//        )
        .listRowBackground(Color(UIColor.systemGray6))
      }
      .scrollContentBackground(Visibility.hidden)
      .toolbar {
        EditButton()
//        Button {
//          vm.editButtonTapped()
//        } label: {
//          let editing = (/FolderViewModel.Destination.Edit).extract(from: vm.destination) != nil
//          Text(editing ? "Done" : "Edit")
//        }
      }
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
    .environment(\.editMode, Binding(
      get: {
        ((/FolderViewModel.Destination.Edit).extract(from: vm.destination) != nil) ? .active : .inactive
      },
      set: { newValue in
        if newValue == .inactive {
          vm.destination = nil
        }
        else {
          vm.destination = .Edit
        }
      }
    ))
//    .environment(\.editMode, Binding(
//      get: {
//        ((/FolderViewModel.Destination.Edit).extract(from: vm.destination) != nil) ? .active : .inactive
//      },
//      set: { _ in }
//    ))
//    .environment(\.editMode, Binding(
//      get: {
//        guard let editMode = (/FolderViewModel.Destination.Edit).extract(from: vm.destination)
//        else { return .inactive }
//        return editMode
//      },
//      set: { newValue in
////        vm.destination = .Edit(newValue) // Naive.
//        if newValue == .inactive {
//          vm.destination = nil
//        }
//        else {
//          vm.destination = .Edit(newValue)
//        }
//      }
//    ))
    .navigationBarTitle("")
    .navigationDestination(
      unwrapping: $vm.destination,
      case: /FolderViewModel.Destination.Note
    ) { $noteVM in
      NoteView(vm: noteVM)
    }
  }
}

struct FolderView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      FolderView()
    }
  }
}




