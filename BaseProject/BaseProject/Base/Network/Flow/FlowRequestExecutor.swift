//
//  Flow
//
//  Created by Sergio Furlaneto Filho on 24/01/2019.
//  Copyright © 2019 UOL inc. All rights reserved.
//

import Foundation
import SystemConfiguration

enum FlowDebugMode {
    case silent
    case verbose
}

protocol FlowRequesterExecutorProtocol {
    var debugMode: FlowDebugMode { get set }
    func execute(request: URLRequest,
                 in session: URLSession,
                 completion: @escaping (Data?, URLResponse?, FlowError?) -> Void)
    func execute(request: URLRequest,
                 in session: URLSession,
                 downloadCompletion: @escaping (URL?, URLResponse?, FlowError?) -> Void)
}

class FlowRequesterExecutor: FlowRequesterExecutorProtocol {
    var debugMode: FlowDebugMode = .silent
    
    func execute(request: URLRequest,
                 in session: URLSession,
                 completion: @escaping (Data?, URLResponse?, FlowError?) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if self.debugMode == .verbose {
                self.debugResponse(request, data, response, error)
            }
            if let e = error {
                completion(data, response, FlowError.network(e))
                return
            }
            completion(data, response, nil)
        }.resume()
        session.finishTasksAndInvalidate()
    }
    
    func execute(request: URLRequest,
                 in session: URLSession,
                 downloadCompletion: @escaping (URL?, URLResponse?, FlowError?) -> Void) {
        session.downloadTask(with: request) { location, response, error in
            if self.debugMode == .verbose {
                self.debugResponse(request, nil, response, error)
            }
            if let e = error {
                downloadCompletion(location, response, FlowError.network(e))
                return
            }
            downloadCompletion(location, response, nil)
        }.resume()
        session.finishTasksAndInvalidate()
    }
}

private extension FlowRequesterExecutor {
    private func debugResponse(_ request: URLRequest,
                               _ responseData: Data?,
                               _ response: URLResponse?,
                               _ error: Error?) {
        let uuid = UUID().uuidString
        print("\n↗️ ======= REQUEST =======")
        print("↗️ REQUEST #: \(uuid)")
        print("↗️ URL: \(request.url?.absoluteString ?? "")")
        print("↗️ HTTP METHOD: \(request.httpMethod ?? "GET")")
        
        if let requestHeaders = request.allHTTPHeaderFields,
            let requestHeadersData = try? JSONSerialization.data(withJSONObject: requestHeaders, options: .prettyPrinted),
            let requestHeadersString = String(data: requestHeadersData, encoding: .utf8) {
            print("↗️ HEADERS:\n\(requestHeadersString)")
        }
        
        if let requestBodyData = request.httpBody,
            let requestBody = String(data: requestBodyData, encoding: .utf8) {
            print("↗️ BODY: \n\(requestBody)")
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("\n↙️ ======= RESPONSE =======")
            switch httpResponse.statusCode {
            case 200...202:
                print("↙️ CODE: \(httpResponse.statusCode) - ✅")
            case 400...505:
                print("↙️ CODE: \(httpResponse.statusCode) - 🆘")
            default:
                print("↙️ CODE: \(httpResponse.statusCode) - ✴️")
            }
            
            if let responseHeadersData = try? JSONSerialization.data(withJSONObject: httpResponse.allHeaderFields, options: .prettyPrinted),
                let responseHeadersString = String(data: responseHeadersData, encoding: .utf8) {
                print("↙️ HEADERS:\n\(responseHeadersString)")
            }
            
            if let responseBodyData = responseData,
                let responseBody =  String(data: responseBodyData, encoding: .utf8),
                !responseBody.isEmpty {
                
                print("↙️ BODY:\n\(responseBody)\n")
            }
        }
        
        if let urlError = error as? URLError {
            print("\n❌ ======= ERROR =======")
            print("❌ CODE: \(urlError.errorCode)")
            print("❌ DESCRIPTION: \(urlError.localizedDescription)\n")
        }
        
        print("======== END OF: \(uuid) ========\n\n")
    }
}
