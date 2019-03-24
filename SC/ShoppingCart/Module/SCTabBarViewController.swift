//
//  SCTabBarViewController.swift
//  ShoppingCart
//
//  Created by lujianqiao on 2019/3/11.
//  Copyright © 2019 NGY. All rights reserved.
//

import UIKit

class SCTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setChildVC()

        // Do any additional setup after loading the view.
    }
    
    func setChildVC() -> Void {
        addchildVC(childVC: HomeViewController(), "首页", "sy_home", "sy_home_b")
        addchildVC(childVC: ShoppingCartViewController(), "购物车", "sy_car", "sy_car_b")
    }
    
    func addchildVC(childVC: UIViewController,_ title:String, _ image: String, _ HightlightImage: String) -> Void {
        
        childVC.title = title;
        childVC.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.selectedImage = UIImage(named: HightlightImage)?.withRenderingMode(.alwaysOriginal)
        let naviVC = UINavigationController(rootViewController: childVC)
        addChild(naviVC)
        
    }


}
