//
//  ViewController2.swift
//  WeakSelf
//
//  Created by Besher on 2019-06-02.
//  Copyright © 2019 Besher Al Maleh. All rights reserved.
//

import UIKit

class PresentedController: UIViewController {
    @IBOutlet weak var printingButton: CustomButton!
    
    deinit {
        // if you don't pass here after dismissal, then you have a leak problem
        print("Dismissing Presented Controller")
    }
    
    func back(completion: (() -> Void)?) {
        self.dismiss(animated: true, completion: completion)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        generateImages()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeakyButton()
    }
    
    func generateImages() {
        ImageGenerator.generateAsyncImages(count: 10) { [weak self] images in
            guard let self = self else { return }
            for image in images {
                let imageView = UIImageView(image: image)
                self.view.insertSubview(imageView, belowSubview: self.printingButton)
            }
        }
    }
    
    // MARK: - Button functions
    func setupLeakyButton() {
        printingButton.closure = printer
    }
    
    func setupNoLeaksButton() {
        printingButton.closure = { [weak self] in self?.printer() }
    }

    @IBAction func button(_ sender: CustomButton) {
        sender.closure?()
    }
    
    func printer() {
        print("This closure was attached to the button")
    }
    
}

class CustomButton: UIButton {
    var closure: (() -> Void)?
    
    func execute() {
        closure?()
    }
}
