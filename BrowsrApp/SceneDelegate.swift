//
//  SceneDelegate.swift
//  BrowsrApp
//
//  Created by Sunil Zishan on 24.07.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = OrganizationsViewController()
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UINavigationController(rootViewController: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

