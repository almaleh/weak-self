//
//  GlobalAlert.swift
//  WeakSelf
//
//  Created by Besher on 2019-06-10.
//  Copyright © 2019 Besher Al Maleh. All rights reserved.
//

import UIKit

enum GlobalAlert {
    
    static func present(_ state: State) {
        
        guard let root = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let alert = UIAlertController(title: state.contents.title, message: state.contents.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        let presentedController = getPresentedController(from: root)
        presentedController.present(alert, animated: true)
    }
    
    private static func getPresentedController(from root: UIViewController) -> UIViewController {
        var current = root
        while current.presentedViewController != nil {
            current = current.presentedViewController!
        }
        return current
    }
    
    enum State {
        case noLeaks, leaked
        var contents: (title: String, message: String) {
            switch self {
            case .noLeaks:
                return ("No Leaks Detected 🎉",
                        "Congratulations! Your closures didn't leak!")
            case .leaked:
                return ("Controller memory was not freed 💦",
                        "One of your closures may have caused a memory leaked or a delayed deallocation!")
            }
        }
    }
}
