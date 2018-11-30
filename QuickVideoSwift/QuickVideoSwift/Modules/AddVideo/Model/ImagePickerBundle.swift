//
//  ImagePickerBundle.swift
//  QuickVideoSwift
//
//  Created by aaron on 2018/11/27.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit


internal struct ImagePickerBundle {
    
    // 当前的bundle
    static var bundle: Bundle {
        let bundle = Bundle(for: AddVideoViewController.self)
        return bundle
    }
    
    // 存放资源的bundle
    static var wclBundle: Bundle {
        let bundle = Bundle(path: self.bundle.path(forResource: "QuickVideoSwift", ofType: "bundle")!)
        return bundle!
    }
    
    static func imageFromBundle(_ imageName: String) -> UIImage? {
        var imageName = imageName
        if UIScreen.main.scale == 2 {
            imageName = imageName + "@2x"
        }else if UIScreen.main.scale == 3 {
            imageName = imageName + "@3x"
        }
        let bundle = Bundle(path: wclBundle.bundlePath + "/Images")
        if let path = bundle?.path(forResource: imageName, ofType: "png") {
            let image = UIImage(contentsOfFile: path)
            return image
        }
        return nil
    }
    
    static func localizedString(key: String) -> String {
        if let current = Locale.current.languageCode {
            var language = ""
            switch current {
            case "zh":
                language = "zh"
            default:
                language = "en"
            }
            if let path = wclBundle.path(forResource: language, ofType: "lproj") {
                if let bundle = Bundle(path: path) {
                    let value = bundle.localizedString(forKey: key, value: nil, table: nil)
                    return Bundle.main.localizedString(forKey: key, value: value, table: nil)
                }
            }
        }
        return key
    }
}
