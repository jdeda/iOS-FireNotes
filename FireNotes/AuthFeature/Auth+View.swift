import SwiftUI


struct AuthView: View {
  @ObservedObject var vm: AuthViewModel = .init()
  
  var body: some View {
    Text("Auth")
  }
}

struct AuthView_Previews: PreviewProvider {
  static var previews: some View {
    AuthView()
  }
}
