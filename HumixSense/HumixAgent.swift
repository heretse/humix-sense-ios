//
//  HumixAgent.swift
//  HumixSense
//
//  Created by Winston Hsieh on 10/08/2017.
//  Copyright © 2017 Humix Community. All rights reserved.
//

import Foundation
import SwiftWebSocket

enum HumixStatus {
    case INITIALING, STOPPED, CONNECTING, CONNECTED, STOPPING, ERROR
}

protocol HumixAgentDelegate:class {
    func humixStatusChanged(status:HumixStatus, error:Error?)
}

class HumixAgent:NSObject {
    
    static let instance = HumixAgent()
    
    var thinkURL = "humix-test-taipei.mybluemix.net"
    
    var senseId  = "audiobox-607af1"//audiobox-bf89cc"
    
    let uuid = UUID().uuidString
    
    weak var delegate: HumixAgentDelegate?
    
    var ws:WebSocket?
    
    var currentState:HumixStatus = .STOPPED
    
    // Method to get singleton instance
    class func getInstance() -> HumixAgent {
        return instance
    }
    
    override init() {
        super.init()
    }
    
    func start() {
        if ws == nil {
            currentState = .INITIALING
            
            self.delegate?.humixStatusChanged(status: self.currentState, error: nil)
            
            var url = thinkURL
            
            if thinkURL.hasPrefix("http://") {
                url = thinkURL.substring(from: thinkURL.characters.index(after: thinkURL.lastIndexOf("/")!))
            }
            
            ws = WebSocket("ws://" + url + "/node-red/comms_sense")
            
            ws!.event.open = {
                print("Connected to Think!")
                self.currentState = .CONNECTED
                
                self.ws!.send("{\"senseId\":\"" + self.senseId + "\",\"data\":{\"eventType\":\"humix-think\",\"eventName\":\"sense.status\",\"message\":\"connected\"}}")
                print("Connected SenseId \(self.senseId) to Think successfully.")
                
                self.delegate?.humixStatusChanged(status: self.currentState, error: nil)
            }
            
            ws!.event.end = { argv1, argv2, argv3, argv4 in
                print("Disconnected to Think!")
                self.currentState = .STOPPED
                
                self.ws = nil
                
                self.delegate?.humixStatusChanged(status: self.currentState, error: nil)
            }
            
            ws!.event.error = { err in
                print("Error occurred while publising senseid : \(self.senseId), ERRMSG: \(err)");
                self.currentState = .ERROR
                
                self.delegate?.humixStatusChanged(status: self.currentState, error: err)
            }
        }
        
        if ws!.readyState != .open {
            currentState = .CONNECTING
            
            self.delegate?.humixStatusChanged(status: self.currentState, error: nil)
            
            ws!.open()
        }
    }
    
    func publish(module:String, event:String, message:String) {
//         let text = "你好嗎？"
         let message = "{\"senseId\":\"" + self.senseId + "\",\"data\":{\"eventType\":\"\(module)\",\"eventName\":\"\(event)\",\"message\":\"\(message)\"}}"
         print(message)
         self.ws!.send(message)
    }
    
    func stop() {
        if ws!.readyState == .open {
            currentState = .STOPPING
            
            self.delegate?.humixStatusChanged(status: self.currentState, error: nil)
            
            ws!.close()
        }
    }
    
}

extension String {
    func indexOf(_ input: String,
                 options: String.CompareOptions = .literal) -> String.Index? {
        return self.range(of: input, options: options)?.lowerBound
    }
    
    func lastIndexOf(_ input: String) -> String.Index? {
        return indexOf(input, options: .backwards)
    }
}
