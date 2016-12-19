//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var str1 = "hello playground"

let view = UIView(frame:CGRect(x: 0, y: 0, width: 375, height: 667))
view.backgroundColor = UIColor.green

let btn = UIButton(type: UIButtonType.contactAdd)
view.addSubview(btn)
btn.center = view.center

var sum = 0


for i in 0..<9{
    sum += i
}




