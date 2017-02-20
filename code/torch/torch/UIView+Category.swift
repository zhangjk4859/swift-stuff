//
//  UIView+Category.swift
//  animal-plant_pool
//
//  Created by 张俊凯 on 2017/2/13.
//  Copyright © 2017年 张俊凯. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    //坐标
    public var x: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    public var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    
    //宽度
    public var width:CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
            
        }
    }
    
    //高度
    public var height:CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
            
        }
    }
    
    //重点
    
}
