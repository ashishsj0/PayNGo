//
//  MainTabBarController.swift
//  PAY & GO
//
//  Created by Ashish sharma on 07/02/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

     @IBInspectable var defaultIndex: Int = 1
    
    var manager: CoreDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CoreDataManager.sharedManager
        selectedIndex = defaultIndex
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        
        guard let window = UIApplication.shared.keyWindow else {
            
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = window.safeAreaInsets.bottom + 60
        return sizeThatFits
    }
}
