//
//  ProductImageCell.swift
//  WishList
//
//  Created by 박현렬 on 4/17/24.
//

import UIKit
import SnapKit
import Then

class ProductImageCell: UICollectionViewCell {
    
    let productImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(productImageView)
//        contentView.snp.makeConstraints{
//            $0.width.equalTo(300)
//            $0.height.equalTo(100)
//        }
        productImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(250)
        }
    }
    
    func configure(with imageURL: URL) {
        URLSession.shared.dataTask(with: imageURL) { [weak self] (data, response, error) in
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

