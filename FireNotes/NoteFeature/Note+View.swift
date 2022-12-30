import SwiftUI

struct NoteView: View {
  @ObservedObject var vm: NoteViewModel = .init()
  
  var body: some View {
    VStack {
      Text(vm.note.formattedDateVerbose)
        .font(.caption)
        .foregroundColor(.secondary)
      TextField(vm.note.title, text: $vm.note.title)
        .font(.system(size: 34, weight: .bold))
      TextEditor(text: $vm.note.body)
    }
    .padding([.leading, .trailing], 18)
    .toolbar {
      ToolbarItemGroup(placement: .primaryAction) {
        Button {
          vm.tappedOptionsButton()
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
