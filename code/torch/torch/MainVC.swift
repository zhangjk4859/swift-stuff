//
//  MainVC.swift
//  torch
//
//  Created by 张俊凯 on 2017/2/16.
//  Copyright © 2017年 张俊凯. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.orange
        
        let btn = UIButton(type: UIButtonType.custom)
        btn.width = 100
        btn.height  = 100
        view.addSubview(btn)
        btn.center = view.center
        btn.addTarget(self, action: #selector(self.onoff(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    func onoff(_ sender:UIButton){
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if device == nil {
            sender.isEnabled = false
            return
        }
        if device?.torchMode == AVCaptureTorchMode.off{
            do {
                try device?.lockForConfiguration()
            } catch {
                return
            }
            device?.torchMode = .on
            device?.unlockForConfiguration()
            sender.isSelected = true
        }else {
            do {
                try device?.lockForConfiguration()
            } catch {
                return
            }
            device?.torchMode = .off
            device?.unlockForConfiguration()
            sender.isSelected = false
        }
    }

        
}
    




