//
//  UIImageExtensions.swift
//  App
//
//  Created by Paulo Ferreira de Jesus - PFR on 12/07/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import UIKit

extension UIImage {

    func asOriginalMode() -> UIImage {
        return self.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
}
