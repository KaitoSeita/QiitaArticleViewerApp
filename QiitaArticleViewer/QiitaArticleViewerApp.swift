//
//  QiitaArticleViewerApp.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/12.
//

import SwiftUI

@main
struct QiitaArticleViewerApp: App {
    
    @UIApplicationDelegateAdaptor (AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            TopTabView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private func storeCookies() {
        guard let cookies = HTTPCookieStorage.shared.cookies else { return }
        var cookieDictionary = [String : AnyObject]()
        for cookie in cookies {
            cookieDictionary[cookie.name] = cookie.properties as AnyObject?
        }
        UserDefaults.standard.set(cookieDictionary, forKey: "cookie")
    }
    
    private func retrieveCookies() {
        guard let cookieDictionary = UserDefaults.standard.dictionary(forKey: "cookie") else { return }
        for (_, cookieProperties) in cookieDictionary {
            if let cookieProperties = cookieProperties as? [HTTPCookiePropertyKey : Any] {
                if let cookie = HTTPCookie(properties: cookieProperties ) {
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        retrieveCookies()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        storeCookies()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        storeCookies()
    }
}
