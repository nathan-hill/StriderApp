//
//  ViewController.swift
//  Strider
//
//  Created by Nathan Hill on 7/15/19.
//  Copyright © 2019 Nathan Hill. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

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
    
    let defaults = UserDefaults.standard
    
    
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
        
        
    
        
        // if the user bool is true, then this is the first time opening the app
        if defaults.bool(forKey: "firstRun") {
            defaults.set(false, forKey: "firstRun")
            systemSoundID = UInt32(soundArray[0])
        } else{
            // if the user bool is false, then the app has been opened more than once and userDefault data should be used in place of placeholder values
            
            //restores the saved sound of the user
            let soundNum = defaults.double(forKey: "soundValue")
            systemSoundID = UInt32(soundArray[Int(soundNum)])
            
            // restores the saved stride per minute value of the user
            stridesPerMinute = defaults.double(forKey: "strideValue")
            
            // restores the saved slider value of the user
            sliderValue = defaults.double(forKey: "sliderValue")
            sliderLabel.text = "\(Int(sliderValue))"
            striderSlider.value = Float(sliderValue)
            
        }
        
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        // update slider value and text
        sliderValue = Double(sender.value)
        sliderLabel.text = "\(Int(sliderValue))"
        
        // reset the timer with the new input received from slider
        stop()
        
        // only restart the timer if the timer was already enabled,  this removes the chance for multiple timers to start if the user moves the slider
        if !status {
            start()
        }
        
        
        
        // update the userDefaults with the new slider value
        defaults.set(sliderValue, forKey: "sliderValue")
    }
    
    @IBAction func toggleStartStop(_ sender: UIButton) {
        //If the button status is true use stop functions, relabel button
        if status {
            start()
            
            // make the button into PAUSE image
            sender.setImage(UIImage(named: "btn_pause"), for: .normal)
            status = false
        } else{
            stop()
            
            //make the button into START image
            sender.setImage(UIImage(named: "btn_play"), for: .normal)
            status = true
        }
    }
    
    @IBAction func soundChanger(_ sender: UIStepper) {
        // update the current sound by stepping either up or down in the array
        systemSoundID = UInt32(soundArray[Int(sender.value)])
        defaults.set(sender.value, forKey: "soundValue")
        
        // if the timer isn't in use, play the sound so the user knows which sound is currently selected
        if status {
            playSound()
        }
    }
    
    func start(){
        // calculate and save the current user strides per minute
        stridesPerMinute = TimeInterval(60 / sliderValue)
        defaults.set(stridesPerMinute, forKey: "strideValue")
        
        // initialize a timer using the strides per minute value and call the playSound function to create a metronome
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(stridesPerMinute), target: self, selector: #selector(playSound), userInfo: nil, repeats: true)
    }
    
    
    func stop(){
        // stops the timer runtime and removes it from its run loop
        timer?.invalidate()
    }
    
    @objc func playSound() {
        // plays the desired sound from system settings, set by the user using a stepper
        
        AudioServicesPlaySystemSound(systemSoundID)
    }
}

