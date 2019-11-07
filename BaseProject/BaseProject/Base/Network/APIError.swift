//
//  APIError.swift
//  PSMyAccount
//
//  Created by Paulo Ferreira de Jesus - PFR on 06/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

struct APIErrorResponse: BaseCodable {
    var errors: [APIError]
    
    var error: APIError? {
        return errors.first
    }
}

public struct APIError: Codable {
    var code = 0
    var message = ""
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stringCode = try container.decode(String.self, forKey: .code)
        code = Int(stringCode) ?? -1
        message = try container.decode(String.self, forKey: .message)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(message, forKey: .message)
    }
}

extension APIError: Equatable {
    static func == (lhs: APIError, rhs: ErrorCode) -> Bool {
        return lhs.code == rhs.rawValue
    }
}
