//
//  MainTabarController.swift
//  QuickVideoSwift
//
//  Created by aaron on 2018/11/26.
//  Copyright © 2018年 aaron. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainTabarController: UITabBarController {
    
    lazy var vcs = [UIViewController]()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        //添加子控制器
        addChildController()
        //设置tabBar
        setupTabBar()
        //设置tabBarItem的文字属性
        setUpTabbarItemTextAttributes()
        selectedIndex = 0
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: (self.view.frame.size.width-40)/2, y: 5, width: 40, height: 40)
        button.setImage(UIImage.init(named: "icon_bottom_add"), for: .normal)
        
        self.tabBar.addSubview(button)
        
        button.rx.tap.subscribe(onNext: { [weak self] in
            
            let addVideoVc = MainNavigationController.init(rootViewController: AddVideoViewController())
            
            self?.present(addVideoVc, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
        
    }
    
    fileprivate func addChildController() {
        
        let arr = TaBarModel.comfirmTabarInformationArray()
        let childVcs = TaBarModel.comfirmTabarControllerArray()
        
        for index in 0..<arr.count {
            let model = arr[index]
            let vc = childVcs[index]
            vc.tabBarItem.title = model.title
            vc.tabBarItem.image = LoadImage(model.normalImageName).withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = LoadImage(model.selectImageName).withRenderingMode(.alwaysOriginal)
            addChild(vc)
        }
    }
    
    fileprivate func setupTabBar() {
        //tabbar backgroundColor
        UITabBar.appearance().barTintColor = RGBA(r: 255, g: 255, b: 255, a: 0.9)
        //tabbar的分割线的颜色
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        dropShadow(Offset: CGSize.init(width: 0, height: -0.4), radius: 2, color: RGBA(r: 0, g: 0, b: 0, a: 0.25), opacity: 1.0)
    }
    
    fileprivate func dropShadow(Offset offset:CGSize, radius:CGFloat, color:UIColor, opacity:CGFloat) {
        let pathRef = CGMutablePath.init()
        pathRef.addRect(self.tabBar.bounds)
        tabBar.layer.shadowPath = pathRef;
        pathRef.closeSubpath()
        
        tabBar.layer.shadowColor = color.cgColor
        tabBar.layer.shadowOffset = offset
        tabBar.layer.shadowRadius = radius
        tabBar.layer.shadowOpacity = Float(opacity)
        tabBar.clipsToBounds = false
        
    }
    
    //设置tabBarItem的文字属性
    fileprivate func setUpTabbarItemTextAttributes() {
        //普通状态下的文字属性
        var normalAttrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key: Any]()
        normalAttrs[kCTForegroundColorAttributeName as NSAttributedString.Key] = COLOR(red: 152, green: 152, blue: 156)
        normalAttrs[kCTFontAttributeName as NSAttributedString.Key] = UIFont.init(fontName: kRegFont, size: 10)
        //选中状态下的文字属性
        var selectedAttrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key: Any]()
        normalAttrs[kCTForegroundColorAttributeName as NSAttributedString.Key] = BlueColor
        normalAttrs[kCTFontAttributeName as NSAttributedString.Key] = UIFont.init(fontName: kRegFont, size: 10)
        
        
        let tabbarItem = UITabBarItem.appearance()
        tabbarItem.setTitleTextAttributes(normalAttrs, for:.normal)
        tabbarItem.setTitleTextAttributes(selectedAttrs, for: .selected)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class TaBarModel: NSObject {
    
    var title:String = ""
    var normalImageName:String = ""
    var selectImageName:String = ""
    
    class func comfirmModel(Title title:String,NormalImageName normalImageName:String,SelectImageName selectImageName:String) ->TaBarModel{
    
        let model = TaBarModel()
        model.title = title
        model.normalImageName = normalImageName
        model.selectImageName = selectImageName
        
        return model;
    }
    
    class func comfirmTabarInformationArray() -> [TaBarModel]{
        let works = comfirmModel(Title: "作品", NormalImageName: "iconSqaureDefault", SelectImageName: "iconSqaureDefaultPre")
        let addVideo = comfirmModel(Title: "", NormalImageName: "iconTabbarShopping", SelectImageName: "iconTabbarShoppingPre")
        
        let mine = comfirmModel(Title: "我的", NormalImageName: "iconTabbarMine", SelectImageName: "iconTabbarMinePre")
        
        return [works,addVideo,mine]
    }
    
    class func comfirmTabarControllerArray() -> [MainNavigationController]{
        
        let worksVc = MainNavigationController.init(rootViewController: WorksViewController())
        let addVideoVc = MainNavigationController.init(rootViewController: UIViewController())
        let mineVc = MainNavigationController.init(rootViewController: MineViewController())
        
        return [worksVc,addVideoVc,mineVc]
        
    }
    
}
