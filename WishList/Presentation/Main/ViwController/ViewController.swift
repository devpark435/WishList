//
//  ViewController.swift
//  WishList
//
//  Created by 박현렬 on 4/15/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ProductAPIManager.shared.fetchProduct(id: 1) { result in
            switch result {
            case .success(let product):
                // product 인스턴스를 사용하여 작업 수행
                print(product)
            case .failure(let error):
                // 에러 처리
                print(error.localizedDescription)
            }
        }
    }


}

