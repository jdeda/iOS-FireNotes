import SwiftUI

struct UserSheet: View {
  let user: User = .init(
    email: "gnewell@valvesoftware.com",
    iconURL: URL(string: "https://cdn.vox-cdn.com/thumbor/SJvlgG1SNpb9IlHt4ltQnRSUSXU=/0x0:3328x2151/1520x1013/filters:focal(1416x1363:1948x1895):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/52780275/Gabe_Newell.0.0.jpg")!
  )
  var body: some View {
    VStack {
      HStack {
        AsyncImage(url: user.iconURL) { image in
          image
            .resizable()
            .scaledToFit()
        } placeholder: {
          ProgressView()
        }
        .frame(width: 50, height: 50)
        .background(Color(.systemGray6))
        .clipShape(Circle())
        Text(user.email)
      }
      
      Spacer()
    }
    .padding()
    .navigationTitle("Settings")
  }
}

struct UserSheet_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      UserSheet()
    }
  }
}
