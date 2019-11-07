//
//  Flow
//
//  Created by Sergio Furlaneto Filho on 24/01/2019.
//  Copyright © 2019 UOL inc. All rights reserved.
//

import Foundation

public typealias CompletionResult = (_ result: Data?, _ response: URLResponse?, _ error: FlowError?) -> Void
public typealias DownloadCompletionResult = (_ location: URL?, _ response: URLResponse?, _ error: FlowError?) -> Void

public protocol FlowProviderProtocol: AnyObject {
    associatedtype Target: FlowTarget
    func request(_ target: Target, _ queue: OperationQueue?, completion: @escaping CompletionResult)
}

open class FlowProvider<Target: FlowTarget>: FlowProviderProtocol {
    var requester: FlowRequester
    
    init(_ requester: FlowRequester = FlowRequester(), debugMode: FlowDebugMode = .silent) {
        self.requester = requester
        self.requester.debugMode = debugMode
    }
    
    public func request(_ target: Target, _ queue: OperationQueue?, completion: @escaping CompletionResult) {
        do {
            let request = try FlowRequestComposer.create(target)
            requester.perform(request, queue) { responseData, response, error in
                completion(responseData, response, error)
            }
        } catch {
            completion(nil, nil, FlowError.invalidRequest(error))
        }
    }
    
    public func download(_ target: Target, _ queue: OperationQueue?, downloadCompletion: @escaping DownloadCompletionResult) {
        do {
            let request = try FlowRequestComposer.create(target)
            requester.perform(request, queue) { location, response, error in
                downloadCompletion(location, response, error)
            }
        } catch {
            downloadCompletion(nil, nil, FlowError.invalidRequest(error))
        }
    }
}
