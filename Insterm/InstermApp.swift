//
//  InstermApp.swift
//  Insterm
//
//  Created by Yusuke Mori on 2023/11/01.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import Shake

@main
struct InstermApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    private weak var observer: NSObjectProtocol?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Shake SDKの設定
        // プレビュー環境のみ、Shake SDKを実行させない
        var isPreview: Bool { ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" }
        if !isPreview {
            Shake.configuration.setShowIntroMessage = true
            Shake.configuration.isCrashReportingEnabled = true
            Shake.configuration.isAskForCrashDescriptionEnabled = true
            
            let clientId = Bundle.main.object(forInfoDictionaryKey: "SHAKE_CLIENT_ID") as? String ?? ""
            let clientSecret = Bundle.main.object(forInfoDictionaryKey: "SHAKE_CLIENT_SECRET") as? String ?? ""
            
            if clientId.isEmpty || clientSecret.isEmpty {
                print("Warning: Shake SDK credentials are missing. Using test credentials.")
            }
            
            Shake.start(clientId: clientId, clientSecret: clientSecret)
            
            print("Shake SDK initialized with clientId: \(clientId) and clientSecret: \(clientSecret)")
        }
        
        // ATT許可リクエスト
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.requestTrackingAuthorization()
        }
        
        return true
    }
    
    // ATT許可をリクエストする関数
    private func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { status in
            // AdMob SDKの初期化
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
    }
}
