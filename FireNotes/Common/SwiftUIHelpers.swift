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

extension UIColor {
  convenience init(
    light lightModeColor: UIColor,
    dark darkModeColor: UIColor
  ) {
    self.init { traitCollection in
      switch traitCollection.userInterfaceStyle {
      case .light:
        return lightModeColor
      case .dark:
        return darkModeColor
      case .unspecified:
        return lightModeColor
      @unknown default:
        return lightModeColor
      }
    }
  }
}

extension Color {
  init(
    light lightModeColor: Color,
    dark darkModeColor: Color
  ) {
    self.init(uiColor: .init(
      light: .init(lightModeColor),
      dark: .init(darkModeColor)
    ))
  }
}
