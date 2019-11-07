//
//  Flow
//
//  Created by Sergio Furlaneto Filho on 24/01/2019.
//  Copyright © 2019 UOL inc. All rights reserved.
//

import UIKit

enum FlowRequestComposer {
    static func create<Target: FlowTarget>(_ target: Target) throws -> URLRequest {
        var request = URLRequest(url: URL(target: target))
        request.allHTTPHeaderFields = target.headers
        request.httpMethod = target.method.rawValue
        
        switch target.task {
        case .requestPlain:
            return request
        case .requestData(let data):
            request.httpBody = data
        case .requestJSONEncodable(let body):
            return try request.encoded(encodable: body)
        case .requestCompositeParameters(let bodyParameters, let urlParameters):
            return try request.encoded(bodyParameters: bodyParameters, urlParameters: urlParameters)
        case .requestParameters(let parameters, let encode):
            return try request.encoded(parameters: parameters, paramEncode: encode)
        case .uploadMultipart(let files):
            return try request.multipart(files)
        }
        return request
    }
}
