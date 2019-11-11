//
//  Flow
//
//  Created by Paulo Ferreira de Jesus on 24/01/2019.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import Foundation

enum TimeoutRequestType: TimeInterval {
    case normal = 30.0
    case long = 60.0
}

open class FlowRequester: NSObject {
    var executor: FlowRequesterExecutorProtocol
    var timeoutRequestType: TimeoutRequestType = .normal
    var debugMode: FlowDebugMode = .silent {
        didSet {
            self.executor.debugMode = debugMode
        }
    }
    
    var sessionConfiguration: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        config.urlCredentialStorage = nil
        config.httpCookieAcceptPolicy = .always
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.timeoutIntervalForRequest = timeoutRequestType.rawValue
        
        if #available(iOS 11.0, *) {
            config.waitsForConnectivity = false
        }
        
        return config
    }

    weak var urlSessionDelegate: URLSessionDelegate?
    
    override init() {
        self.executor = FlowRequesterExecutor()
        super.init()
    }

    convenience init(_ timeout: TimeoutRequestType = .normal) {
        self.init()
        timeoutRequestType = timeout
    }
    
    func perform(_ request: URLRequest,
                 _ queue: OperationQueue?,
                 completion: @escaping (_ responseData: Data?, _ response: URLResponse?, _ error: FlowError?) -> Void) {
        let urlSession = URLSession(configuration: sessionConfiguration, delegate: urlSessionDelegate, delegateQueue: queue)
        executor.execute(request: request, in: urlSession) { responseData, response, error in
            completion(responseData, response, error)
        }
        urlSession.finishTasksAndInvalidate()
    }
    
    func perform(_ request: URLRequest,
                 _ queue: OperationQueue?,
                 downloadCompletion: @escaping (_ location: URL?, _ response: URLResponse?, _ error: FlowError?) -> Void) {
        let urlSession = URLSession(configuration: sessionConfiguration, delegate: urlSessionDelegate, delegateQueue: queue)
        executor.execute(request: request, in: urlSession) { location, response, error in
            downloadCompletion(location, response, error)
        }
        urlSession.finishTasksAndInvalidate()
    }
}
