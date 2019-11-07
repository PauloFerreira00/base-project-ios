//
//  URLRequest+Multipart.swift
//  PSMyAccount
//
//  Created by Paulo Ferreira de Jesus - PFR on 06/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import Foundation

internal extension URLRequest {
    
    mutating func multipart(_ files: [FlowMultipartFormData]) throws -> URLRequest {
        let boundary = NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        do {
            let httpBodyData = try createUploadBody(files, boundary: boundary)
            httpBody = httpBodyData
        } catch {
            throw FlowError.invalidBody(error)
        }
        
        return self
    }
    
    func createUploadBody(_ files: [FlowMultipartFormData], boundary: String) throws -> Data? {
        let body = NSMutableData()
        
        for file in files {
            var content: Data
            
            switch file.provider {
            case .data(let data):
                content = data
            case .file(let url):
                content = try Data(contentsOf: url)
            }
            
            let mimeType = file.mimeType ?? "application/octet-stream"
            
            body.append("--" + boundary)
            body.append("\r\n")
            body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.fileName)\"\r\n")
            body.append("Content-Type: \(mimeType)\r\n\r\n")
            body.append(content)
            body.append("\r\n")
        }
        body.append("--\(boundary)--\r\n")
        return body as Data
    }
}

private extension NSMutableData {
    func append(_ string: String) {
        guard let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return }
        append(data)
    }
}
