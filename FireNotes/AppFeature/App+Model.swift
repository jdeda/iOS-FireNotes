import Foundation

final class AppViewModel: ObservableObject {
  @Published var destination: Destination?

}

extension AppViewModel {
  enum Destination {
    case Auth
    case Home
  }
}
