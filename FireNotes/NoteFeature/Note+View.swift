import SwiftUI
import SwiftUINavigation

struct NoteView: View {
  @ObservedObject var vm: NoteViewModel = .init()
  @FocusState var focus: NoteViewModel.Focus?
  
  var body: some View {
    VStack {
      Text(vm.note.formattedDateVerbose)
        .font(.caption)
        .foregroundColor(.secondary)
      
      TextField(vm.note.title, text: $vm.note.title)
        .font(.system(size: 34, weight: .bold))
        .focused(self.$focus, equals: .title)
      
      TextEditor(text: $vm.note.body)
        .focused(self.$focus, equals: .body)
    }
    .padding([.leading, .trailing], 18)
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
        Button {
          vm.addNoteButtonTappped()
        } label: {
          Image(systemName: "square.and.pencil")
        }
      }
    }
    .sheet(
      unwrapping: $vm.destination,
      case: /NoteViewModel.Destination.UserOptionsSheet
    ) { $bindingCase in
      UserSheet()
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        let shouldEditTitle = vm.note.title.trimmingCharacters(in: .whitespaces) == ""
        self.focus = shouldEditTitle ? .title : .body
        print(shouldEditTitle)
      }
    }
    //    .bind(self.$vm.focus, to: self.$focus)
    .navigationBarTitle("")
  }
}

struct NoteView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      NoteView()
    }
  }
}

// MARK :- Markdown Formatting!
extension String {
  var attributedString: AttributedString {
    do {
      let attributedString = try AttributedString(
        markdown: self,
        options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
      )
      return attributedString
    } catch {
      return AttributedString(self)
    }
  }
}
