//
//  AppDelegate.swift
//  AstroZen
//
//  Created by Cypto Beast on 25/03/2024.
//

import UIKit
import CoreData
import FirebaseCore
import GoogleMobileAds


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // Punto de entrada de la aplicación
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Configura Firebase
        FirebaseApp.configure()

        // Configura Google Ads
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        // Verifica si el usuario ya completó el walkthrough usando UserDefaults
        let defaults = UserDefaults.standard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if !defaults.bool(forKey: "hasCompletedWalkthrough") {
            // Si es la primera vez que abre la app, muestra el Walkthrough
            let walkthroughVC = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
            window?.rootViewController = walkthroughVC
            window?.makeKeyAndVisible()
        } else {
            // Si ya completó el walkthrough, muestra el TabBarController
            let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            window?.rootViewController = tabBarVC
            window?.makeKeyAndVisible()
        }

        return true
    }
    
    // Esta función se llama cuando el walkthrough se completa
    func walkthroughCompleted() {
        // Guarda en UserDefaults que el walkthrough ha sido completado
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "hasCompletedWalkthrough")
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
    
    // MARK: - Core Data stack

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AstroZen")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    
//    var window: UIWindow?
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
//        // Si no es la primera vez manda al home
//                let vControllerRoot = UIStoryboard(name: "Main", bundle: nil)
//                let homeVC = vControllerRoot.instantiateViewController(withIdentifier: "HomeViewController")
//                let defaults = UserDefaults.standard
//       
//        // Verifica si es la primera vez que el usuario abre la aplicación
//                if !defaults.bool(forKey: "hasCompletedWalkthrough") {
//
//                    showWalkthrough()
//                }else {
//                    window?.rootViewController = homeVC
//                    window?.makeKeyAndVisible()
//                }
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        //Google Ads Mob
//        
//        FirebaseApp.configure()
//        //FireBase
//    
//        return true
//    }
//    
//    func showWalkthrough() {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let walkthroughVC = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
//            
//            // Configurar la ventana de la aplicación para que el walkthrough sea el controlador de vista inicial
//            window?.rootViewController = walkthroughVC
//            window?.makeKeyAndVisible()
//        }
//        
//        // Función para establecer el indicador de UserDefaults una vez que el usuario haya completado el walkthrough
//        func walkthroughCompleted() {
//            let defaults = UserDefaults.standard
//            defaults.set(true, forKey: "hasCompletedWalkthrough")
//        }
    

//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//
//    // MARK: - Core Data stack
//
//    var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "AstroZen")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                 
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//func saveContext () {
//    let context = persistentContainer.viewContext
//    if context.hasChanges {
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//    }
//}



