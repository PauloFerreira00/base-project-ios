//
//  Flow
//
//  Created by Sergio Furlaneto Filho on 24/01/2019.
//  Copyright © 2019 UOL inc. All rights reserved.
//

import Foundation

protocol FlowErrorProtocol: LocalizedError {
    var code: Int { get }
    var underlyingError: Error? { get }
}

public enum FlowError: Error {
    case invalidURL
    case encode(Error)
    case network(Error)
    case invalidRequest(Error)
    case invalidBody(Error)
    case invalidParameters
}

extension FlowError: FlowErrorProtocol {
    public var code: Int {
        switch self {
        case .invalidURL:
            return -7000
        case .encode:
            return -7001
        case .network(let error):
            guard let e = error as? URLError else {
                return -0
            }
            return e.errorCode
        case .invalidRequest:
            return -7002
        case .invalidBody:
            return -7003
        case .invalidParameters:
            return -7004
        }
    }
    
    public var underlyingError: Error? {
        switch self {
        case .invalidURL, .invalidParameters:
            return nil
        case .encode(let error):
            return error
        case .network(let error):
            return error
        case .invalidRequest(let error):
            return error
        case .invalidBody(let error):
            return error
        }
    }
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .encode(let error):
            return error.localizedDescription
        case .network(let error):
            return error.localizedDescription
        case .invalidRequest(let error):
            return error.localizedDescription
        case .invalidBody(let error):
            return error.localizedDescription
        case .invalidParameters:
            return "Parâmetros inválidos"
        }
    }
}
