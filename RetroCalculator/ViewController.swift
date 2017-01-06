//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Darius Turner on 12/27/16.
//  Copyright © 2016 MTEnterprise. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    // MARK: View Loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    let path = Bundle.main.path(forResource: "btn", ofType: "wav")
    let soundURL = URL(fileURLWithPath: path!)
    
    do {
        try btnSound = AVAudioPlayer(contentsOf: soundURL)
        btnSound.prepareToPlay()
    } catch let err as NSError {
        print(err.debugDescription)
    }
    
    }
    
    // MARK: Actions
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
    }
    
    @IBAction func dividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func multiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func subtractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func addPressed(sender: AnyObject) {
        processOperation(operation: .Add)
    }
    
    @IBAction func equalPressed(sender: AnyObject) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func clearPressed(sender: AnyObject) {
        playSound()
        
        runningNumber.removeAll()
        outputLbl.text = "0"
        currentOperation = Operation.Empty
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    func processOperation(operation: Operation) {
        playSound()
        if currentOperation != Operation.Empty {
            
            //A user selected an operator, but then selected another operator without entering a number
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLbl.text = result
            }
            
            currentOperation = operation
        } else {
            //This is the first time an operator has been pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
            
        }
    }
    
}

