//
//  AppDelegate.swift
//  Todoey
//
//  Created by Cooper Bossert on 4/22/19.
//  Copyright © 2019 Cooper Bossert. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //Gets called when app is loaded. First thing that happens, before viewDidLoad
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    //Lazy will only get loaded with a value at the timepoint when it's needed, ie when it's used
    //NSPersistentContainer is where we will store all of our data
    //Default persistent container is going to be a SequalLite Database
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    //Support to saving our data when the app gets terminated
    func saveContext () {
        //Context is an area where you can change and update your data (undo/redo) until you're happy, then save. It's a temporary area. The container is for permanent story
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

