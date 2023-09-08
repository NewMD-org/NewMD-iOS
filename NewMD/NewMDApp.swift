//
//  NewMDApp.swift
//  NewMD
//
//  Created by Haco on 2023/9/5.
//

import SwiftUI
import UserNotifications

@main
struct NewMDApp: App {
//    @UIApplicationDelegateAdaptor(NotificationDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//class NotificationDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//        print("Device Token: \(tokenString)")
//        // 這裡你可以將 device token 傳送到你的伺服器
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to get device token: \(error)")
//    }
//}
