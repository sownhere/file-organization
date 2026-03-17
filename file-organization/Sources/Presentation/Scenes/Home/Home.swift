import ComposableArchitecture

@Reducer
struct Home {
    @ObservableState
    struct State: Equatable {}

    enum Action {}

    var body: some Reducer<State, Action> {
        EmptyReducer()
    }
}
