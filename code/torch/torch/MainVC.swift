//
//  MainVC.swift
//  torch
//
//  Created by 张俊凯 on 2017/2/16.
//  Copyright © 2017年 张俊凯. All rights reserved.
//

import UIKit
import AVFoundation

var flashCount : Int = 0

class MainVC: UIViewController {
    
    //导航栏
    var nav:UINavigationController?
    //设置按钮
    var setBtn:UIButton?
    //总开关按钮
    var switchBtn:UIButton!
    //闪光按钮
    var flashBtn:UIButton!
    //闪光按钮
    var sosBtn:UIButton!
    
    //中间手电筒按钮
    var lightBtn:UIButton!
    
    //手电筒对象
    var device : AVCaptureDevice!
    
    //定时器
    var flashTimer : Timer!
    
    //SOS的定时器
    var sosTimer : Timer!
    
    //记录灯光是否开启的bool
    var isLightOn : Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //基础界面布局
        basicSettings()
        
        //判断存储状态，灯光在APP启动时就点亮，第二个按钮，0 1 2
        let defaults = UserDefaults.standard
        let isSelected = defaults.object(forKey: String("1"))
        if isSelected != nil {//如果有值并且是开启状态
            if  (isSelected as! Bool) {
                onoff(switchBtn)
                
            }
        }
        
    }//end for viewDidLoad
    
}//end for mainClass


//手电筒功能区
extension MainVC{
    //闪光按钮点击，启动定时器
    func flashBtnClick(_ btn:UIButton){
        
        //如果灯光开启
        if isLightOn == true {//有三种情况，sos 手电筒 flash开着
            if sosTimer != nil{//sos灯开着，关闭
                sosClick(sosBtn)
            }else if flashTimer != nil{//flash灯开着，关闭
                flashTimer.invalidate()
                flashTimer = nil
                //关闭手电筒
                torchOff()
                isLightOn == true ? (isLightOn = false):(isLightOn = true)
                flashBtn.isSelected = isLightOn!
                switchBtn.isSelected = isLightOn!
                
            }else{//手电筒开着，关闭
                onoff(switchBtn)
            }
            
        }else{//开启闪光灯
            flashTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.flashFunction), userInfo: nil, repeats: true)
            RunLoop.main.add(flashTimer, forMode: RunLoopMode.defaultRunLoopMode)
            isLightOn == true ? (isLightOn = false):(isLightOn = true)
            flashBtn.isSelected = isLightOn!
            switchBtn.isSelected = isLightOn!

        }
        
    }
    
    //闪光功能
    func flashFunction(){

        //超过200清零一次
        if flashCount == 200 {
            flashCount = 0
        }
        
        if flashCount % 2 == 0 { //偶数开启灯光
            torchOn()
        }else{//奇数关闭灯光
            torchOff()
        }
        flashCount = flashCount + 1
    }
    
    //开启手电筒，合并功能
    func onoff(_ btn:UIButton){
        
        //如果sos和flash功能开启，先关掉
        if isLightOn == true {//灯光亮着，有三种情况，左中右
            if sosTimer != nil{//sos灯亮着
                sosClick(sosBtn)
            }else if flashTimer != nil{//flash灯亮着
                flashBtnClick(flashBtn)
            }else{//手电筒亮着，关掉
                torchOff()
                //开灯状态进行取反
                isLightOn == true ? (isLightOn = false):(isLightOn = true)
                btn.isSelected = isLightOn!
                //区分总开关和灯开关，进来是谁，另一个开关都跟着一起变动
                if btn == switchBtn{ //如果进来是总开关，灯开关状态跟随总开关
                    lightBtn.isSelected = btn.isSelected
                }else{//如果是灯开关，总开关状态跟随
                    switchBtn.isSelected = btn.isSelected
                }
            }
        }else{//等没亮，直接开启
            torchOn()
            //开灯状态进行取反
            isLightOn == true ? (isLightOn = false):(isLightOn = true)
            btn.isSelected = isLightOn!
            //区分总开关和灯开关，进来是谁，另一个开关都跟着一起变动
            if btn == switchBtn{ //如果进来是总开关，灯开关状态跟随总开关
                lightBtn.isSelected = btn.isSelected
            }else{//如果是灯开关，总开关状态跟随
                switchBtn.isSelected = btn.isSelected
            }
        }

        
    }//end for onoff function

    
    

    
    //供闪光灯调用
    func torchOn(){
        
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

    func torchOff(){
        
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
    
    
    //供中间主按钮用，点击用
    func torchOnForSwitch(_ btn:UIButton){
    
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
    
    func torchOffForSwitch(_ btn:UIButton){
        
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
    
    //SOS功能
    func sosClick(_ sosBtn:UIButton){
        //判断灯光是否开启，如果是开启要先关闭
        if isLightOn == true{
            if flashTimer != nil {//闪光灯开启，要关闭
                flashBtnClick(flashBtn)
            }else if sosTimer != nil{//sos灯光开启，要关闭
                sosTimer.invalidate()
                sosTimer = nil
                torchOff()
                isLightOn == true ? (isLightOn = false):(isLightOn = true)
                sosBtn.isSelected = isLightOn!
                switchBtn.isSelected = isLightOn!
            }else{//手电筒开启，要关闭
                onoff(switchBtn)
            }
        }else{//没有开启灯光
            //三短三长，，短光亮0.3.停0.3，长光亮0.9，停0.9
            sosTimer = Timer.scheduledTimer(timeInterval: Double(timeInterval), target: self, selector: #selector(self.sosFunction), userInfo: nil, repeats: true)
            RunLoop.main.add(sosTimer, forMode: RunLoopMode.defaultRunLoopMode)
            
            isLightOn == true ? (isLightOn = false):(isLightOn = true)
            sosBtn.isSelected = isLightOn!
            switchBtn.isSelected = isLightOn!
            sosCount = 0
        }
        
    }
    
    func sosFunction(){
        
        if sosCount % 2 == 0 { //偶数开启灯光
            torchOn()
        }else{//奇数关闭灯光
            torchOff()
        }
        
        if sosCount % 6 == 0{//间隔三长三短，进行切换
            sosTimer.invalidate()
            sosTimer = nil
            if timeInterval == 0.3 {
                timeInterval = 1.0
            }else{
                timeInterval = 0.3
            }
            sosTimer = Timer.scheduledTimer(timeInterval: Double(timeInterval), target: self, selector: #selector(self.sosFunction), userInfo: nil, repeats: true)
            RunLoop.main.add(sosTimer, forMode: RunLoopMode.defaultRunLoopMode)
        }
        sosCount = sosCount + 1
    }
    
}

//sos全局的变量
var sosCount : Int = 0
var timeInterval : Float = 0.3

//页面设置区
extension MainVC{
    func basicSettings(){
        let bgView = UIImageView(image: UIImage(named:"bg"))
        view.addSubview(bgView)
        
        //新建手电筒对象
        device =  AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        //设置总开关
        switchBtn = UIButton(type: UIButtonType.custom)
        let switchImageOff = UIImageView(image: UIImage(named:"switch_off"))
        let switchImageOn = UIImageView(image: UIImage(named:"switch_on"))
        //在按钮不失真的情况下，按钮宽度总是屏幕宽度的一半
        let swithWidth = switchImageOff.width
        let swithHeight = switchImageOff.height
        let showWidth = SCREEN_WIDTH * 0.5
        switchBtn.setBackgroundImage(switchImageOff.image, for: UIControlState.normal)
        switchBtn.setBackgroundImage(switchImageOn.image, for: UIControlState.highlighted)
        switchBtn.setBackgroundImage(switchImageOn.image, for: UIControlState.selected)
        switchBtn.frame = CGRect(x: 0, y: 0, width: showWidth, height: swithHeight / swithWidth * showWidth)
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
        sosBtn = UIButton(frame: CGRect(x: margin, y: maxY, width: sosImageNormal.width / ratio, height: sosImageNormal.height / ratio))
        sosBtn.setImage(sosImageNormal.image, for: UIControlState.normal)
        sosBtn.setImage(sosImageHighlighted.image, for: UIControlState.highlighted)
        sosBtn.setImage(sosImageHighlighted.image, for: UIControlState.selected)
        sosBtn.addTarget(self, action: #selector(self.sosClick(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(sosBtn)
        
        lightBtn = UIButton(frame: CGRect(x: sosBtn.frame.maxX, y: maxY, width: lightImageNormal.width / ratio, height: lightImageNormal.height / ratio))
        lightBtn.setImage(lightImageNormal.image, for: UIControlState.normal)
        lightBtn.setImage(lightImageHighlighted.image, for: UIControlState.highlighted)
        lightBtn.setImage(lightImageHighlighted.image, for: UIControlState.selected)
        lightBtn.addTarget(self, action: #selector(self.onoff(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(lightBtn)
        
        flashBtn = UIButton(frame: CGRect(x: lightBtn.frame.maxX, y: maxY, width: flashImageNormal.width / ratio, height: flashImageNormal.height / ratio))
        flashBtn.setImage(flashImageNormal.image, for: UIControlState.normal)
        flashBtn.setImage(flashImageHighlighted.image, for: UIControlState.highlighted)
        flashBtn.setImage(flashImageHighlighted.image, for: UIControlState.selected)
        flashBtn.addTarget(self, action: #selector(self.flashBtnClick(_:)), for: UIControlEvents.touchUpInside)
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
        
        //默认灯光是关闭的
        isLightOn = false
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
                
                switchBtn.addTarget(self, action: #selector(self.torchOnForSwitch(_:)), for: UIControlEvents.touchDown)
                switchBtn.addTarget(self, action: #selector(self.torchOffForSwitch(_:)), for: UIControlEvents.touchUpInside)
                
            }else{//开启合并功能
                switchBtn.addTarget(self, action: #selector(self.onoff(_:)), for: UIControlEvents.touchUpInside)
            }
            
        }else{//没有值，手电筒默认合并功能
            switchBtn.addTarget(self, action: #selector(self.onoff(_:)), for: UIControlEvents.touchUpInside)
            
        }
        
    }
    
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        

    




