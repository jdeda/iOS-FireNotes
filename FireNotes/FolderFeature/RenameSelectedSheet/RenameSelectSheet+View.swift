import SwiftUI
import XCTestDynamicOverlay

struct RenameSelectedSheet: View {
  @ObservedObject var vm: RenameSelectedSheetViewModel
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
      .toolbar {
        toolbar()
      }
      .navigationTitle("Rename Selected")
    }
  }
}

extension RenameSelectedSheet {
  func prefixRenameField() -> some View {
    HStack {
      Text("Prefix")
        .frame(width: 75, alignment: .leading)
      Spacer()
      TextField("Prefix", text: $vm.values.prefixValue)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.trailing)
      Menu {
      Picker(selection: $vm.values.prefixAnnote, label: EmptyView()) {
          ForEach(RenameValues.Annotate.allCases, id: \.self) { annote in
            Label(annote.name, systemImage: annote.imageName)
              .tag(annote.self)
          }
        }
      } label: {
        Image(systemName: vm.values.prefixAnnote.imageName)
          .foregroundColor(.secondary)
      }
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
      Menu {
      Picker(selection: $vm.values.suffixAnnote, label: EmptyView()) {
          ForEach(RenameValues.Annotate.allCases, id: \.self) { annote in
            Label(annote.name, systemImage: annote.imageName)
              .tag(annote.self)
          }
        }
      } label: {
        Image(systemName: vm.values.suffixAnnote.imageName)
          .foregroundColor(.secondary)
      }
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
  @ToolbarContentBuilder
  func toolbar() -> some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        vm.submitButtonTapped(vm.values)
      } label: {
        Text("Submit")
//        Image(systemName: "xmark.circle.fill")
      }
    }
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        vm.cancelButtonTapped()
      } label: {
        Text("Cancel")
//        Image(systemName: "xmark.circle.fill")
      }
      .foregroundColor(Color(UIColor.systemGray2))
    }
  }
}

struct RenameSelectedSheet_Previews: PreviewProvider {
  static var previews: some View {
    RenameSelectedSheet(vm: .init())
  }
}
