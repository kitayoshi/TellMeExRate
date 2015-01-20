//
//  MainTabController.swift
//  tellmeexrate
//
//  Created by 乱序 on 15/1/19.
//  Copyright (c) 2015年 乱序. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        let mainColor = UIColor(red: 59.0 / 255.0, green: 170.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
        self.tabBar.tintColor = mainColor
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        
//        seC.standardCurrency = exC.standardCurrency;
    }

}
