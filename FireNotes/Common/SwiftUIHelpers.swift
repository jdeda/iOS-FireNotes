import SwiftUI

/// Basically a label with maximal horizontal spacing
/// between the title and the icon
struct CustomLabel: View {
  let titleKey: String
  let systemImage: String
  
  init(
    _ titleKey: String,
    systemImage: String
  )
  {
    self.titleKey = titleKey
    self.systemImage = systemImage
  }
  
  var body: some View {
    HStack {
      Text(titleKey)
      Spacer()
      Image(systemName: systemImage)
    }
  }
}
