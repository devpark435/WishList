//
//  ViewController.swift
//  WishList
//
//  Created by 박현렬 on 4/15/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var persistentContainer: NSPersistentContainer? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.persistentContainer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get product with id
        ProductAPIManager.shared.fetchProduct(id: 1) { result in
            switch result {
            case .success(let product):
                // product 인스턴스를 사용하여 작업 수행
                print(product)
                DispatchQueue.main.async {
                    self.saveCoreData(product)
                }
            case .failure(let error):
                // 에러 처리
                print(error.localizedDescription)
            }
        }
        
    }
    
    func saveCoreData(_ product: RemoteProduct) {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        // Create a new managed object for the Product entity
        let productEntity = NSEntityDescription.entity(forEntityName: "SelectProduct", in: context)!
        let productObject = NSManagedObject(entity: productEntity, insertInto: context)
        
        // Set the properties of the managed object with the API data
        productObject.setValue(product.id, forKey: "id")
        productObject.setValue(product.title, forKey: "title")
        productObject.setValue(product.price, forKey: "price")
        productObject.setValue(product.discountPercentage, forKey: "discountPercentage")
        productObject.setValue(product.thumbnail, forKey: "thumbnail")
        
        // Save the changes to the managed object context
        do {
            try context.save()
            print("Product saved to Core Data")
            printCoreData()
        } catch {
            print("Failed to save product: \(error)")
        }
    }
    
    func printCoreData(){
        guard let context = self.persistentContainer?.viewContext else { return }
        let request = SelectProduct.fetchRequest()
        if let products = try? context.fetch(request) {
            print(products)
        }
    }

}

