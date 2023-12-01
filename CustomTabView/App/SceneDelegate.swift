//
//  SceneDelegate.swift
//  CustomCollectionViewBar
//
//  Created by Denys Niestierov on 16.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        startRootScreen(for: windowScene)
    }
    
    private func startRootScreen(for windowScene: UIWindowScene) {
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let mainScreen = MainScreen()
        
        window?.rootViewController = mainScreen
        window?.makeKeyAndVisible()
    }
}
