//
//  Flow
//
//  Created by Paulo Ferreira de Jesus - PFR on 06/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//
import Foundation

public struct FlowMultipartFormData {
    
    /// Method to provide the form data.
    public enum FlowFormDataProvider {
        case data(Data)
        case file(URL)
    }
    
    public init(provider: FlowFormDataProvider, name: String, fileName: String, mimeType: String? = nil) {
        self.provider = provider
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
    
    /// The method being used for providing form data.
    public let provider: FlowFormDataProvider
    
    /// The name.
    public let name: String
    
    /// The file name.
    public let fileName: String
    
    /// The MIME type
    public let mimeType: String?
}

extension FlowMultipartFormData: Equatable {
    public static func == (lhs: FlowMultipartFormData, rhs: FlowMultipartFormData) -> Bool {
        return lhs.fileName == rhs.fileName &&
        lhs.mimeType == rhs.mimeType &&
        lhs.name == rhs.name &&
        lhs.provider == rhs.provider
    }
}

extension FlowMultipartFormData.FlowFormDataProvider: Equatable {
    public static func == (lhs: FlowMultipartFormData.FlowFormDataProvider, rhs: FlowMultipartFormData.FlowFormDataProvider) -> Bool {
        switch (lhs, rhs) {
        case (let .data(value1), let .data(value2)):
            return value1 == value2
        case (let .file(value1), let .file(value2)):
            return value1 == value2
        default:
            return false
        }
    }
}
