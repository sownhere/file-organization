//
//  AppConfig.swift
//  file-organization
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import Foundation

enum AppConfig {
    enum App {
        static let displayName = value(for: "APP_DISPLAY_NAME")
        static let bundleID = value(for: "APP_BUNDLE_ID")
        static let version = value(for: "APP_VERSION")
        static let buildNumber = value(for: "APP_BUILD_NUMBER")
    }
    
    enum API {
        static let domainURL = value(for: "API_DOMAIN_URL")
        static let version = value(for: "API_VERSION")
    }
}

private extension AppConfig {
    static func value(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            fatalError("Missing Info.plist value for \(key)")
        }
        return value.replacingOccurrences(of: "\\", with: "")
    }
}
