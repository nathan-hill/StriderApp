//
//  ViewController.swift
//  Strider
//
//  Created by Nathan Hill on 7/15/19.
//  Copyright © 2019 Nathan Hill. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // Array of sound values
    private var soundArray = [1057, 1113, 1127, 1261]
    
    // indicates whether the start button is pressed or not
    var status: Bool = true
    
    // timer variable
    var timer: Timer?
    
    // holds the value for the the timer interval
    var stridesPerMinute: TimeInterval = 160
    var sliderValue: Double = 160
    
    var systemSoundID: SystemSoundID = 1016
    
    @IBOutlet weak var striderSlider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var soundStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        soundStepper.wraps = true
        soundStepper.autorepeat = true
        soundStepper.minimumValue = 0
        soundStepper.maximumValue = 3
        
        
        systemSoundID = UInt32(soundArray[0])
        
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderValue = Double(sender.value)
        
        sliderLabel.text = "\(Int(sliderValue))"
        
        stop()
        
        start()
    }
    
    @IBAction func toggleStartStop(_ sender: UIButton) {
        //If the button status is true use stop functions, relabel button
        if (status){
            start()
            sender.setTitle("STOP", for: .normal)
            status = false
        } else{
            stop()
            sender.setTitle("START", for: .normal)
            status = true
        }
    }
    
    @IBAction func soundChanger(_ sender: UIStepper) {
        
        systemSoundID = UInt32(soundArray[Int(sender.value)])
        
        if status {
            playSound()
        }
        
    }
    
    func start(){
        stridesPerMinute = TimeInterval(60 / sliderValue)
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(stridesPerMinute), target: self, selector: #selector(playSound), userInfo: nil, repeats: true)

    }
    
    func stop(){
        timer?.invalidate()
    }
    
    @objc func playSound() {
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    
}

