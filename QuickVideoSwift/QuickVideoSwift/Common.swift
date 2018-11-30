//
//  Common.swift
//  QuickVideoSwift
//
//  Created by aaron on 2018/11/26.
//  Copyright © 2018年 aaron. All rights reserved.
//

import Foundation
import UIKit
import BFKit

func COLOR(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor
{
    return RGBA(r: red, g: green, b: blue, a: 1.0)
}

func COLORONE(value: CGFloat) -> UIColor {
    return COLOR(red: value, green: value, blue: value)
}

func RGBA(r red:CGFloat, g green:CGFloat, b blue:CGFloat, a alpha:CGFloat) -> UIColor
{
    return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}

func LoadImage(_ imageName: String) -> UIImage {
    return UIImage.init(named: imageName)!
}

func HexColor(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


let DocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

/** Window */
let MainWindow : UIWindow = UIApplication.shared.keyWindow!

let Version9_ORLater: Bool = {
    if #available(iOS 9.0, *) {
        return true
    }
    return false
}()


/** 是不是IPX */
let KIsiPhoneX : Bool = {
    let selector = NSSelectorFromString("currentMode")
    let IphoneXSize = CGSize.init(width: 1125, height: 2436)
    return UIScreen.instancesRespond(to: selector) ? IphoneXSize.equalTo(UIScreen.main.currentMode!.size) : false
}()

let kRegFont : FontName = .pingFangSCRegular
let kMedFont : FontName = .pingFangSCMedium
let kSemFont : FontName = .pingFangSCSemiBold

//输出行数
func DPrint<T>(_ message : T, file : String = #file, lineNumber : Int = #line) {
    
    #if DEBUG
    
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):line:\(lineNumber)]- \(message)")
    
    #endif
}

func ViewRadius(V view:UIView, R radius:CGFloat){
    view.layer.cornerRadius = radius
    view.layer.masksToBounds = true
}

/** 数值 */
let KWidth: CGFloat = UIScreen.main.bounds.width
let KHeight: CGFloat = UIScreen.main.bounds.height
let KTabBarH: CGFloat = 49.0
let KStatusBarH: CGFloat = KIsiPhoneX ? 44: 20
let KNaviBarH : CGFloat = 44.0

/** 颜色 */
let BorderColor: UIColor = {
    return COLOR(red: 215, green: 215, blue: 215)
}()
let BgColor: UIColor = {
    return COLOR(red: 238, green: 238, blue: 238)
}()
let HolderColor: UIColor = {
    return COLOR(red: 153, green: 153, blue: 153)
}()
let DeepDarkTitleColor: UIColor = {
    return COLOR(red: 51, green: 51, blue: 51)
}()
let DarkTitleColor: UIColor = {
    return COLOR(red: 68, green: 68, blue: 74)
}()
let DarkGrayTitleColor: UIColor = {
    return COLOR(red: 109, green: 109, blue: 114)
}()
let GrayTitleColor: UIColor = {
    return COLOR(red: 152, green: 152, blue: 156)
}()
let BlueColor: UIColor = {
    return COLOR(red: 57, green: 152, blue: 245)
}()



