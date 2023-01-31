# 🔥 FireNotes

### About
`FireNotes` is a simple note taking app heavily based on Apple's `Notes` app. This app shares many features with Apple's app, certainly not all, and has some of its own unique features for a better user experience.


###

### 🔨 MVVM
This app is built using the MVVM architecture. Every feature has a view and view model. The view reaches into the view model for state such that it can render itself, contains zero mutation logic, and only mutates the view model by calling methods on it. A simplified version of the folder feature would look like this:
```swift
struct Note: Identifiable {
  let id: UUID
  var title: String
}

final class FolderViewModel: ObservableObject {
    @Published var notes: [Note]
    
    init(notes: [Note] = []) {
      self.notes = notes
    }
  
    func rowTapped(_ note: Note) {
      // ... 
    }
}
struct FolderView: View {
  @ObservedObject var vm: FolderViewModel
    var body: some View {
      List {
        ForEach(vm.notes) { note in
          VStack {
            Text(note.title)
              .onTapGesture {
                vm.rowTapped(note)
              }
          }
        }
      }
    }
}
```
### 🔗 Deep Linking 
One would like the ability to navigate into deeper and deeper nested views, simply by writing the state to get there. Deep linking is simply composing navigation.

To achieve navigation combined with MVVM, feature that use navigation use an enum, called destination. Then, the view logic representing a `navigationDestination`, or when to popup a sheet, or display an alert, is as simple as binding to the view model's destination, checking for a matching case, then rendering the view you'd like. Even better, if that view needs its own view model, we could add that model as an associated value to the destination enum. Then, when we set our destination, link up any callbacks or sinks to the child view model. Our simplified Folder feature would could look as follows:
```swift
// MARK: -  ViewModel
final class FolderViewModel: ObservableObject {
  @Published var notes: [Note]
  @Published var destination: Destination? {
    didSet { bindDestination() }
  }
  
  init(
    notes: [Note] = [],
    destination: Destination? = nil
  ) {
    self.notes = notes
    self.destination = destination
    self.bindDestination()
  }
  
  private func bindDestination() {
    switch destination {
    case .none:
      break
    case let .note(noteViewModel):
      noteViewModel.onDelete = { [weak self] in
        guard let self else { return } 
        // Delete logic ...
      }
      
      noteViewModel.note.sink { [weak self] newNote in 
        guard let self else { return } 
        // Update logic...
      }
      break
    case .editSheet:
      break
    case .alert:
      break
    }
  }
  
  func rowTapped(_ note: Note) {
    destination = .note(note)
  }
  
  func popupButtonTapped() {
    destination = .editSheet
  }
  
  func squareButtonTapped() {
    destination = .alert(.init(
      title: { TextState("Alert!")},
      actions: {
        ButtonState(label: { TextState("No") })
        ButtonState(role: nil, action: .confirmButtonTapped, label: { TextState("Yes") })
      },
      message: { TextState("Create a new note?") }
    ))
  }
  
  func alertButtonTapped(_ alertAction: AlertAction?) {
    switch alertAction {
    case .none:
      break
    case .confirmButtonTapped:
      withAnimation {
        notes.append(.init(id: .init(), title: "New Untitled Note"))
      }
    }
  }
}

// MARK: -  Destination
extension FolderViewModel {
  enum Destination {
    case note(NoteViewModel)
    case editSheet
    case alert(AlertState<AlertAction>)
  }
}

// MARK: -  AlertAction
extension FolderViewModel {
  enum AlertAction {
    case confirmButtonTapped
  }
}

// MARK: -  View
struct FolderView: View {
  @ObservedObject var vm: FolderViewModel
  var body: some View {
    NavigationStack {
      List {
        ForEach(vm.notes) { note in
          VStack {
            Text(note.title)
              .onTapGesture {
                vm.rowTapped(note)
              }
          }
        }
      }
      .navigationBarTitle("Folders")
      .toolbar {
        ToolbarItemGroup(placement: .primaryAction) {
          Button {
            vm.popupButtonTapped()
          } label: {
            Image(systemName: "ellipsis.circle")
          }
        }
        
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Button {
            vm.squareButtonTapped()
          } label: {
            Image(systemName: "square.and.pencil")
          }
        }
      }
      .navigationDestination(
        unwrapping: $vm.destination,
        case: /FolderViewModel.Destination.note
      ) { $noteViewModel in
        NoteView(viewModel: noteViewModel)
      }
      .sheet(
        unwrapping: $vm.destination,
        case: /FolderViewModel.Destination.editSheet
      ) { _ in
        Text("We're in an edit sheet!")
      }
      .alert(
        unwrapping: $vm.destination,
        case: /FolderViewModel.Destination.alert
      ) { alertAction in
        vm.alertButtonTapped(alertAction)
      }
    }
  }
}
```

By modeling navigation this way, navigation logic in our view is very consistent and similar, our state can be modeled much safer than the combination of multiple pairs of boolean and optional values as seen with SwiftUI's vanilla navigation APIs. But most importantly, if designed properly, we can virtually model all navigation in a feature with a single source of truth.

This pattern for navigation is highly inspired by PointFree's SwiftUI Navigation and Modern SwiftUI video series. To achieve this pattern, PointFree's SwiftUINavigation library is used, which implements the navigation APIs above and much more. 
