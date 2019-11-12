//
//  ViewState.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 11/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import Foundation

enum ViewState {
    case loading
    case loaded
    case errored(error: Error)
    case empty
}
