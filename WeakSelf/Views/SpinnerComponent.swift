//
//  SpinnerComponent.swift
//  WeakSelf
//
//  Created by Besher on 2019-06-11.
//  Copyright © 2019 Besher Al Maleh. All rights reserved.
//

import UIKit

class SpinnerComponent: UIView {
    
    let spinner = UIActivityIndicatorView()
    let label = UILabel()
    var stack = UIStackView()
    
    init(text: String, parent: UIView) {
        let width: CGFloat = 140
        let originX: CGFloat = (parent.bounds.width / 2) - (width / 2)
        let frame = CGRect(x: originX, y: 90, width: width, height: 70)
        label.text = text
        spinner.startAnimating()
        super.init(frame: frame)
        
        parent.addSubview(self)
        
        applyStyles()
        createStack()
        applyConstraints(parent: parent)
        show()
    }
    
    private func applyStyles() {
        self.alpha = 0.0
        self.backgroundColor = UIColor.magenta
        self.layer.cornerRadius = 12
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .white
    }
    
    private func createStack() {
        let stack = UIStackView(arrangedSubviews: [spinner, label])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 10
        addSubview(stack)
        self.stack = stack
    }
    
    private func applyConstraints(parent: UIView) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: label.bounds.width),
            
            self.heightAnchor.constraint(equalTo: stack.heightAnchor, constant: 20),
            self.widthAnchor.constraint(equalToConstant: label.bounds.width + 30),
            self.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            self.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            ])
    }
    
    // MARK: - Animations
    
    func show() {
        UIViewPropertyAnimator(duration: 0.2, curve: .linear) { self.alpha = 1.0 }.startAnimation()
    }
    
    func stop() {
        let anim = UIViewPropertyAnimator(duration: 0.2, curve: .linear) { self.alpha = 0.0 }
        anim.addCompletion { _ in self.removeFromSuperview() }
        anim.startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
