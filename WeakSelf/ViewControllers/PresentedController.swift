//
//  ViewController2.swift
//  WeakSelf
//
//  Created by Besher on 2019-06-02.
//  Copyright © 2019 Besher Al Maleh. All rights reserved.
//

import UIKit

class PresentedController: UIViewController {
    @IBOutlet weak var printingButton: CustomButton! // TODO replace by bar button
    
    deinit {
        // if you don't pass here after dismissal, then you have a leak problem
        print("Dismissing Presented Controller")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // try different styles when calling this method
        setupButton(style: .nonLeakyButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        generateImages()
    }
    
    func generateImages() {
        let spinner = SpinnerComponent(text: "Applying filters...", parent: self.view)
        ImageGenerator.generateAsyncImages(count: 10) { images in
            images.forEach {
                let imageView = UIImageView(image: $0)
                self.view.insertSubview(imageView, belowSubview: spinner)
            }
            spinner.stop()
        }
    }
    
    // MARK: - Button functions
    func setupButton(style: LeakStyle) {
        switch style {
        case .leakyButton: setupLeakyButton()
        case .nonLeakyButton: setupNonLeakyButton()
        }
    }
    
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

