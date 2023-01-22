import SwiftUI
import XCTestDynamicOverlay

// MARK: - ViewModel
final class RenameSelectedSheetViewModel: ObservableObject {
  @Published var values: RenameValues
  @Published var start: Int = 0
  
  var example: String {
    values
      .rename(["Morning Routine", "Office Setup", "Meal Prep", "Gym Log"])
      .joined(separator: "\n")
  }
  
  var renamePositionsSubmitted: (_ values: RenameValues) -> Void = unimplemented(
    "RenameSelectedAlertViewModel.renamePositionsSubmitted"
  )
  
  var submitButtonTapped: (_ values: RenameValues) -> Void = unimplemented(
    "RenameSelectedSheetViewModel.submitButtonTapped"
  )
  
  var cancelButtonTapped: () -> Void = unimplemented(
    "RenameSelectedSheetViewModel.cancelButtonTapped"
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
  var prefixAnnote: Annotate = .none
  var suffixAnnote: Annotate = .none
}

extension RenameValues {
  enum Annotate: CaseIterable {
    case list
    case underscore
    case none
    
    var name: String {
      switch self {
      case .list: return "List"
      case .underscore: return "Underscore"
      case .none: return "None"
      }
    }
    
    var imageName: String {
      switch self {
      case .list: return "list.number"
      case .underscore: return "list.dash"
      case .none: return "list.bullet"
      }
    }
  }
}

extension RenameValues {
  func rename(_ names: [String]) -> [String] {
    var renamed = names
    
    // Set all first.
    if !allValue.isEmpty {
      renamed = renamed.map { _ in allValue }
    }

    // Prefix next.
    switch prefixAnnote {
    case .list:
      renamed = renamed.enumerated().map {
        let num = String($0 + 1)
        return num + ". " + prefixValue + $1
      }
      break
    case .underscore:
      let renamedCountDigits: Int = Array<Character>(String(renamed.count)).count + 1
      renamed = renamed.enumerated().map { (index, name) in
        let indexDigits = Array<Character>(String(index)).count
        let zeroPrefixString = String(Array<Character>.init(repeating: "0", count: renamedCountDigits - indexDigits))
        let prefix = String(zeroPrefixString + String(index))
        return prefix + "_" + prefixValue + name
      }
      break
    case .none:
      if !prefixValue.isEmpty {
        renamed = renamed.map { prefixValue + $0 }
      }
      break
    }
    
    // Suffix last.
    switch suffixAnnote {
    case .list:
      break
    case .underscore:
      let renamedCountDigits: Int = Array<Character>(String(renamed.count)).count + 1
      renamed = renamed.enumerated().map { (index, name) in
        let indexDigits = Array<Character>(String(index)).count
        let zeroPrefixString = String(Array<Character>.init(repeating: "0", count: renamedCountDigits - indexDigits))
        let suffix = String(zeroPrefixString + String(index))
        return name + suffixValue + "_" + suffix
      }
      break
    case .none:
      if !suffixValue.isEmpty {
        renamed = renamed.map { $0 + suffixValue }
      }
    }
    return renamed
  }
}
