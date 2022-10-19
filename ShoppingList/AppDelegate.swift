//
//  AppDelegate.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/07/19.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
  
         aboutRealmMigration()
        
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

extension AppDelegate {
    func aboutRealmMigration() {
        //MARK: 이전 마이그레이션이 2까지 함
        let config = Realm.Configuration(schemaVersion: 10) { migration, oldSchemaVersion in
            //컬럼 추가
            if oldSchemaVersion < 3 {
                
            }
            
            if oldSchemaVersion < 4 {
                migration.renameProperty(onType: UserTodo.className(), from: "migrationTest", to: "migration")
            }
            
            // 버전이 잘못돼서 안나왔었음
            if oldSchemaVersion < 6 {
                migration.enumerateObjects(ofType: UserTodo.className()) { oldObject, newObject in
                    //
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    new["userDescription"] = "날짜: \(old["todoDate"]!)의 할일은 \(old["todoTitle"]!)입니다."
                }
            }
            
            if oldSchemaVersion < 7 {
                migration.enumerateObjects(ofType: UserTodo.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    
                    new["fix"] = false
                    
                }
            }
            
            if oldSchemaVersion < 8 {
                migration.enumerateObjects(ofType: UserTodo.className()) { oldObject, newObject in
                    
                    guard let new = newObject else {return}
                    guard let old = oldObject else {return}
                    
                    // int를 double로 바꿔주기
                    new["migration"] = old["migration"] ?? 7
                    
                }
               
            }
            
            if oldSchemaVersion < 9 {
                migration.enumerateObjects(ofType: UserTodo.className()) { oldObject, newObject in
                    
                    guard let new = newObject else {return}
                    guard let old = oldObject else {return}
                    
                    // int를 double로 바꿔주기
                    new["userDescription"] = "나는야 마이그레이션쑹쑹쑹쑹"
                    
                }
               
            }
            
            if oldSchemaVersion < 10 {
                migration.enumerateObjects(ofType: UserTodo.className()) { oldObject, newObject in
                    
                    guard let new = newObject else {return}
                    guard let old = oldObject else {return}
                    
                    // int를 double로 바꿔주기
                    if old["migration"] == nil {
                        new["migration"] = 7.0
                    }
                }
            }
        }
        Realm.Configuration.defaultConfiguration = config
     }
}

