//
//  ViewController.swift
//  HumixSense
//
//  Created by Winston Hsieh on 06/07/2017.
//  Copyright © 2017 Humix Community. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result
import ReactiveSwift


class HumixSenseViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfThinkUrl: UITextField!
    
    @IBOutlet weak var tfSenseId: UITextField!
    
    @IBOutlet weak var btnConnect: UIButton!
    
    let viewModel = HumixSenseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tfThinkUrl.delegate = self
        self.tfSenseId.delegate  = self
        
        self.enableBorderButton(button: self.btnConnect)
        
        self.registerViewObserve()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerViewObserve() {
        
        viewModel.thinkUrl <~ self.tfThinkUrl.reactive.continuousTextValues.skipNil()
        
        viewModel.senseId  <~ self.tfSenseId.reactive.continuousTextValues.skipNil()
        
        self.btnConnect.reactive.title <~ viewModel.title4ConnBtn
        
        self.btnConnect.reactive.isEnabled <~ viewModel.uiEnabled4ConnBtn

        self.btnConnect.reactive.pressed = CocoaAction(viewModel.connectAction) { button in
            _ = button
            return true
        }
    }
    
    func enableBorderButton(button: UIButton) {
        
        button.setTitleColor(UIColorFromRGB(rgbValue: 0x90C5E5), for: .normal)
        button.setTitleColor(UIColorFromRGB(rgbValue: 0xC9C9CB), for: .disabled)
        button.setTitleColor(UIColorFromRGB(rgbValue: 0xC36274), for: .highlighted)
        
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = button.bounds.size.height / 2
        button.layer.borderColor  = UIColorFromRGB(rgbValue: 0x90C5E5).cgColor
    }
    
}

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

