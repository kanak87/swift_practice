//
//  ViewController.swift
//  ShotGame
//
//  Created by YongEun on 2016. 7. 4..
//  Copyright © 2016년 YongEun. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation

class ViewController: UIViewController {
    
    var birdImage:UIImage?
    var birdDeadImage:UIImage?
    var birds:Array<UIImageView>?
    var bullets:[UIView]?
    var birdSize:CGSize?
    
    var collisionTimer:NSTimer?
    var birdAddTimer:NSTimer?
    
    var bulletSoundPlayer:AVAudioPlayer?
    var birdSoundPlayer:AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.birdAddTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:#selector(ViewController.generateBird), userInfo: nil, repeats: true)
        
        self.collisionTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.checkCollision), userInfo: nil, repeats: true)
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(ViewController.shot))
        
        self.view.addGestureRecognizer(tapGesture)
        
        self.birds = [UIImageView]()
        self.bullets = [UIView]()
        self.birdImage = UIImage(named: "bird")
        self.birdDeadImage = UIImage(named: "birdDead")
        
        self.birdSize = CGSize(width:self.birdImage!.size.width,
                                height: self.birdImage!.size.height)
        
        let gunSoundPath = NSBundle.mainBundle().URLForResource("gunshot", withExtension: "mp3")
        let birdSoundPath = NSBundle.mainBundle().URLForResource("birdsound", withExtension: "mp3")
        
        do
        {
            self.birdSoundPlayer = try AVAudioPlayer(contentsOfURL: birdSoundPath!)
            self.birdSoundPlayer?.prepareToPlay()
            
            self.bulletSoundPlayer = try AVAudioPlayer(contentsOfURL: gunSoundPath!)
            self.bulletSoundPlayer?.prepareToPlay()
            
        }
        catch
        {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.birds = [UIImageView]()
        self.bullets = [UIView]()
        
        self.birdImage = UIImage(named:"bird")
        self.birdDeadImage = UIImage(named:"birdDead")
        
        self.birdSize = CGSize(width: self.birdImage!.size.width, height:self.birdImage!.size.height)
        
        let bulletSoundURL = NSBundle.mainBundle().URLForResource("gunShot", withExtension: "mp3")
        let birdSoundURL = NSBundle.mainBundle().URLForResource("birdDead", withExtension: "mp3")
        
        do
        {
            self.bulletSoundPlayer = try AVAudioPlayer(contentsOfURL: bulletSoundURL!) as AVAudioPlayer
            self.birdSoundPlayer = try AVAudioPlayer(contentsOfURL: birdSoundURL!) as AVAudioPlayer
        }
        catch
        {
            print(error)
        }
        
        self.bulletSoundPlayer?.prepareToPlay()
        self.birdSoundPlayer?.prepareToPlay()
    }
    
    func generatePosition(targetFrame:CGRect, isMoveRight:Bool) -> (position:CGPoint, isMoveRight:Bool)
    {
        let randY = Int(rand())
        
        var posX = targetFrame.size.width + self.birdSize!.width
        let posY = randY % Int(targetFrame.size.height - self.birdSize!.height)
        
        if isMoveRight
        {
            posX = -self.birdSize!.width
        }
        
        return (CGPoint(x:CGFloat(posX), y:CGFloat(posY)), isMoveRight)
    }
    
    func generateBird()
    {
        let isMovingRight:Bool = Bool(Int(rand())%2)
        
        let startPosAndDir = self.generatePosition(self.view.bounds, isMoveRight: isMovingRight)
        let pos = startPosAndDir.position
        
        let bird:UIImageView = UIImageView(image:self.birdImage)
        bird.frame = CGRect(origin: pos, size: self.birdSize!)
        
        self.view.addSubview(bird)
        self.birds?.append(bird)
        
        let resultPosAndDir = self.generatePosition(self.view.bounds, isMoveRight: !isMovingRight)
        
        self.moveView(bird, pos: resultPosAndDir.position, interval: 4)
    }
    
    func shot()
    {
        let bulletSize = CGSize(width: 10, height: 10)
        let posX = (self.view.bounds.width-bulletSize.width) / 2.0
        let startPos = CGPoint(x: posX, y: self.view.bounds.size.height + bulletSize.height)
        let bulletStartFrame:CGRect = CGRect(origin:startPos, size:bulletSize)
        let bulletEndPos = CGPoint(x: posX, y: -bulletSize.height)
        let bullet:UIView = UIView(frame: bulletStartFrame)
    
        bullet.backgroundColor = UIColor.blackColor()
        
        self.view.addSubview(bullet)
        self.bullets?.append(bullet)
        
        self.moveView(bullet, pos:bulletEndPos, interval: 1.5)
        
        self.bulletSoundPlayer?.currentTime = 0
        self.bulletSoundPlayer?.play()
    }
    
    func checkCollision(timer:NSTimer)
    {
        for bird:AnyObject in self.birds!
        {
            let birdImageView:UIImageView = bird as! UIImageView
            
            if let birdLayer:CALayer = birdImageView.layer.presentationLayer() as? CALayer
            {
                for bullet:AnyObject in self.bullets!
                {
                    if let bulletView:UIView = bullet as? UIView
                    {
                        if let bulletPos:CGPoint = bulletView.layer.presentationLayer()?.position
                        {
                            print(bulletPos, birdImageView.frame)
                            if birdLayer.hitTest(bulletPos) != nil
                            {
                                let birdIndex:Int? = self.birds?.indexOf(birdImageView)
                                let bulletIndex:Int? = self.bullets?.indexOf(bulletView)
                                
                                if let index = birdIndex
                                {
                                    self.birds?.removeAtIndex(index)
                                }
                                
                                if let index = bulletIndex
                                {
                                    self.bullets?.removeAtIndex(index)
                                }
                                
                                bulletView.layer.removeAllAnimations()
                                birdImageView.layer.removeAllAnimations()
                                
                                let birdPos:CGPoint = CGPoint(x:birdLayer.position.x - birdImageView.frame.size.width/2,
                                                              y:birdLayer.position.y - birdImageView.frame.size.height/2)
                                
                                let bulletPos:CGPoint = CGPoint(x:bulletView.layer.position.x - bulletView.frame.size.width/2,
                                                              y:bulletView.layer.position.y - bulletView.frame.size.height/2)
                                
                                birdImageView.frame = CGRect(origin: birdPos, size: birdImageView.frame.size)
                                birdImageView.image = self.birdDeadImage
                                
                                bulletView.frame = CGRect(origin: bulletPos, size: bulletView.frame.size)
                                
                                self.viewFadeOut([bulletView, birdImageView])
                                self.birdSoundPlayer?.play()
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    func viewFadeOut(views:[UIView])
    {
        for object:AnyObject in views
        {
            let view:UIView = object as! UIView
            
            UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut,
                                       animations: { view.alpha = 0 },
                                       completion: { (value:Bool) in view.removeFromSuperview() }
            )
        }
    }
    
    func moveView(view:UIView?, pos:CGPoint, interval:NSTimeInterval)
    {
        UIView.animateWithDuration(interval, delay: 0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                if let movingView = view
                {
                    movingView.frame = CGRect(origin: pos, size: movingView.frame.size)
                }
            },
            completion: {
                (completed:Bool) in
                if completed == true
                {
                    if let movingView = view
                    {
                        var index:Int? = nil
                        
                        if movingView.isKindOfClass(UIImageView)
                        {
                            index = self.birds!.indexOf(movingView as! UIImageView)
                            self.birds?.removeAtIndex(index!)
                        }
                        else if movingView.isKindOfClass(UIImage)
                        {
                            index = self.bullets!.indexOf(movingView)
                            self.bullets?.removeAtIndex(index!)
                        }
                        
                        movingView.removeFromSuperview()
                    }
                }
                
            });
    }
}

