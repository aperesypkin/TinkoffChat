//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 20.09.2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var applicationState: String {
        return UIApplication.shared.applicationState.string
    }
    
    override init() {
        super.init()
        // Включаем/выключаем логирование жизненного цикла приложения и контроллеров
        LogManager.shared.isEnabled = true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        LogManager.shared.logAppDelegateLifecycle(#function, state: applicationState)
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        LogManager.shared.logAppDelegateLifecycle(#function, state: applicationState)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        LogManager.shared.logAppDelegateLifecycle(#function, state: applicationState)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        LogManager.shared.logAppDelegateLifecycle(#function, state: applicationState)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        LogManager.shared.logAppDelegateLifecycle(#function, state: applicationState)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        LogManager.shared.logAppDelegateLifecycle(#function, state: applicationState)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        LogManager.shared.logAppDelegateLifecycle(#function, state: applicationState)
    }
    
}
