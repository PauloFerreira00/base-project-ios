//
//  Flow
//
//  Created by Paulo Ferreira de Jesus on 24/01/2019.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import Foundation

struct AnyEncodable: Encodable {
    
    private let encodable: Encodable
    
    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
