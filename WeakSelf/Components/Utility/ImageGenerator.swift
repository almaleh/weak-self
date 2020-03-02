//
//  ImageGenerator.swift
//  WeakSelf
//
//  Created by Besher on 2019-06-10.
//  Copyright © 2019 Besher Al Maleh. All rights reserved.
//

import UIKit
import CoreImage

enum ImageGenerator {
    
    static func generateAsyncImages(count: Int, completion: @escaping ([UIImage]) -> Void) {
        var output = [UIImage]()
        let group = DispatchGroup()
        for _ in 0...count {
            group.enter()
            if let image = UIImage(named: "image") {
                filterImageAsync(image) { image in
                    output.append(image)
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            completion(output)
        }
    }
    
    private static func filterImageAsync(_ image: UIImage, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            
            let scale = UIScreen.main.scale
            let orientation = image.imageOrientation
            let context = CIContext()
            let filterName = getRandomFilter
            let filter = CIFilter(name: filterName)
            let ciImage = CIImage(image: image)
            
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            
            guard let filteredCIImage = filter?.outputImage else { return }
            
            if let cgimg = context.createCGImage(filteredCIImage, from: filteredCIImage.extent) {
                let processedImage = UIImage(cgImage: cgimg, scale: scale, orientation: orientation)
                completion(processedImage)
            }
        }
    }
    
    static func generateSyncImages(count: Int) -> [UIImage] {
        var output = [UIImage]()
        for _ in 0...count {
            if let image = UIImage(named: "image") {
                let image = filterImageSync(image)
                output.append(image)
            }
        }
        return output
    }
    
    private static func filterImageSync(_ image: UIImage) -> UIImage {
        let scale = UIScreen.main.scale
        let orientation = image.imageOrientation
        let context = CIContext()
        let filterName = getRandomFilter
        let filter = CIFilter(name: filterName)
        let ciImage = CIImage(image: image)
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let filteredCIImage = filter?.outputImage else { return image }
        
        if let cgimg = context.createCGImage(filteredCIImage, from: filteredCIImage.extent) {
            let processedImage = UIImage(cgImage: cgimg, scale: scale, orientation: orientation)
            return processedImage
        }
        return image
    }
    
    private static var getRandomFilter: String {
        return filters.shuffled()[0]
    }
    
    private static var filters = [
//        "CIBumpDistortion",
//        "CIGaussianBlur", // this is too slow on the simulator
//        "CIPixellate",
//        "CISepiaTone",
//        "CITwirlDistortion",
//        "CIUnsharpMask",
        "CIVignette"
    ]
}
