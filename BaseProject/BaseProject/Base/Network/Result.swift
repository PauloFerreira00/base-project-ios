//
//  Result.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 07/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import Foundation

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

enum NetworkResult<T, E: Error> {
    case success(T)
    case failure(E)
    case cache(T, E)
}


