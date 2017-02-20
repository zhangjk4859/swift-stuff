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
    
    //导航栏
    var nav:UINavigationController?
    //设置按钮
    var setBtn:UIButton?
    //总开关按钮
    var switchBtn:UIButton!
    
    //懒加载手电筒对象
    var device : AVCaptureDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bgView = UIImageView(image: UIImage(named:"bg"))
        view.addSubview(bgView)
        
        //新建手电筒对象
        device =  AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        //设置总开关
        switchBtn = UIButton(type: UIButtonType.custom)
        switchBtn.setBackgroundImage(UIImage(named:"switch_off"), for: UIControlState.normal)
        switchBtn.setBackgroundImage(UIImage(named:"switch_on"), for: UIControlState.highlighted)
        switchBtn.setBackgroundImage(UIImage(named:"switch_on"), for: UIControlState.selected)
        switchBtn.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH * 0.67, height: SCREEN_WIDTH * 0.67)
        view.addSubview(switchBtn)
        switchBtn.center = view.center
        
        
        //底部排列三个按钮，从左到右SOS light flash
        
        let margin:CGFloat = 20
        let maxY = switchBtn.frame.maxY + 20
        
        let sosImageNormal = UIImageView(image: UIImage(named:"sos_off"))
        let sosImageHighlighted = UIImageView(image: UIImage(named:"sos_on"))
        
        let lightImageNormal = UIImageView(image: UIImage(named:"light_off"))
        let lightImageHighlighted = UIImageView(image: UIImage(named:"light_on"))
        
        let flashImageNormal = UIImageView(image: UIImage(named:"flash_off"))
        let flashImageHighlighted = UIImageView(image: UIImage(named:"flash_on"))
        
        
        let actualWidth = sosImageNormal.width + lightImageNormal.width + flashImageNormal.width
        let ratio = actualWidth / (SCREEN_WIDTH - margin * 2)
        
        //实际宽度 除以 ratio 就是真实的宽度
        let sosBtn = UIButton(frame: CGRect(x: margin, y: maxY, width: sosImageNormal.width / ratio, height: sosImageNormal.height / ratio))
        sosBtn.setImage(sosImageNormal.image, for: UIControlState.normal)
        sosBtn.setImage(sosImageHighlighted.image, for: UIControlState.highlighted)
        view.addSubview(sosBtn)
        
        let lightBtn = UIButton(frame: CGRect(x: sosBtn.frame.maxX, y: maxY, width: lightImageNormal.width / ratio, height: lightImageNormal.height / ratio))
        lightBtn.setImage(lightImageNormal.image, for: UIControlState.normal)
        lightBtn.setImage(lightImageHighlighted.image, for: UIControlState.highlighted)
        view.addSubview(lightBtn)
        
        let flashBtn = UIButton(frame: CGRect(x: lightBtn.frame.maxX, y: maxY, width: flashImageNormal.width / ratio, height: flashImageNormal.height / ratio))
        flashBtn.setImage(flashImageNormal.image, for: UIControlState.normal)
        flashBtn.setImage(flashImageHighlighted.image, for: UIControlState.highlighted)
        view.addSubview(flashBtn)
        

        //添加设置按钮，居中
        setBtn = UIButton(type: UIButtonType.custom)
        setBtn?.setImage(UIImage(named:"setup"), for: UIControlState.normal)
        setBtn?.setImage(UIImage(named:"setup_on"), for: UIControlState.selected)
        setBtn?.frame.size = UIImageView(image: UIImage(named: "setup")).frame.size
        setBtn?.center.x = view.center.x
        setBtn?.y = SCREEN_HEIGHT - (setBtn?.height)! - 10
        view.addSubview(setBtn!)
        setBtn?.addTarget(self, action: #selector(self.popMenu(_:)), for: UIControlEvents.touchUpInside)
        
        //判断存储状态，灯光在APP启动时就点亮，第二个按钮，0 1 2
        let defaults = UserDefaults.standard
        let isSelected = defaults.object(forKey: String("1"))
        if isSelected != nil {//如果有值并且是开启状态
            if  (isSelected as! Bool) {
                onoff(switchBtn)
            }
        }
        
    }
    
    //弹出菜单
    func popMenu(_ btn:UIButton){
        let menuVC = TableMenuVC()
        nav = UINavigationController(rootViewController: menuVC)
        present(nav!, animated: true, completion: nil)
    }
    
    
    //即将显示界面的时候
    override func viewWillAppear(_ animated: Bool) {
        
        //先去除所有的点击事件
        switchBtn.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
        //检查按钮点灯的状态，默认是点击开启，选择后是点击开启，松开关闭
        let defaults = UserDefaults.standard
        let isSelected = defaults.object(forKey: String("2"))
        if isSelected != nil {//如果有值
            
            if  (isSelected as! Bool) {//开启分开功能
                
                switchBtn.addTarget(self, action: #selector(self.torchOn(_:)), for: UIControlEvents.touchDown)
                switchBtn.addTarget(self, action: #selector(self.torchOff(_:)), for: UIControlEvents.touchUpInside)
                
            }else{//开启合并功能
                switchBtn.addTarget(self, action: #selector(self.onoff(_:)), for: UIControlEvents.touchUpInside)
            }
        
        }else{//没有值，手电筒默认合并功能
            switchBtn.addTarget(self, action: #selector(self.onoff(_:)), for: UIControlEvents.touchUpInside)
            
        }
        
    }
    
    
}

//手电筒功能区
extension MainVC{
    //开启手电筒，合并功能
    func onoff(_ btn:UIButton){
        
        btn.isSelected == true ? (btn.isSelected = false) : (btn.isSelected = true)
        
        if device == nil {
            btn.isEnabled = false
            return
        }

        if device.torchMode == AVCaptureTorchMode.off{
            do {
                try device.lockForConfiguration()
            } catch {
                return
            }
            device.torchMode = .on
            device.unlockForConfiguration()
            btn.isSelected = true
        }else {
            do {
                try device.lockForConfiguration()
            } catch {
                return
            }
            device.torchMode = .off
            device.unlockForConfiguration()
            btn.isSelected = false
        }
    }

    
    
    //开始分解电筒函数，开启和关闭分离
    func torchOn(_ btn:UIButton){
        
        btn.isSelected = false
        
        if device == nil {
            return
        }
        
        if device.torchMode == AVCaptureTorchMode.off{
            do {
                try device.lockForConfiguration()
            } catch {
                return
            }
            device.torchMode = .on
            device.unlockForConfiguration()
        }
        
    }
    
    func torchOff(_ btn:UIButton){
        
        if device == nil {
            return
        }
        
        if device.torchMode == AVCaptureTorchMode.on{
        
        do {
            try device.lockForConfiguration()
        } catch {
            return
        }
        device.torchMode = .off
        device.unlockForConfiguration()
        }
    }
    
}


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        

    




