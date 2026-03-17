import ComposableArchitecture
@testable import file_organization
import XCTest

@MainActor
final class RootTests: XCTestCase {
    func testDidFinishLaunchingRoutesToHome() async {
        let store = TestStore(initialState: Root.State()) {
            Root()
        }

        await store.send(.appDelegate(.didFinishLaunching(fromNotificationType: nil))) {
            $0.destination = .home(Home.State())
        }
    }
}
