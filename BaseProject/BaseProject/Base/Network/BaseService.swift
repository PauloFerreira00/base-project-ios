//
//  BaseService.swift
//  PSMyAccount
//
//  Created by Sergio Furlaneto on 21/12/18.
//  Copyright © 2018 UOL inc. All rights reserved.
//

import Foundation

class BaseService<T: FlowTarget>: NSObject, URLSessionDelegate {
    
    private let queue = OperationQueue()
    
    var queueOperationsCount: Int? {
        return self.queue.operationCount
    }
    
    typealias ServiceResult<DataType> = NetworkResult<DataType, Error>
    
    typealias RequestCompletionHandler<DataType: BaseCodable> = (ServiceResult<DataType>) -> Void
    
    typealias DownloadCompletionHandler = (ServiceResult<URL>) -> Void
    
    typealias RequestCompletionHandlerPlain = (ServiceResult<URLResponse>) -> Void
    
    typealias CompletionHandler<BaseCodableValue> = ((_ object: BaseCodableValue?,
        _ response: URLResponse?,
        _ error: Error?) -> Void)?
    
    typealias CompletionHandlerPlain = ((_ response: URLResponse?, _ error: Error?) -> Void)?
    #if DEVELOPMENT || QA
    var provider = FlowProvider<T>(debugMode: .verbose)
    #else
    var provider = FlowProvider<T>()
    #endif
    
    override init() {
        super.init()
        provider.requester.urlSessionDelegate = self
    }
    
    func fetch(_ target: T, completion: CompletionHandlerPlain) {
        provider.request(target, queue) { data, response, error in
            self.checkHeaderPermissions(response: response)
            if let e = self.checkForErrors(data, error: error) {
                completion?(response, e)
                return
            }
            completion?(response, nil)
        }
    }
    
    func fetch<Value: BaseCodable>(_ target: T,
                                 dataType: Value.Type,
                                 completion: CompletionHandler<Value>) {
        
        provider.request(target, queue) { data, response, error in
            self.checkHeaderPermissions(response: response)
            if let e = self.checkForErrors(data, error: error) {
                completion?(nil, response, e)
                return
            }
            do {
                let model = try dataType.init(data: data)
                completion?(model, response, nil)
            } catch {
                debugPrint("\n❓JSONDecoder -> \(error)\n")
                let e = BaseError.parse(error)
                completion?(nil, response, e)
            }
        }
    }

    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.host == "10.133.0.178" {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

// MARK: - Fetchs with ´switch´ completion
extension BaseService {
    
    func fetch(_ target: T, completion: RequestCompletionHandlerPlain?) {
        provider.request(target, queue) { data, response, error in
            self.checkHeaderPermissions(response: response)
            if let e = self.checkForErrors(data, error: error) {
                completion?(.failure(e))
                return
            }
            
            if let response = response {
                completion?(.success(response))
            }
        }
    }
    
    func fetch<Value: BaseCodable>(_ target: T,
                                 dataType: Value.Type,
                                 completion: RequestCompletionHandler<Value>?) {
        
        provider.request(target, queue) { data, _, error in
            if let e = self.checkForErrors(data, error: error) {
                completion?(.failure(e))
                return
            }
            do {
                if let model = try dataType.init(data: data) {
                    completion?(.success(model))
                }
            } catch {
                debugPrint("\n❓JSONDecoder -> \(error)\n")
                let e = BaseError.parse(error)
                completion?(.failure(e))
            }
        }
    }

}

// MARK: - fetch Data
extension BaseService {
    func fetch(_ target: T,
               completion: DownloadCompletionHandler?) {
        provider.download(target, queue) { (location, response, error) in
            if let e = self.checkForErrors(nil, error: error) {
                completion?(.failure(e))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion?(.failure(BaseError.unknown))
                return
            }
            
            if let location = location {
                completion?(.success(location))
            }
        }
    }
}

// MARK: - check header permissions
extension BaseService {
    private func checkHeaderPermissions(response: URLResponse?) {
        let permissionsHeaderKey = "X-Ibanking-Session-Additional-Permissions".lowercased()
        guard let response = response as? HTTPURLResponse else { return }
        if let permissions = response.allHeaderFields.first(where: { key, _ in
            guard let key = key as? String else { return false }
            return key.lowercased() == permissionsHeaderKey
        }) {
            guard let value = permissions.value as? String else { return }
            let result = splitPermissionsResponse(value)
        }
    }
    
    private func splitPermissionsResponse(_ response: String) -> [String] {
        var cleanResponse = response.replacingOccurrences(of: "[", with: "")
        cleanResponse = cleanResponse.replacingOccurrences(of: "]", with: "")
        cleanResponse = cleanResponse.replacingOccurrences(of: " ", with: "")
        cleanResponse = cleanResponse.replacingOccurrences(of: "\"", with: "")
        let splitedString: [String] = cleanResponse.split(separator: ",").map { String($0) }
        return splitedString
    }
}

private extension BaseService {
    
    private func checkForErrors(_ data: Data?, error: FlowError? = nil) -> Error? {
        if let error = error, let networkError = error.underlyingError {
            return BaseError.network(networkError)
        }
        
        do {
            if let responseData = data,
                let apiResponse = try APIErrorResponse(data: responseData),
                let apiError = apiResponse.error {
                let error = BaseError.api(apiError)
                return error
            }
            return nil
        } catch {
            return nil
        }
    }
}
// MARK: - Cancel all Queue operations
extension BaseService {
    func cancelAllOperations() {
        self.queue.cancelAllOperations()
    }
}
