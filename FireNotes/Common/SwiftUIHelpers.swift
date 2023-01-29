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

// Custom color mode view modifier
fileprivate struct AdaptiveForegroundColorModifier: ViewModifier {
    var lightModeColor: Color
    var darkModeColor: Color
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content.foregroundColor(resolvedColor)
    }
    
    private var resolvedColor: Color {
        switch colorScheme {
        case .light:
            return lightModeColor
        case .dark:
            return darkModeColor
        @unknown default:
            return lightModeColor
        }
    }
}

extension View {
    func foregroundColor(
        light lightModeColor: Color,
        dark darkModeColor: Color
    ) -> some View {
        modifier(AdaptiveForegroundColorModifier(
            lightModeColor: lightModeColor,
            darkModeColor: darkModeColor
        ))
    }
}
