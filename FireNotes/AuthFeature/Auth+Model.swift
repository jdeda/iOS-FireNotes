import Foundation

struct User {
  let email: String
  let iconURL: URL
}

struct SigninState {
  var email: String
  var password: String
}

struct SignupState {
  var email: String
  var password: String
  var passwordReentry: String
}

final class AuthViewModel: ObservableObject {
  @Published var destination: Destination?
  
}

extension AuthViewModel {
  enum Destination {
    case Signin
    case Signup
    case Home
  }
}
