//
//  CustomButton.swift
//  WeakSelf
//
//  Created by Besher on 2019-06-11.
//  Copyright © 2019 Besher Al Maleh. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    var closure: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(runClosure), for: .touchUpInside)
        setTitle("Test Button", for: .normal)
        setTitleColor(.black, for: .normal)
        setTitleColor(.green, for: .highlighted)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func runClosure() {
        if let closure = closure {
            closure()
        } else {
            print("No closure has been attached to this button")
        }
    }
}
