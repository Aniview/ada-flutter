//
//  AdaFlutterConfig.swift
//  ada
//
//  Created by Zhanna Moskaliuk on 28.05.2026.
//

import Flutter
import AdaSdk

struct AdaConfigParser {
    static func parseConfig(from args: Any?) -> AdaSdk.AdaConfig? {
        guard let params = args as? [String: Any],
              let pubId = params["pubId"] as? String,
              let tagId = params["tagId"] as? String else {
            return nil
        }
        if let environment = params["environment"] as? String {
            return .init(environment: environment, pubId: pubId, tagId: tagId)
        } else {
            return .init(pubId: pubId, tagId: tagId)
        }
    }
}
