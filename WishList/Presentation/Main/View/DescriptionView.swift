//
//  DescriptionView.swift
//  WishList
//
//  Created by 박현렬 on 4/17/24.
//

import UIKit
import SnapKit
import Then
import CoreData

class DescriptionView: UIView{
    
    let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 28)
        $0.textColor = .black
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    let addWishListButton = UIButton().then {
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        $0.setTitle("Add to WishList", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 10
    }
    
    let priceButton = UIButton().then{
        $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemGray
        $0.layer.cornerRadius = 10
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(addWishListButton)
        addSubview(priceButton)
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        descriptionLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        priceButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        addWishListButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(priceButton.snp.leading).offset(-8)
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalTo(50)
        }
    }
    
    func configure(with title: String, description: String, price: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        priceButton.setTitle("\(price)$", for: .normal)
    }
}
