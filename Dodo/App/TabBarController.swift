//
//  TapBar.swift
//  Dodo
//
//  Created by Rishat Zakirov on 07.08.2024.
//

import UIKit
class TabBarController: UITabBarController {
    let menuViewController: MenuViewController = {
        let controller = di.screenFactory.makeMenuScreen()
        let tabItem = UITabBarItem(
            title: "Меню",
            image: UIImage(systemName: "menucard"),
            selectedImage: UIImage(systemName: "menucard.fill")
        )
        controller.tabBarItem = tabItem
        return controller
    }()

    let shoppingCartViewController: CartViewController = {
        let controller = di.screenFactory.makeCartScreen()
        let tabItem = UITabBarItem(title: "Корзина", image: UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))
        controller.tabBarItem = tabItem
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        UITabBar.appearance().tintColor = UIColor.black
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        
        tabBar.standardAppearance = appearance
        viewControllers = [menuViewController, shoppingCartViewController]
    }

}


