import SwiftUI
import XCTestDynamicOverlay

// MARK: - ViewModel
final class RenameSelectedAlertViewModel: ObservableObject {
  @Published var values: RenameValues
  
  var example: String {
    ["Morning Routine", "Office Setup", "Meal Prep", "Gym Log"]
      .map(values.rename)
      .joined(separator: "\n")
  }
  
  var renamePositionsSubmitted: (_ values: RenameValues) -> Void = unimplemented(
    "RenameSelectedAlertViewModel.renamePositionsSubmitted"
  )
  
  init(values: RenameValues = .init()) {
    self.values = values
  }
  
  func resetButtonTapped() {
    values = .init()
  }
}


// MARK: - Model
struct RenameValues {
  var prefixValue: String = ""
  var suffixValue: String = ""
  var allValue: String = ""
}

extension RenameValues {
  func rename(_ name: String) -> String {
    var renamed = name
    if !allValue.isEmpty {
      renamed = self.allValue
    }
    if !prefixValue.isEmpty {
      renamed = self.prefixValue + renamed
    }
    if !suffixValue.isEmpty {
      renamed = renamed + self.suffixValue
    }
    return renamed
  }
}
