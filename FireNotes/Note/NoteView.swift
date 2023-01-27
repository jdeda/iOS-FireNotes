import SwiftUI
import SwiftUINavigation

// MARK: - View
struct NoteView: View {
  @ObservedObject var vm: NoteViewModel
  @FocusState var focus: NoteViewModel.Focus?
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        TextField("", text: $vm.note.title, axis: .vertical)
          .onSubmit(vm.titleSubmitKeyTapped)
          .font(.system(size: 34, weight: .bold))
          .focused($focus, equals: .title)
          .scrollDisabled(true)
        
        Text(vm.note.formattedDateVerbose)
          .font(.caption)
          .foregroundColor(.secondary)
          .scrollDisabled(true)
        
        TextEditor(text: $vm.note.body)
          .focused($focus, equals: .body)
          .scrollDisabled(true)
        Spacer()
      }
      .padding([.leading, .trailing], 14)
    }
    .disabled(vm.note.recentlyDeleted)
    .onTapGesture {
      vm.tappedView()
    }
    .alert(
      unwrapping: $vm.destination,
      case: /NoteViewModel.Destination.restoreAlert,
      action: { alertAction in
        vm.alertButtonTapped(alertAction)
      }
    )
    .navigationTitle("")
    .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
    .toolbar {
      if !vm.note.recentlyDeleted {
        ToolbarItemGroup(placement: .keyboard) { // MARK: Not ideal way of hiding a keyboard :(
          Spacer()
          Button {
            vm.keyboardDismissButtonTapped()
          } label: {
            Image(systemName: "xmark")
          }
          .buttonStyle(.plain)
        }
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Button {
            vm.addNoteButtonTappped()
          } label: {
            Image(systemName: "square.and.pencil")
          }
        }
      }
    }
    .bind(self.$vm.focus, to: self.$focus)
  }
}

// MARK: - Previews
struct NoteView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      NoteView(vm: .init(note: mockNote))
    }
  }
}
