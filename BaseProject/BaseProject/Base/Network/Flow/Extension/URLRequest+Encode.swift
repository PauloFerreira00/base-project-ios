//
//  Flow
//
//  Created by Sergio Furlaneto Filho on 24/01/2019.
//  Copyright © 2019 UOL inc. All rights reserved.
//

import Foundation

internal extension URLRequest {
    mutating func encoded(encodable: Encodable, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        do {
            let encodable = AnyEncodable(encodable)
            httpBody = try encoder.encode(encodable)
            let contentTypeHeaderName = "Content-Type"
            if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
            }
            return self
        } catch {
            throw FlowError.encode(error)
        }
    }
    
    mutating func encoded(parameters: [String: Any], paramEncode: ParameterEncoding) throws -> URLRequest {
        do {
            let comps = getUrlComponents(queryParameters: parameters)
            
            if paramEncode == .queryString {
                self.url = comps?.url
            } else {
                setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                httpBody = comps?.percentEncodedQuery?.data(using: .utf8)
            }
            
            try validateUrl()
            
            return self
        } catch {
            throw FlowError.encode(error)
        }
    }
    
    mutating func encoded(bodyParameters: [String: Any], urlParameters: [String: Any]) throws -> URLRequest {
        do {
            if self.httpMethod == HTTPMethods.get.rawValue {
                fatalError("Only used with others http methods.")
            }
            
            let contentTypeHeaderName = "Content-Type"
            if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
            }
            
            updateUrl(withQueryParameters: urlParameters)
            try validateUrl()
            
            httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)

            return self
        } catch {
            throw FlowError.encode(error)
        }
    }
    
    /// Throws an error if the URL somehow doesn't exist in this URLRequester
    private func validateUrl() throws {
        guard self.url != nil else {
            throw FlowError.invalidURL
        }
    }
    /// Update the URLRequest's url appending querystring parameters from dictionary
    private mutating func updateUrl(withQueryParameters parameters: [String: Any]) {
        url = buildUrl(queryParameters: parameters)
    }
    
    /// Build the final url using query parameters
    private func buildUrl(queryParameters: [String: Any]) -> URL? {
        return getUrlComponents(queryParameters: queryParameters)?.url ?? url
    }
    
    /// Get the URLComponent for the current URLRequest with given url parameters (querystring)
    private func getUrlComponents(queryParameters: [String: Any]) -> URLComponents? {
        guard let urlUnwrapped = self.url else { return nil }
        var comps = URLComponents(string: urlUnwrapped.absoluteString)
        guard !queryParameters.isEmpty else { return comps }
        var resultToQueryItems: [URLQueryItem] = []
        resultToQueryItems += queryParameters.flatMap { queryItems($0.key, $0.value) }
        comps?.queryItems = resultToQueryItems
        return comps
    }
    
    /// Encode complex key/value objects in pairs
    private func queryItems(_ key: String, _ value: Any) -> [URLQueryItem] {
        var result: [URLQueryItem] = []
        if let array = value as? [AnyObject] {
            result += array.flatMap { queryItems(key, $0) }
        } else {
            result.append(URLQueryItem(name: key, value: "\(value)"))
        }
        return result
    }
}
