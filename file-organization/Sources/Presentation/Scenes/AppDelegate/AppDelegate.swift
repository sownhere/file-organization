//
//  AppDelegate.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

@preconcurrency import ComposableArchitecture
import Foundation

@Reducer
struct AppDelegate {
    @ObservableState
    struct State: Equatable {}
    
    enum Action {
        case didFinishLaunching(fromNotificationType: String?)
        case didBecomeActive
        case didEnterBackground
        case updateReminder
        case openURL(URL)
        case didRegisterForRemoteNotifications(Result<Data, Error>)
    }
    
    var body: some Reducer<State, Action> {
        EmptyReducer()
    }
}
