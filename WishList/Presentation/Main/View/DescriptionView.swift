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
    
    let nextButton = UIButton().then {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Next"
        configuration.image = UIImage(systemName: "chevron.forward.circle.fill")
        configuration.imagePadding = 10 // 이미지와 타이틀 사이의 간격 조정
        configuration.imagePlacement = .trailing // 이미지를 타이틀의 앞에 배치
        configuration.baseBackgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.69, alpha: 1.00)
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .capsule
        
        // titleTextAttributesTransformer를 사용하여 타이틀의 글꼴 설정
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .boldSystemFont(ofSize: 20)
            return outgoing
        }
        
        $0.configuration = configuration
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        layer.cornerRadius = 16
    }
    
    func setupUI() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(nextButton)
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(32)
            $0.trailing.equalToSuperview().offset(-32)
        }
        
        descriptionLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(32)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        nextButton.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-32)
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(50)
        }
    }
    
    func configure(with title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
