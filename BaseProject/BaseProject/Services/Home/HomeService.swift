//
//  HomeService.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 08/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import Foundation

class HomeService: BaseService<HomeApi> {

    static let shared = HomeService()

    func listProducts(completion: CompletionHandler<[ProductInformation]>) {
        fetch(.list, dataType: [ProductInformation].self) { (products, response, error) in
            completion?(products, response, error)
        }
    }
}
