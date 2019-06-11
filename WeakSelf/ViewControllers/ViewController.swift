//
//  ViewController.swift
//  WeakSelf
//
//  Created by Besher on 2019-06-02.
//  Copyright © 2019 Besher Al Maleh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var openButton: CustomButton!
    weak var presentedController: PresentedController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func open(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "vc2") as? PresentedController {
            let navigation = UINavigationController.init(rootViewController: vc)
            let backButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closePresentedController))
            vc.navigationItem.leftBarButtonItem = backButton
            present(navigation, animated: true)
            self.presentedController = vc
        }
    }
    
    @objc func closePresentedController() {
        presentedController?.back() {
            // check if controller has deallocated
            DispatchQueue.main.async { [weak self] in
                let deallocated = self?.presentedController == nil
                GlobalAlert.present(deallocated ? .noLeaks : .leaked)
            }
        }
    }
}


