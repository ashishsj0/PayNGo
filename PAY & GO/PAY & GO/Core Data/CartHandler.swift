//
//  CartHandler.swift
//  PAY & GO
//
//  Created by Ashish sharma on 07/02/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import Foundation
import CoreData

// further delegates to handle updates.

protocol CoreDataManagerDelegate {
    func cartUpdated(withProduct: Product)
    func cartCleared()
}

// Core data manager class to local storage

class CoreDataManager: NSObject {
    
    var delegate: CoreDataManagerDelegate?
    
    static let sharedManager = CoreDataManager.init()
    
    private override init() {
    }
    
    lazy var persistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Cart")
        
        container.loadPersistentStores(completionHandler: { (NSPersistentStoreDescription, error) in
            
            if let foundError = error as NSError? {
                print(foundError)
            }
        })
        return container
    }()
    
    func saveContext(){
        
        let context = CoreDataManager.sharedManager.persistantContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
            }
        }
    }
    
    // Inserting products to database
    
    func insertProduct(product: Product) {
        
        let managedContext = CoreDataManager.sharedManager.persistantContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Cart", in: managedContext)
        
        let newProduct = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        newProduct.setValue(product.productBarCode, forKey: "productBarCode")
        newProduct.setValue(product.productName, forKey: "productName")
        newProduct.setValue(product.productImage, forKey: "productImage")
        
        newProduct.setValue(1, forKey: "count")
        
        do {
            try managedContext.save()
            self.delegate?.cartUpdated(withProduct: product)
        }
        catch {
            if let error = error as? NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func getCartFromDB() -> [NSManagedObject] {
        
        let managedContext = CoreDataManager.sharedManager.persistantContainer.viewContext
        
        let cartFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        cartFetch.returnsObjectsAsFaults = false
        
        do {
            guard let cartResult = try managedContext.fetch(cartFetch) as? [NSManagedObject]
                else {
                    return [] }
            return cartResult
            } catch {
            fatalError("Failed to fetch products: \(error)") }}
    
    // getting cart count
    
    func getCartCount() -> Int {
        
        let managedContext = CoreDataManager.sharedManager.persistantContainer.viewContext
        
        let fetchRequestSender = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        fetchRequestSender.returnsObjectsAsFaults = false
        
        do {
            guard let result = try managedContext.fetch(fetchRequestSender) as? [NSManagedObject] else { return 0 }
            
            if result.isEmpty {
                return 0 }
            else {
                
                var count = 0
                
                for res in result {
                    guard let countx = res.value(forKey: "count") as? Int else {
                        return 0
                    }
                    count += countx
                }
                return count
            }}
        catch {
        }
        return 0 }
    
    // emptying the cart
    
    func clearCart(){
        
        let managedContext = CoreDataManager.sharedManager.persistantContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try managedContext.execute(request)
            self.delegate?.cartCleared()
        } catch {
            print("could not delete")
        }
    }
}

