import ComposableArchitecture

@Reducer
struct Root {
    @Reducer
    enum Destination {
        case home(Home)
    }

    @ObservableState
    struct State: Equatable {
        var appDelegate = AppDelegate.State()

        @Presents var destination: Destination.State?
    }

    enum Action {
        case appDelegate(AppDelegate.Action)
        case destination(PresentationAction<Destination.Action>)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.appDelegate, action: \.appDelegate) {
            AppDelegate()
        }
        Reduce { state, action in
            switch action {
            case .appDelegate(.didFinishLaunching):
                state.destination = .home(Home.State())
                return .none
            case .appDelegate:
                return .none
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension Root.Destination.State: Equatable {}
