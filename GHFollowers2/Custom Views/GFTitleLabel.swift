//
//  GFTitleLabel.swift
//  GHFollowers2
//
//  Created by Samet KATI on 15.05.2024.
//

import UIKit

class GFTitleLabel: UILabel {
    
    /// Bu bizim üst classdan aldığımız init fonksiyonu burada yapılan işlem ilk yüklendiğinde ne olacağını belirlemek
    /// - Parameter frame: <#frame description#>
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    /// Bu da klasik constructor buradaki parametrelere göre Labelımızı oluşturabiliriz
    init(textAlignment : NSTextAlignment , fontSize : CGFloat){
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font  = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    
    /// Bu da bazı özellikleri verdiğimiz fonksiyon
    private func configure(){
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
