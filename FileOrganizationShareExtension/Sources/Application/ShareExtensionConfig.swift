//
//  ShareExtensionConfig.swift
//  FileOrganizationShareExtension
//
//  Created by sown on 4/16/26.
//  Copyright © 2026 Santaris Technologies. All rights reserved.
//

import Foundation

enum ShareExtensionConfig {
    enum App {
        static let displayName = value(for: "APP_SHARE_EXTENSION_DISPLAY_NAME")
    }
    
    enum API {
        static let domainURL = value(for: "API_DOMAIN_URL")
        static let version = value(for: "API_VERSION")
    }
}

private extension ShareExtensionConfig {
    static func value(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            fatalError("Missing Info.plist value for \(key)")
        }
        return value.replacingOccurrences(of: "\\", with: "")
    }
}
