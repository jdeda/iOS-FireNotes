import SwiftUI
import SwiftUINavigation

// MARK: - View
struct NoteView: View {
  @ObservedObject var vm: NoteViewModel
  @FocusState var focus: NoteViewModel.Focus?
  @State var textEditorHeight : CGFloat = 20
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        TextField("", text: $vm.note.title, axis: .vertical)
          .onSubmit(vm.titleSubmitKeyTapped)
          .font(.system(size: 28, weight: .bold))
          .focused($focus, equals: .title)
          .padding([.leading, .trailing], 18)
          .scrollDisabled(true)
        
        Text(vm.note.formattedDateVerbose)
          .font(.caption)
          .foregroundColor(.secondary)
          .scrollDisabled(true)
          .padding([.leading, .trailing], 18)
        
        TextEditor(text: $vm.note.body)
          .focused($focus, equals: .body)
          .scrollDisabled(true)
          .padding([.leading, .trailing], 14)
          .frame(height: max(40, textEditorHeight))
      }
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
        ToolbarItemGroup(placement: .keyboard) {
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
    .background(GeometryReader {
      Color.clear.preference(
        key: ViewHeightKey.self,
        value: $0.frame(in: .local).size.height
      )
    })
    .onPreferenceChange(ViewHeightKey.self) {
      textEditorHeight = $0
    }
    .bind(self.$vm.focus, to: self.$focus)
  }
}

fileprivate struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

// MARK: - Previews
struct NoteView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      NoteView(vm: .init(note: mockFolderD.notes.first!))
    }
  }
}
