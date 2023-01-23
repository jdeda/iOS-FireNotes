import Foundation

final class AppViewModel: ObservableObject {
  @Published var destination: Destination? {
    didSet { bindDestinaton() }
  }
  
  private func bindDestinaton() {
    switch destination {
    case .none:
      break
    case let .home(homeVM):
      break
    }
  }
}

extension AppViewModel {
  enum Destination {
    case home(HomeView)
  }
}
