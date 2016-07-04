//
//  ViewController.swift
//  FlyingBird
//
//  Created by YongEun on 2016. 7. 4..
//  Copyright © 2016년 YongEun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var tapRecognizer:UIGestureRecognizer?
    
    var birdImageView:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let birdImage:UIImage? = UIImage(named:"bird")
        
        self.birdImageView = UIImageView(image:birdImage)
        
        if let birdSize = birdImage?.size
        {
            self.birdImageView?.frame = CGRect(origin: CGPointZero, size: birdSize)
        }
        
        if let birdView:UIImageView = self.birdImageView
        {
            self.view.addSubview(birdView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let touchPoint:CGPoint = touch.locationInView(self.view)
        
        if let birdsSize:CGSize = self.birdImageView?.frame.size
        {
            var targetPoint:CGPoint = CGPoint(x: touchPoint.x - birdsSize.width/2,
                                              y: touchPoint.y - birdsSize.height/2)
            
            UIView.animateWithDuration(0.5, animations: {
                self.birdImageView!.frame = CGRect(origin: targetPoint, size: birdsSize)
                })
        }
        
        return true
    }


}

