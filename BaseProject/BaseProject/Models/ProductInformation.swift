//
//  ProductInformation.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 08/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import Foundation

struct ProductInformation: BaseCodable {
    let id: Int
    let name: String
    let activePrinciple: String
    let presentation: String
    let pathPicture: String
    let modifiedAt: String
}
