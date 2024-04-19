//
//  ViewController.swift
//  WishList
//
//  Created by 박현렬 on 4/15/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var productImageCollection: UICollectionView!
    @IBOutlet weak var descriptionView: DescriptionView!
    @IBOutlet weak var buttonView: BottomView!
    
    var productionId = 1
    
    var productData: RemoteProduct? {
        didSet {
            DispatchQueue.main.async {
                // 애니메이션 옵션 설정
                let options: UIView.AnimationOptions = [.transitionCrossDissolve, .allowUserInteraction]
                // 애니메이션 적용
                UIView.transition(with: self.view, duration: 0.3, options: options, animations: {
                    // 애니메이션이 필요한 UI 업데이트 코드 작성
                    self.productImageCollection.reloadData()
                    self.descriptionView.configure(with: self.productData?.title ?? "", description: self.productData?.description ?? "")
                    self.buttonView.updatePriceTitle("\(self.productData?.price ?? 0)")
                }, completion: nil)
                
            }
        }
    }
    
    var persistentContainer: NSPersistentContainer? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.persistentContainer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = productImageCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        productImageCollection.isPagingEnabled = true
        productImageCollection.dataSource = self
        productImageCollection.delegate = self
        
        fetchProductData(id: productionId)
        descriptionView.nextButton.addTarget(self, action: #selector(nextProduction), for: .touchUpInside)
        buttonView.addCartButton.addTarget(self, action: #selector(addWishList), for: .touchUpInside)
        
        // 장바구니 버튼 생성
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(cartButtonTapped))
        
        // 장바구니 버튼을 Navigation Bar의 오른쪽에 추가
        navigationItem.rightBarButtonItem = cartButton
    }
    
    func fetchProductData(id: Int){
        // Get product with id
        ProductAPIManager.shared.fetchProduct(id: id) { result in
            switch result {
            case .success(let product):
                // product 인스턴스를 사용하여 작업 수행
                print(product)
                self.productData = product
            case .failure(let error):
                // 에러 처리
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func nextProduction(){
        self.productionId += 1
        fetchProductData(id: productionId)
    }
    
    @objc func addWishList(){
        print("Add to WishList")
        saveCoreData(self.productData!)
    }
    
    @objc func cartButtonTapped() {
        // 장바구니 버튼을 탭했을 때 수행할 동작 구현
        print("장바구니 버튼이 탭되었습니다.")
        guard let wishListViewController = UIStoryboard(name: "WishList", bundle: nil).instantiateViewController(withIdentifier: "WishList") as? WishListViewController else {
            return
        }
        
        self.present(wishListViewController, animated: true)
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

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productData?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as? ProductImageCell else {
            print("Failed to dequeue ProductImageCell")
            return UICollectionViewCell()
        }
        guard let productData = self.productData else {
            print("productData is nil")
            return UICollectionViewCell()
        }
        cell.configure(with: productData.images[indexPath.item])
        return cell
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 원하는 셀의 크기를 반환합니다.
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
