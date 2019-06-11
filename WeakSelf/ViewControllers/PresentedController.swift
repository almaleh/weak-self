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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeakyButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        generateImages()
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
    
    func setupNonLeakyButton() {
        printingButton.closure = { [weak self] in self?.printer() }
    }

    @IBAction func button(_ sender: CustomButton) {
        sender.closure?()
    }
    
    func printer() {
        print("Executing the closure attached to the button")
    }
    
    // called by parent
    func back(completion: (() -> Void)?) {
        self.dismiss(animated: true, completion: completion)
    }
    
}

class CustomButton: UIButton {
    var closure: (() -> Void)?
}
