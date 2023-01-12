import SwiftUI
import SwiftUINavigation

struct NoteView: View {
  @ObservedObject var vm: NoteViewModel = .init()
  @FocusState var focus: NoteViewModel.Focus?
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        TextField("", text: $vm.note.title, axis: .vertical)
          .font(.system(size: 34, weight: .bold))
          .focused(self.$focus, equals: .title)
          .scrollDisabled(true)
        
        Text(vm.note.formattedDateVerbose)
          .font(.caption)
          .foregroundColor(.secondary)
          .scrollDisabled(true)
        
        TextEditor(text: $vm.note.body)
          .focused(self.$focus, equals: .body)
          .scrollDisabled(true)
        Spacer()
      }
      .padding([.leading, .trailing], 14)
    }
    .navigationTitle("")
    .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
    .toolbar {
      // TODO: This is not the ideal way of hiding a keyboard :(
      ToolbarItemGroup(placement: .keyboard) {
        Spacer()
        Button {
          vm.focus = nil
        } label: {
          Image(systemName: "xmark")
        }
        .buttonStyle(.plain)
      }
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
    ) { _ in
      UserSheet()
    }
    .bind(self.$vm.focus, to: self.$focus)
  }
}

struct NoteView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
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
