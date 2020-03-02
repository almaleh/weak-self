//
//  ViewController2.swift
//  WeakSelf
//
//  Created by Besher on 2019-06-02.
//  Copyright © 2019 Besher Al Maleh. All rights reserved.
//

import UIKit

class PresentedController: UIViewController {
    
    var printingButton: CustomButton?
    
    // this property stores escaping closures to demonstrate leaks
    var closureStorage: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Try calling this method with different enum cases to explore other scenarios
         * Run the app in each scenario, and try presenting the controller then dismissing it
         * The comments below will explain why some scenarios are causing a leak and some aren't */
        setup(scenario: .leakyNestedClosure)
    }
    
    
    // MARK: - Leak Scenarios
    
    
    
    // This is a non-escaping closure (executes immediately), therefore we don't need [weak self]
    func uiViewAnimate() {
        UIView.animate(withDuration: 3.0) { self.view.backgroundColor = .red }
    }
    
    
    
    // Same for higher order functions, they are non-escaping, therefore we don't need [weak self]
    func higherOrderFunctions() {
        let numbers = [1,2,3,4,5,6,7,8,9,10]
        numbers.forEach { self.view.tag = $0 }
        _ = numbers.filter { $0 == self.view.tag }
    }
    
    
    
    /* This leaks the controller because we aren't executing the animation immediately. Instead we store it in a property
     * as an escaping closure without using [weak self]. As a result, the closure maintains a strong reference
     * to self, while self also has a strong reference to the closure, thereby causing a leak */
    func leakyViewPropertyAnimator() {
        // color won't actually change, because we aren't executing the animation
        let anim = UIViewPropertyAnimator(duration: 2.0, curve: .linear) { self.view.backgroundColor = .red }
        anim.addCompletion { _ in self.view.backgroundColor = .white }
        self.closureStorage = anim
    }
    
    
    
    /* If we pass references to the properties we want to manipulate directly to the closure, instead of using self,
     * we will no longer leak the controller, even without using [weak self] */
    func nonLeakyViewPropertyAnimator1() {
        let view = self.view
        // color won't actually change, because we aren't executing the animation
        let anim = UIViewPropertyAnimator(duration: 2.0, curve: .linear) { view?.backgroundColor = .red }
        anim.addCompletion { _ in view?.backgroundColor = .white }
        self.closureStorage = anim
    }
    
    
    
    // If we start the animation immediately, it won't leak the controller, even without [weak self]
    func nonLeakyViewPropertyAnimator2() {
        let anim = UIViewPropertyAnimator(duration: 2.0, curve: .linear) { self.view.backgroundColor = .red }
        anim.addCompletion { _ in self.view.backgroundColor = .white }
        anim.startAnimation()
    }
    
    
    
    // If we store a Dispatch closure, it escapes, and will leak the controller if we do not use [weak self]
    func leakyDispatchQueue() {
        let workItem = DispatchWorkItem { self.view.backgroundColor = .red }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
        self.closureStorage = workItem
    }
    
    
    
    // If we execute a Dispatch closure immediately without storing it, there is no need for [weak self]
    func nonLeakyDispatchQueue() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.view.backgroundColor = .red
        }
        
        DispatchQueue.main.async {
            self.view.backgroundColor = .red
        }
        
        DispatchQueue.global(qos: .background).async {
            print(self.navigationItem.description)
        }
    }
    
    
    
    /* This timer will prevent the controller from deallocating because:
     * 1. it repeats
     * 2. self is referenced in the closure without using [weak self]
     * If either of those conditions is false, it wouldn't cause issues */
    func leakyTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let currentColor = self.view.backgroundColor
            self.view.backgroundColor = currentColor == .red ? .blue : .red
        }
        timer.tolerance = 0.5
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    
    
    /* Similar to UIViewPropertyAnimator, if we store a URLSession task without executing it immediately it will
     * leak the controller, unless we use [weak self] */
    func leakyAsyncCall() {
        let url = URL(string: "https://www.github.com")!
        let task = URLSession.shared.downloadTask(with: url) { localURL, _, _ in
            guard let localURL = localURL else { return }
            let contents = (try? String(contentsOf: localURL)) ?? "No contents"
            print(contents)
            print(self.view.description)
        }
        self.closureStorage = task
    }
    
    
    
    /* If you execute the URLSession task immediately, but set a long timeout interval, it will delay the deallocation
     * of your controller until you either cancel the task, get a response back, or timeout. Using [weak self] will
     * prevent that delay. Note: Using port 81 on the url helps simulate a request timeout */
    func delayedAllocAsyncCall() {
        let url = URL(string: "https://www.google.com:81")!
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 999.0
        sessionConfig.timeoutIntervalForResource = 999.0
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.downloadTask(with: url) { localURL, _, error in
            guard let localURL = localURL else { return }
            let contents = (try? String(contentsOf: localURL)) ?? "No contents"
            print(contents)
            print(self.view.description)
        }
        task.resume()
    }
    
    
    
    /* A strong reference cycle is created here since the closure and 'self' reference each other without using
     * [weak self]. Note that '@escaping' is required here, because we are saving the closure for later use.
     * Also note that optional closures such as (() -> Void)? are implicitly escaping (do not require the keyword) */
    func savedClosure() {
        
        func run(closure: @escaping () -> Void) {
            closure()
            self.closureStorage = closure // 'self' stores the closure
        }
        
        run {
            self.view.backgroundColor = .red // the closure references 'self'
        }
    }
    
    
    
    /* [weak self] is not required here, because the closure is not escaping (not stored anywhere).
     * Note that '@escaping' is not required here */
    func unsavedClosure() {
        
        func run(closure: () -> Void) {
            closure()
        }
        
        run {
            self.view.backgroundColor = .red // the closure references 'self'
        }
    }
    
    
    
    /* It can be tempting to pass a function directly to the closure property, but it will leak the entire controller!
     * Reason: self is implicitly captured by the closure, and self owns the button which owns the closure
     * thus creating a reference cycle */
    func setupLeakyButton() {
        printingButton?.closure = printer
    }
    
    
    
    // [weak self] is needed to break the cycle, even if it makes for uglier syntax
    func setupNonLeakyButton() {
        printingButton?.closure = { [weak self] in self?.printer() }
    }
    
    
    
    /* Although this dispatch call is executed immediately, there is a sempaphore blocking the closure from returning,
     * with a long timeout. This doesn't cause a leak, but will cause a delayed deallocation of 'self' since self is
     * referenced without the 'weak' or 'unowned' keyword */
    func delayedAllocSemaphore() {
        DispatchQueue.global(qos: .userInitiated).async {
            let semaphore = DispatchSemaphore(value: 0)
            print(self.view.description)
            _ = semaphore.wait(timeout: .now() + 99.0)
        }
    }
    
    
    
    
    /* This nested closure leaks despite the use of [weak self], because the escaping closure associated with the
     * Dispatch Work Item creates a strong reference to `self` with the [weak self] keyword of its nested
     * closure. Therefore we need to move [weak self] up one level, to the outermost closure, to avoid the leak */
    func leakyNestedClosure() {
        
        let workItem = DispatchWorkItem {
            UIView.animate(withDuration: 1.0) { [weak self] in
                self?.view.backgroundColor = .red
            }
        }
        
        self.closureStorage = workItem
        DispatchQueue.main.async(execute: workItem)
    }
    
    func printer() {
        print("Executing the closure attached to the button")
    }
    
    
    deinit {
        // Not passing here after dismissal means we have a leak problem
        print("Dismissing Presented Controller")
    }
    
    
}
