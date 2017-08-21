//
//  HumixSenseViewModel.swift
//  HumixSense
//
//  Created by Winston Hsieh on 16/08/2017.
//  Copyright © 2017 Humix Community. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result
import ReactiveSwift

class HumixSenseViewModel: HumixAgentDelegate {
    
    let humixAgent = HumixAgent.getInstance()
    
    let thinkUrl: MutableProperty<String?>
    
    let senseId: MutableProperty<String?>
    
    let title4ConnBtn: MutableProperty<String>
    
    let uiEnabled4ConnBtn: MutableProperty<Bool>
    
    lazy var connectAction: Action<Bool, Void, NoError> = {
        return Action<Bool, Void, NoError> { value in
            
            if (self.humixAgent.currentState == .STOPPED) {
                self.humixAgent.thinkURL = self.thinkUrl.value!
                self.humixAgent.senseId = self.senseId.value!
                
                self.humixAgent.start()
            } else {
                self.humixAgent.stop()
            }
            
            return SignalProducer<Void, NoError> { observer, _ in observer.sendCompleted() }
        }
    }()
    
    init() {
        
        thinkUrl = MutableProperty("")
        
        senseId  = MutableProperty("")
        
        title4ConnBtn = MutableProperty("Connect")
        
        uiEnabled4ConnBtn = MutableProperty(true)
        
        humixAgent.delegate = self
    }
    
    func humixStatusChanged(status: HumixStatus, error: Error?) {
        switch status {
        case .CONNECTING:
            title4ConnBtn.value  = "Connecting..."
            uiEnabled4ConnBtn.value = false
        case .CONNECTED:
            title4ConnBtn.value  = "Disconnect"
            uiEnabled4ConnBtn.value = true
        case .ERROR:
            title4ConnBtn.value  = "Connect"
            uiEnabled4ConnBtn.value =  true
        case .INITIALING:
            title4ConnBtn.value  = "Initialing..."
            uiEnabled4ConnBtn.value =  false
        case .STOPPED:
            title4ConnBtn.value  = "Connect"
            uiEnabled4ConnBtn.value =  true
        case .STOPPING:
            title4ConnBtn.value  = "Stopping..."
            uiEnabled4ConnBtn.value =  false
        }
    }
    
}
