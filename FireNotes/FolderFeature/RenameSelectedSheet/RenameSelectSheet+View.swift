import SwiftUI
import XCTestDynamicOverlay

struct RenameSelectedAlert: View {
  @ObservedObject var vm: RenameSelectedAlertViewModel
  var body: some View {
    NavigationStack  {
      Form {
        Section {
          Text(vm.example)
        } header: {
          Text("Example")
        }
        Section {
          prefixRenameField()
          suffixRenameField()
          allRenameField()
        } header: {
          formatHeader()
        }
      }
      .navigationTitle("Rename Selected")
    }
  }
}

extension RenameSelectedAlert {
  func prefixRenameField() -> some View {
    HStack {
      Text("Prefix")
        .frame(width: 75, alignment: .leading)
      Spacer()
           TextField("Prefix", text: $vm.values.prefixValue)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.trailing)
    }
  }
  func suffixRenameField() -> some View {
    HStack {
      Text("Suffix")
        .frame(width: 75, alignment: .leading)
      Spacer()
           TextField("Suffix", text: $vm.values.suffixValue)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.trailing)
    }
  }
  func allRenameField() -> some View {
    HStack {
      Text("All")
        .frame(width: 75, alignment: .leading)
      Spacer()
           TextField("All", text: $vm.values.allValue)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.trailing)
    }
  }
  func formatHeader() -> some View {
    HStack {
      Text("Format")
      Spacer()
      Button {
        vm.resetButtonTapped()
      } label: {
        Image(systemName: "arrow.counterclockwise")
          .foregroundColor(.secondary)
      }
    }
  }
}

struct RenameSelectedAlert_Previews: PreviewProvider {
  static var previews: some View {
    RenameSelectedAlert(vm: .init())
  }
}
