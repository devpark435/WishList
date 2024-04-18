//
//  DescriptionView.swift
//  WishList
//
//  Created by 박현렬 on 4/17/24.
//

import UIKit

class DescriptionView: UIView{
    
    let descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        descriptionLabel.text = "adfasdfasfasdfasdfa"
    }
    
    func setupUI() {
        addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with description: String) {
        descriptionLabel.text = description
    }
}
