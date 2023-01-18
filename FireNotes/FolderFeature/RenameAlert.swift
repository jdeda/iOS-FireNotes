import SwiftUI
import XCTestDynamicOverlay

struct RenameAlert: View {
  @State var name: String
  
  var submitName: (_ name: String) -> Void = unimplemented("RenameAlert.submitName")
  
  var body: some View {
      TextField("", text: $name)
        .accentColor(.yellow)
      Button {
      } label: {
        Text("Cancel")
              .foregroundColor(.yellow)
              .fontWeight(.bold)
      }
      .accentColor(.yellow)

      Button {
        submitName(name)
      } label: {
        Text("Save")
              .foregroundColor(.yellow)
              .fontWeight(.medium)
      }
      .accentColor(.yellow)
  }
}
