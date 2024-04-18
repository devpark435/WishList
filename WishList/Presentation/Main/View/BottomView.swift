//
//  BottomView.swift
//  WishList
//
//  Created by 박현렬 on 4/18/24.
//

import UIKit
import SnapKit
import Then

class BottomView: UIView{
    
    let addCartButton = UIButton().then {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Add to Cart"
        configuration.image = UIImage(systemName: "cart.fill.badge.plus")
        configuration.imagePadding = 10 // 이미지와 타이틀 사이의 간격 조정
        configuration.imagePlacement = .leading // 이미지를 타이틀의 앞에 배치
        configuration.baseBackgroundColor = .systemBlue
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
        configuration.baseBackgroundColor = .systemBlue
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
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
            $0.width.equalToSuperview().multipliedBy(0.6)
        }
        priceButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview()
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
