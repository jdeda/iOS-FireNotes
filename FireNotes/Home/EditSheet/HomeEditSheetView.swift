import SwiftUI
import SwiftUINavigation
import CasePaths
import XCTestDynamicOverlay

// MARK: - View
struct HomeEditSheet: View {
  @ObservedObject var vm: HomeEditSheetViewModel
  
  var body: some View {
    NavigationStack {
      Form {
        selectButton()
        sortPicker()
      }
      .foregroundColor(Color(light: .black, dark: .white))
      .toolbar {
        toolbar()
      }
    }
  }
}

// MARK: - Helpers
extension HomeEditSheet {
  func selectButton() -> some View {
    Button {
      vm.selectButtonTapped()
    } label: {
      CustomLabel("Select", systemImage: "checkmark.circle")
    }
  }
  
  func sortPicker() -> some View {
    Menu {
      Picker("Sort", selection: $vm.sort) {
        ForEach(HomeViewModel.Sort.allCases, id: \.self) { sort in
          Text(sort.string)
        }
      }
      .onChange(of: vm.sort, perform: vm.sortPickerOptionTapped)
    } label: {
      CustomLabel("Sort", systemImage: "arrow.up.arrow.down")
    }
  }
  
  @ToolbarContentBuilder
  func toolbar() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      HStack {
        Image(systemName: "folder.fill")
          .font(.title3)
          .foregroundColor(.yellow)
        Text("Folders")
      }
    }
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        vm.dismissButtonTapped()
      } label: {
        Image(systemName: "xmark.circle.fill")
      }
      .foregroundColor(Color(UIColor.systemGray2))
    }
  }
}

struct HomeEditSheet_Previews: PreviewProvider {
  static var previews: some View {
    HomeEditSheet(vm: .init())
  }
}
