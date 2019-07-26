//
//  ViewController.swift
//  coreAnimation
//
//  Created by admin on 26/07/19.
//  Copyright © 2019 professional. All rights reserved.
//

import UIKit


func degreeToRadians (deg: CGFloat) -> CGFloat {
    return (deg * CGFloat.pi)/180
}


class ViewController: UIViewController {
    
 let transformLayer = CATransformLayer()
    var currentAngle:CGFloat = 0
    var currentOffset:CGFloat = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        transformLayer.frame = self.view.bounds
        view.layer.addSublayer(transformLayer)
        
        for i in 1 ... 6 {
            addImageCard(name: "\(i)")
        }
        
        turnCarousel()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.performPanAction(recognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    func addImageCard (name: String) {
        
        
        
        let ImageCardSize = CGSize(width: 200, height: 300)
         let ImageLayer = CALayer()
        ImageLayer.frame = CGRect(x: view.frame.size.width / 2 - ImageCardSize.width / 2 , y: view.frame.size.height / 2 - ImageCardSize.height / 2 , width: ImageCardSize.width, height: ImageCardSize.height)
        
        ImageLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        guard let ImageCardImage = UIImage(named: name)?.cgImage else  {return}
        
        ImageLayer.contents = ImageCardImage
        ImageLayer.contentsGravity = .resizeAspect
        ImageLayer.masksToBounds = true
        
        ImageLayer.isDoubleSided = true
        ImageLayer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        ImageLayer.borderWidth = 5
        ImageLayer.cornerRadius = 10
        
        transformLayer.addSublayer(ImageLayer)
    }
    
    
    func turnCarousel() {
        guard let transformSubLayers = transformLayer.sublayers else {return}
        
        let segmentForImageCard = CGFloat(360 / transformSubLayers.count)
        
        var angleOffset = currentAngle
        for layer in transformSubLayers {
            var transform = CATransform3DIdentity
            transform.m34 = -1 / 500
            
            transform = CATransform3DRotate(transform, degreeToRadians(deg: angleOffset), 0, 1, 0)
            transform = CATransform3DTranslate(transform, 0, 0, 200)
            
            
            CATransaction.setAnimationDuration(0)
            
            
            layer.transform = transform
            
            angleOffset += segmentForImageCard
        }
    }
    
    
@objc
    func performPanAction (recognizer:UIPanGestureRecognizer) {
    
    let xOffset = recognizer.translation(in: self.view).x
    
    
    if recognizer.state == .began {
        currentOffset = 0
    }
    
    let xDiff = xOffset - currentOffset
    currentOffset += xDiff
    currentAngle += xDiff
    
    turnCarousel()
    
    }

}

