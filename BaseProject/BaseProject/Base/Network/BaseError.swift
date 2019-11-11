//
//  PSError.swift
//  PSDemo
//
//  Created by Paulo Ferreira de Jesus on 24/01/2019.
//  Copyright © 2019 Sergio Furlaneto Filho. All rights reserved.
//

import Foundation

public enum ErrorCode: Int {
    
    //-- Generic
    case generic                            = 99998 //-- Serviço indisponível
    case withoutInternet                    = -1009
    case connectionLost                     = -1005
    case hostConnection                     = -1004
    case findHost                           = -1003
    case timeout                            = -1001
    case unknown                            = -1
    case parseError                         = -2
    case cancelled                          = -3
}

public enum BaseErrorMessage: String {
    case unknown = "Algo deu errado, tente novamente."
    case serviceError = "Não foi possível realizar a solicitação nesse momento. Efetue uma nova tentativa em alguns minutos"
    case reinstallApp = "Por favor, reinstale o aplicativo"
    case doLoginAgain = "Por favor, realize login novamente"
}

protocol BaseErrorProtocol: LocalizedError {
    var code: Int { get }
    var message: String { get }
}

public enum BaseError: Error {
    case network(Error)
    case api(APIError)
    case parse(Error)
    case unknown
    case generic(Error)
}

extension BaseError: BaseErrorProtocol {
    var message: String {
        return localizedDescription
    }
    
    public var code: Int {
        switch self {
        case .api(let error):
            return error.code
        case .network(let error):
            guard let e = error as? URLError else {
                return -0
            }
            return e.errorCode
        case .parse:
            return ErrorCode.parseError.rawValue
        case .unknown:
            return ErrorCode.unknown.rawValue
        case .generic:
            return ErrorCode.unknown.rawValue
        }
    }
    
    public var localizedDescription: String {
        switch self {
        case .api(let error):
            return error.message
        case .network:
            return BaseErrorMessage.unknown.rawValue
        case .parse:
            return BaseErrorMessage.unknown.rawValue
        case .unknown:
            return BaseErrorMessage.unknown.rawValue
        case .generic:
            return BaseErrorMessage.unknown.rawValue
        }
    }
    
    var errorResponse: ErrorHandler.ErrorResponse {
        return ErrorHandler.ErrorResponse.make(self)
    }
}

struct ErrorHandler: Codable {

    enum Error: Int, Codable {
        case unknown = -1
    }

    struct ErrorResponse: BaseCodable {
        /// Returns the type of the error. `.unknown` if not identified
        var type: Error {
            return errors.first?.errorType ?? .unknown
        }
        /// Returns the message from the first `ErrorMessage`
        var message: String? {
            return errors.first?.message
        }
        var errors: [ErrorMessage]

        static func make(_ error: BaseError) -> ErrorResponse {
            let err = [ErrorHandler.ErrorMessage(code: "\(error.code)",
                message: error.message)]
            return ErrorHandler.ErrorResponse(errors: err)
        }
    }

    /// Error Message
    struct ErrorMessage: BaseCodable {
        var errorType: Error? {
            guard let code = Int(self.code) else {
                return nil
            }

            if let selectedError = Error(rawValue: code) {
                return selectedError
            }
            return Error.unknown
        }

        var code: String
        var message: String

        /**
         Creates a new `ErrorMessage`

         - Parameter code: The error code from the `Error` enum.
         - Parameter message: The message of the error.
         */
        static func make(code: Error, message: String) -> ErrorHandler.ErrorMessage {
            let errorCode = code.rawValue
            return ErrorHandler.ErrorMessage(code: "\(errorCode)", message: message)
        }
    }
}

extension BaseError: Equatable {
    public static func == (lhs: BaseError, rhs: BaseError) -> Bool {
        return lhs.code == rhs.code
    }
    
    static func == (lhs: BaseError, rhs: ErrorCode) -> Bool {
        return lhs.code == rhs.rawValue
    }
}
