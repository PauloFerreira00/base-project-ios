//
//  HomeApi.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 08/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import Foundation

enum HomeApi {
    case list
    case detail
}

extension HomeApi: FlowTarget {
    var baseURL: URL {
        return URL(string: "http://mock.iteris.local:8888/")!
    }

    var path: String {
        switch self {
        case .list:
            return "list"
        case .detail:
            return ""
        }
    }

    var method: HTTPMethods {
        switch self {
        case .list, .detail:
            return .get
        }
    }

    var headers: [String : String]? {
        return nil
    }

    var task: Task {
        switch self {
        case .list, .detail:
            return .requestPlain
        }
    }

}
