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
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil // 셀 재사용 시 이미지 초기화
    }
    
    func configure(with imageURL: URL) {
        productImageView.image = nil
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

