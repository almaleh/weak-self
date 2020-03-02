//
//  LeakStyle.swift
//  WeakSelf
//
//  Created by Besher on 2019-06-11.
//  Copyright © 2019 Besher Al Maleh. All rights reserved.
//

import Foundation

enum LeakScenario {
    case higherOrderFunctions, uiViewAnimate, leakyNestedClosure
    case leakyViewPropertyAnimator, nonLeakyViewPropertyAnimator1, nonLeakyViewPropertyAnimator2
    case leakyDispatchQueue, nonLeakyDispatchQueue
    case leakyTimer, leakyAsyncCall
    case savedClosure, unsavedClosure
    case delayedAllocAsyncCall, delayedAllocSemaphore
    case leakyButton, nonLeakyButton
}
