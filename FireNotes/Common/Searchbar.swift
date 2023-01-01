import SwiftUI

struct Searchbar: View {
  @Binding var searchText: String
     
     var body: some View {
         ZStack {
             Rectangle()
              .foregroundColor(Color(UIColor.systemGray6))
             HStack {
                 Image(systemName: "magnifyingglass")
                 TextField("Search", text: $searchText)
             }
             .foregroundColor(.gray)
             .padding(.leading, 15)
         }
             .frame(height: 35)
             .cornerRadius(10)
     }
}

struct Searchbar_Previews: PreviewProvider {
    @State static var search: String = ""
  
    static var previews: some View {
      Searchbar(searchText: $search)
    }
}
