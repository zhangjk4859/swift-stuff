//
//  Tool.swift
//  animal-plant_pool
//
//  Created by 张俊凯 on 2017/2/16.
//  Copyright © 2017年 张俊凯. All rights reserved.
//

import Foundation
import UIKit



//RGB转换
func RGB(r:CGFloat,g:CGFloat,b:CGFloat) ->UIColor{
    return UIColor(red: r/225.0, green: g/225.0, blue: b/225.0, alpha: 1.0)
}

func RGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) ->UIColor{
    return UIColor(red: r/225.0, green: g/225.0, blue: b/225.0, alpha: a)
}




//设备屏幕尺寸
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//导航栏高度
public let NAVBAR_HEIGHT : CGFloat = 64
//tabbar高度
public let TABBAR_HEIGHT : CGFloat = 49






