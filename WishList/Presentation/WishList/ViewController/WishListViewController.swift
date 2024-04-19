//
//  WishListViewController.swift
//  WishList
//
//  Created by 박현렬 on 4/18/24.
//

import UIKit
import CoreData

class WishListViewController: UIViewController{
    
    @IBOutlet weak var wishListTableView: UITableView!
    
    var persistentContainer: NSPersistentContainer?
    var products: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        wishListTableView.dataSource = self
        wishListTableView.delegate = self
        
        fetchProducts()
    }
    
    func fetchProducts() {
        guard let context = persistentContainer?.viewContext else { return }
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "SelectProduct")
        
        do {
            products = try context.fetch(fetchRequest)
            
            // 상품 정보 출력
            for product in products {
                print("Product ID: \(product.value(forKey: "id") ?? "")")
                print("Title: \(product.value(forKey: "title") ?? "")")
                print("Price: \(product.value(forKey: "price") ?? 0)")
                print("Discount Percentage: \(product.value(forKey: "discountPercentage") ?? 0)")
                print("Thumbnail URL: \(product.value(forKey: "thumbnail") ?? "")")
                print("------------------------")
            }
            print(products.count)
            wishListTableView.reloadData()
        } catch {
            print("Failed to fetch products: \(error)")
        }
    }
}
extension WishListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedProductCell", for: indexPath) as? SelectedProductCell else {
            print("Failed to dequeue SelectedProductCell")
            return UITableViewCell()
        }
        print("cellForRowAt")
        
        let product = products[indexPath.row]
        cell.configure(with: product)
        
        return cell
    }
}
