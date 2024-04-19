//
//  PayButtonView.swift
//  WishList
//
//  Created by 박현렬 on 4/19/24.
//

import UIKit
import SnapKit
import Then

class PayButtonView: UIView{
    
    let addCartButton = UIButton().then {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Payment"
        configuration.image = UIImage(systemName: "creditcard.circle.fill")
        configuration.imagePadding = 10 // 이미지와 타이틀 사이의 간격 조정
        configuration.imagePlacement = .leading // 이미지를 타이틀의 앞에 배치
        configuration.baseBackgroundColor = UIColor(red: 0.07, green: 0.18, blue: 0.31, alpha: 1.00)
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
    
    let priceButton = UIButton().then {
        var configuration = UIButton.Configuration.filled()
        configuration.title = ""
        configuration.image = UIImage(systemName: "dollarsign.circle.fill")
        configuration.imagePadding = 10 // 이미지와 타이틀 사이의 간격 조정
        configuration.imagePlacement = .leading
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
        
        setUI()
    }
    
    func setUI(){
        addSubview(addCartButton)
        addSubview(priceButton)
        
        addCartButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-32)
            $0.bottom.equalToSuperview().offset(-16)
            $0.width.equalToSuperview().multipliedBy(0.45)
        }
        priceButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(32)
            $0.bottom.equalToSuperview().offset(-16)
            $0.trailing.equalTo(addCartButton.snp.leading).offset(-8)
        }
    }
    
    func updatePriceTitle(_ price: String) {
        guard var configuration = priceButton.configuration else {
            return
        }
        
        configuration.title = price
        priceButton.configuration = configuration
    }
}

