import Foundation
import XCTestDynamicOverlay

final class HomeEditSheetViewModel: ObservableObject {
  @Published var sort: HomeViewModel.Sort
  
  init(sort: HomeViewModel.Sort = .alphabetical) {
    self.sort = sort
  }
  
  var selectButtonTapped: () -> Void = unimplemented(
    "HomeEditSheetViewModel.selectButtonTapped"
  )
  
  var sortPickerOptionTapped: (_ sort: HomeViewModel.Sort) -> Void = unimplemented(
    "HomeEditSheetViewModel.sortPickerOptionTapped"
  )
  
  var dismissButtonTapped: () -> Void = unimplemented(
    "HomeEditSheetViewModel.dismissButtonTapped"
  )
}

