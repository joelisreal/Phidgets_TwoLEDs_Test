//
//  ViewController.swift
//  Phidgets_TwoLEDs_Test
//
//  Created by Joel Igberase on 2019-04-17.
//  Copyright © 2019 Joel Igberase. All rights reserved.
//

import UIKit
import Phidget22Swift

class ViewController: UIViewController {
    
    let button = DigitalInput()
    let ledArray = [DigitalOutput(), DigitalOutput()]

    func attach_handler(sender: Phidget){
        do{
            let hubPort = try sender.getHubPort()
            if(hubPort == 0){
                print("LED 0 Attached")
            }
            else if (hubPort == 1){
                print("LED 1 Attached")
            }
            else{
                print("Button Attached")
            }
        } catch let err as PhidgetError{
            print("Phidget Error " + err.description)
        } catch{
            //catch other errors here
        }
    }
    
    func state_change(sender:DigitalInput, state:Bool){
        do{
            if(state == true){
                print("Button Pressed")
                try ledArray[0].setState(true)
                try ledArray[1].setState(true)
            }
            else{
                print("Button Not Pressed")
                try ledArray[0].setState(false)
                try ledArray[1].setState(false)
            }
        } catch let err as PhidgetError{
            print("Phidget Error " + err.description)
        } catch{
            //catch other errors here
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do{
            //enable server discovery
            try Net.enableServerDiscovery(serverType: .deviceRemote)
            
            //address digital input
            try button.setDeviceSerialNumber(528025)
            try button.setHubPort(2)
            try button.setIsHubPortDevice(true)
            
            //add event handler
            let _ = button.stateChange.addHandler(state_change)
            
            //add attach handler
            let _ = button.attach.addHandler(attach_handler)
            
            //open
            try button.open()
            
            //address, add handler, open digital outputs
            for i in 0..<ledArray.count{
                try ledArray[i].setDeviceSerialNumber(528025)
                try ledArray[i].setHubPort(i)
                try ledArray[i].setIsHubPortDevice(true)
                let _ = ledArray[i].attach.addHandler(attach_handler)
                try ledArray[i].open()
            }
            
        } catch let err as PhidgetError {
            print("Phidget Error " + err.description)
        } catch {
            //catch other errors here
        }
    }


}

