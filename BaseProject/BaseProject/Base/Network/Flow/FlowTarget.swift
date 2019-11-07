//
//  Flow
//
//  Created by Sergio Furlaneto Filho on 24/01/2019.
//  Copyright © 2019 UOL inc. All rights reserved.
//

import Foundation

public enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case update = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
    case patch = "PATCH"
}

public enum ParameterEncoding {
    case queryString
    case httpBody
}

public enum Task {
    /// A request with no additional data.
    /// Used when the request does not require any additional data. For example a simple get request
    case requestPlain
    
    /// A requests body set with data.
    /// Used when the request expects data to be passed in the body of the request
    case requestData(Data)
    
    /// A request body set with `Encodable` type
    /// Used when the request expects a JSON encodable object whereas no.2 expects Data
    case requestJSONEncodable(Encodable)
    
    /// A requests body set with encoded parameters combined with url parameters.
    /// Used for when you want to pass pameters as the request body and also pass urlParameters at the same time.
    case requestCompositeParameters(bodyParameters: [String: Any], urlParameters: [String: Any])
    
    /// A requests body set with encoded parameters.
    /// Used when you want to pass parameters and define your own type of encoding
    case requestParameters(_ parameters: [String: Any], encoding: ParameterEncoding)
    
    /// A "multipart/form-data" upload task.
    /// Used to upload multipart with parameters.
    case uploadMultipart([FlowMultipartFormData])
}

public protocol FlowTarget {
    
    /// The Domain
    var baseURL: URL { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethods { get }
    
    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    /// The task to be used in the request.
    var task: Task { get }
}
