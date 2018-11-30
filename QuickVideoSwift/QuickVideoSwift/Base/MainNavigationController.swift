//
//  MainNavigationController.swift
//  QuickVideoSwift
//
//  Created by aaron on 2018/11/26.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController,UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
    }
    
    fileprivate func setNavBar() {
        navigationBar.setBackgroundImage(UIImage.init(color:BlueColor), for: .default)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.init(fontName: kMedFont, size: 19)]
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count < 1 {
            viewController.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: nil, action: nil)
        }
        else{
            
            viewController.hidesBottomBarWhenPushed = true
            navigationBar.backIndicatorImage = LoadImage("iconBack").withRenderingMode(.alwaysOriginal)
            
            //返回按钮文字的颜色
            navigationBar.tintColor = UIColor.white
            
            // 设置返回手势
            interactivePopGestureRecognizer?.isEnabled = true
            interactivePopGestureRecognizer?.delegate = self
            
        }
        super.pushViewController(viewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

