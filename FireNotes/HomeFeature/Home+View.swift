import SwiftUI

struct HomeView: View {
  @ObservedObject var vm: HomeViewModel = .init()
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Folders")
        .font(.system(size: 34, weight: .bold))
        .padding([.leading], 18)
      Searchbar(searchText: $vm.search)
        .padding([.leading, .trailing], 18)
      List {
        ForEach(vm.folders) { folder in
          HStack(alignment: .firstTextBaseline) {
            Image(systemName: "folder")
              .foregroundColor(Color.accentColor)
            Text(folder.name)
            Spacer()
            Text("\(folder.notes.count)")
              .foregroundColor(.secondary)
          }
        }
        .listRowBackground(Color(UIColor.systemGray6))
      }
      .padding([.top], 0)
      .onAppear {
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableView.appearance().contentInset.top = -35
      }
    }
    .toolbar {
      ToolbarItemGroup(placement: .primaryAction) {
        Button {
          vm.tappedUserOptionsButton()
        } label: {
          Image(systemName: "ellipsis.circle")
        }
      }
      ToolbarItemGroup(placement: .bottomBar) {
        Button {
          vm.addFolderButtonTappped()
        } label: {
          Image(systemName: "folder.badge.plus")
        }
        Spacer()
        Text("\(vm.folders.count) folders")
        Spacer()
        Button {
          vm.addNoteButtonTapped()
        } label: {
          Image(systemName: "square.and.pencil")
        }
      }
    }
    .navigationBarTitle("")
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HomeView()
    }
  }
}
