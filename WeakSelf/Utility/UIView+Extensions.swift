//
//  UIView+Extensions.swift
//  WeakSelf
//
//  Created by Besher on 2019-06-10.
//  Copyright © 2019 Besher Al Maleh. All rights reserved.
//

import UIKit

extension UIView {
    func imageRepresentation() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}

