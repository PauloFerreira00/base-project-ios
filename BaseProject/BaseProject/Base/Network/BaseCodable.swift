//
//  BaseCodable.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 07/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import Foundation

public protocol BaseCodable: Codable {
    init?(_ dictionary: [String: Any])
    init?(_ data: Data)
    func dictionary() -> [String: Any]?
    func jsonString() -> String
}

extension BaseCodable {
    init?(_ dictionary: [String: Any]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let object = try JSONDecoder().decode(Self.self, from: data)
            self = object
        } catch {
            return nil
        }
    }

    init?(_ data: Data) {
        do {
            let decoder = JSONDecoder()
            let object = try decoder.decode(Self.self, from: data)
            self = object
        } catch let error {
            #if DEVELOPMENT || QA
            print("\n❓JSONDecoder -> \(Self.self): \(error)\n")
            #endif
            return nil
        }
    }

    init?(data: Data?) throws {
        guard let d = data else {
            return nil
        }

        let decoder = JSONDecoder()
        let obj = try decoder.decode(Self.self, from: d)
        self = obj
    }

    func dictionary() -> [String: Any]? {
        if let jsonData = try? JSONEncoder().encode(self),
            let dict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            return dict
        }
        return nil
    }

    func jsonString() -> String {
        if  let data = try? JSONEncoder().encode(self),
            let str = String(data: data, encoding: .utf8) {
            return str
        }
        return "{}"
    }

    static func fromJsonString(_ string: String) -> Self? {
        let decoder = JSONDecoder()
        guard let data = string.data(using: .utf8), let result = try? decoder.decode(Self.self, from: data) else { return nil }
        return result
    }

    func toType<T: Codable>(_ model: T.Type) throws -> T {
        let data = try JSONEncoder().encode(self)
        return try JSONDecoder().decode(model, from: data)
    }

}

