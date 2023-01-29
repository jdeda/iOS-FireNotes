import SwiftUI

struct Auth {
  var userName: String = ""
  var password: String = ""
  var keepSignedIn: Bool = true
}

final class AuthViewModel: ObservableObject {
  @Published var auth: Auth
  
  init(auth: Auth = .init()) {
    self.auth = auth
  }
  
  func keepSignedInButtonTapped() {
    auth.keepSignedIn.toggle()
  }
  
  func signInButtonTapped() {
    
  }
  
  func signInAnonymouslyButtonTapped() {
    
  }
}
struct AuthView: View {
  @ObservedObject var vm: AuthViewModel
  
  var body: some View {
    HStack {
      Spacer(minLength: 60)
      VStack(alignment: .center) {
        Rectangle().frame(height: 40).opacity(0)
        
        Image(systemName: "note.text")
          .resizable()
          .frame(width: 125, height: 125)
          .foregroundColor(.yellow)
        
        Text("Welcome to FireNotes!")
          .font(.title)
          .fontWeight(.heavy)
        
        TextField("Username", text: $vm.auth.userName)
          .textFieldStyle(PlainTextFieldStyle())
          .padding(.vertical, 10)
          .padding(.horizontal)
          .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary.opacity(0.5), lineWidth: 1))
        
        SecureField("Password", text: $vm.auth.password)
          .textFieldStyle(PlainTextFieldStyle())
          .padding(.vertical, 10)
          .padding(.horizontal)
          .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary.opacity(0.5), lineWidth: 1))
        
        HStack {
          Button {
            vm.keepSignedInButtonTapped()
          } label : {
            Label("Keep Signed-in", systemImage: vm.auth.keepSignedIn ? "checkmark.square" : "square")
          }
          .foregroundColor(.secondary)
          .buttonStyle(.plain)
          Spacer()
        }
        Button {
          vm.signInButtonTapped()
        } label: {
          Text("Sign-in")
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(.yellow)
        .cornerRadius(5)
        Button {
          vm.signInButtonTapped()
        } label: {
          Text("Continue as Guest")
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(.yellow)
        .cornerRadius(5)
        Spacer()
      }
      Spacer(minLength: 60)
    }
  }
}

struct AuthView_Previews: PreviewProvider {
  static var previews: some View {
    AuthView(vm: .init())
      .colorScheme(.dark)
  }
}
