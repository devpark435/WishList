//
//  WishListViewController.swift
//  WishList
//
//  Created by 박현렬 on 4/18/24.
//

import UIKit
import CoreData
import SnapKit
import Then

class WishListViewController: UIViewController{
    
    @IBOutlet weak var wishListTableView: UITableView!
    @IBOutlet weak var payButtonView: PayButtonView!
    
    var persistentContainer: NSPersistentContainer?
    var products: [NSManagedObject] = []
    
    var totalDiscountedPrice: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        wishListTableView.dataSource = self
        wishListTableView.delegate = self
        
        fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        totalDiscountedPrice = 0.0
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
        
        totalDiscountedPrice += cell.discountedPrice
        payButtonView.updatePriceTitle((String(format: "%.2f", totalDiscountedPrice)))
        
        return cell
    }
    
    // 셀 삭제 시 코어 데이터에서 해당 내용 삭제하는 메서드 추가
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            // 삭제 작업 수행
            let product = self.products[indexPath.row]
            self.deleteProduct(product)
            self.products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            completionHandler(true)
        }
        
        // 삭제 버튼의 배경색 변경
        deleteAction.backgroundColor = UIColor(red: 0.07, green: 0.18, blue: 0.31, alpha: 1.00)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    // 코어 데이터에서 상품 삭제하는 메서드
    func deleteProduct(_ product: NSManagedObject) {
        guard let context = persistentContainer?.viewContext else { return }
        context.delete(product)
        
        do {
            try context.save()
            print("Product deleted from Core Data")
        } catch {
            print("Failed to delete product: \(error)")
        }
    }
}

