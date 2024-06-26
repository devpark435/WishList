//
//  SelectedProductCell.swift
//  WishList
//
//  Created by 박현렬 on 4/18/24.
//

import UIKit
import SnapKit
import Then
import CoreData

class SelectedProductCell: UITableViewCell{
    
    let productImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
    }
    
    let productNameLabel = UILabel().then {
        $0.text = "hi"
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    let productPriceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
    }
    
    let productDiscountLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 17)
    }
    
    var id = 0
    
    var discountedPrice = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
        // 가로줄 추가
        let attributeString = NSMutableAttributedString(string: "원래 가격")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        productPriceLabel.attributedText = attributeString
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil // 셀 재사용 시 이미지 초기화
    }
    
    func setUI(){
        addSubview(productImageView)
        addSubview(productNameLabel)
        addSubview(productPriceLabel)
        addSubview(productDiscountLabel)
        
        productImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(100)
            $0.bottom.equalToSuperview().offset(-16)
        }
        productNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(productImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
        }
        productPriceLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
        }
        productDiscountLabel.snp.makeConstraints {
            $0.top.equalTo(productPriceLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func configure(with product: NSManagedObject) {
        productImageView.image = nil
        productNameLabel.text = product.value(forKey: "title") as? String
        
        if let id = product.value(forKey: "id") as? Int {
            self.id = id
        }
        
        if let price = product.value(forKey: "price") as? Double {
            productPriceLabel.text = "\(price)$"
            if let discount = product.value(forKey: "discountPercentage") as? Double {
                let discountedPrice = price * (1 - discount / 100)
                productDiscountLabel.text = "\(String(format: "%.2f", discountedPrice))$"
                self.discountedPrice = discountedPrice
            }
        }
        
        
        
        if let thumbnailURL = product.value(forKey: "thumbnail") as? URL {
            URLSession.shared.dataTask(with: thumbnailURL) { [weak self] (data, response, error) in
                guard let self = self else { return }
                
                if let error = error {
                    // 에러 처리
                    print("Error loading image: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    // 데이터 또는 이미지 변환 실패 처리
                    print("Invalid image data")
                    return
                }
                
                // 메인 스레드에서 UI 업데이트
                DispatchQueue.main.async {
                    print("Image loaded: \(image)")
                    self.productImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
