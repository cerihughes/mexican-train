//
//  AppDelegate.swift
//  MexicanTrain
//
//  Created by Home on 09/05/2020.
//

import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var ui: MexicanTrainUI?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.makeKeyAndVisible()

        #if DEBUG
        if isRunningUnitTests {
            window.rootViewController = UIViewController()
            return true
        }
        #endif

        FirebaseApp.configure()
        let ui = MexicanTrainUI(window: window)
        self.ui = ui
        return ui.showInitialUI()
    }
}

#if DEBUG
extension UIApplicationDelegate {
    var isRunningUnitTests: Bool {
        return UserDefaults.standard.bool(forKey: "isRunningUnitTests")
    }
}
#endif
