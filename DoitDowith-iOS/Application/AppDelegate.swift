//
//  AppDelegate.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/20.
//

import UIKit

import RealmSwift
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let config = Realm.Configuration(
                schemaVersion: 2, // 새로운 스키마 버전 설정
                migrationBlock: { migration, oldSchemaVersion in
                    if oldSchemaVersion < 2 {
                        // 1-1. 마이그레이션 수행(버전 2보다 작은 경우 버전 2에 맞게 데이터베이스 수정)
                        migration.enumerateObjects(ofType: ChatRoom.className()) { oldObject, newObject in
                            newObject!["image"] = ""
                        }
                    }
                }
            )
            
            // 2. Realm이 새로운 Object를 쓸 수 있도록 설정
            Realm.Configuration.defaultConfiguration = config
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    KakaoSDK.initSDK(appKey: "04d5bc7b6ebcb848ff8a9aabc924a1a6")
    window.rootViewController = LoginViewController()
     if(AuthApi.hasToken()) {
       UserApi.shared.accessTokenInfo { info, error in
         if let error = error,
            let sdkError = error as? SdkError, sdkError.isInvalidTokenError() {
           window.rootViewController = LoginViewController()
         } else {
           let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
           let vc = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
           vc.modalPresentationStyle = .fullScreen
           window.rootViewController = vc
         }
       }
     }
    window.makeKeyAndVisible()
    self.window = window
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

