import SwiftUI

struct Note: Identifiable {
  let id: UUID
  let title: String
  let description: String
}

class NoteViewModel: ObservableObject {
  @Published var title: String = "Untitled"
  @Published var body: String = "Sushi combo in 3...2...1..."
  
  func popUpFormatMenu() {
    
  }
  
  func toggleSelectedTextToList() {
    
  }
  
  func popUpImageSelect() {
    
  }
}

struct NoteView: View {
  @ObservedObject var vm: NoteViewModel = .init()
  
  var body: some View {
    VStack {
      TextField(vm.title, text: $vm.title)
        .font(.system(size: 34, weight: .bold))
      TextEditor(text: $vm.body)
        .toolbar {
          ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button {
              vm.popUpFormatMenu()
            } label: {
              Image(systemName: "textformat")
            }
            Spacer()
            Button {
              vm.toggleSelectedTextToList()
            } label: {
              Image(systemName: "checklist")
            }
            Spacer()
            Button {
              vm.popUpImageSelect()
            } label: {
              Image(systemName: "photo")
            }
            Spacer()
          }
        }
    }
    .navigationTitle("")
    .navigationBarHidden(true)
    .padding()
  }
}

struct NoteView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      NoteView()
    }
  }
}

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
