//
//  ViewController.swift
//  MusicPlayer
//
//  Created by YongEun on 2016. 7. 1..
//  Copyright © 2016년 YongEun. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer:AVAudioPlayer?
    var progressTimer:NSTimer?
    
    @IBOutlet var progressSlider:UISlider?
    @IBOutlet var volumeStepper:UIStepper?
    @IBOutlet var volumeLabel:UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundleURL:NSURL? = NSBundle.mainBundle().URLForResource("music", withExtension:"mp3")
        
        do
        {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL:bundleURL!)
            self.audioPlayer?.delegate = self
            self.progressSlider?.value = 0
        }
        catch
        {
               print(error)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?)
    {
        let alert:UIAlertController = UIAlertController(title:"에러", message:"mp3 디코드 에러", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction:UIAlertAction = UIAlertAction(title:"확인", style: UIAlertActionStyle.Cancel)
        {
            (action:UIAlertAction) -> Void in
            alert.dismissViewControllerAnimated(true, completion:nil)
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func makeProgressTimer()
    {
        self.progressTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:Selector("checkCurrentTime"), userInfo:nil, repeats:true)
    }
    
    func invalidateProgressTimer()
    {
        self.progressTimer?.invalidate()
    }
    
    func checkCurrentTime()
    {
        self.progressSlider?.value = CFloat(self.audioPlayer!.currentTime/self.audioPlayer!.duration)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
    {
        invalidateProgressTimer()
    }
    
    @IBAction func sliderMove(slider:UISlider)
    {
        self.audioPlayer?.stop()
        self.audioPlayer?.currentTime = Double(self.audioPlayer!.duration) * Double(slider.value)
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.play()
    }
    
    @IBAction func clickPlayButton(button:UIButton)
    {
        self.audioPlayer?.play()
        makeProgressTimer()
    }
    
    @IBAction func clickStopButton(button:UIButton)
    {
        self.audioPlayer?.stop()
        invalidateProgressTimer()
    }
    
    @IBAction func clickVolumeStepper(stepper:UIStepper)
    {
        self.audioPlayer?.volume = CFloat(stepper.value)
        self.volumeLabel?.text = NSString(format: "%.1f", stepper.value) as String
    }
    
}

