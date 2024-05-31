//
//  GFItemInfoView.swift
//  GHFollowers2
//
//  Created by Samet KATI on 30.05.2024.
//

import UIKit

// Kullanılacak bilgi türlerini tanımlayan enum
enum ItemInfoType {
    case repos, gists, followers, following
}

// GFItemInfoView sınıfı, UIView'den miras alır ve belirli kullanıcı bilgilerini göstermek için özelleştirilmiştir
class GFItemInfoView: UIView {

    // Görüntü göstermek için UIImageView
    let symbolImageView = UIImageView()
    // Başlık etiketini göstermek için özel bir UILabel
    let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
    // Sayı etiketini göstermek için özel bir UILabel
    let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)

    // Standart init metodu
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    // Interface Builder'dan başlatma işlemi desteklenmiyor
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // Alt görünümleri yapılandıran özel yöntem
    private func configure() {
        // Görünümleri ana görünüme ekle
        addSubview(symbolImageView)
        addSubview(titleLabel)
        addSubview(countLabel)
        
        // Autolayout kullanımı için çevirileri kapat
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        // Görüntü modunu ayarla
        symbolImageView.contentMode = .scaleAspectFill
        // Görüntü rengi sistemin yazı rengi ile aynı olsun
        symbolImageView.tintColor = .label
        
        // Otomatik yerleşim kuralları
        NSLayoutConstraint.activate([
            // symbolImageView'ın üst kenarını ve sol kenarını ana görünüme bağla, genişlik ve yükseklik belirle
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // titleLabel'ın dikey merkezini symbolImageView ile hizala, sol kenarını symbolImageView'ın sağ kenarına bağla, sağ kenarını ana görünüme bağla ve yükseklik belirle
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            // countLabel'ın üst kenarını symbolImageView'ın alt kenarına bağla, sol ve sağ kenarlarını ana görünüme bağla ve yükseklik belirle
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    // Bilgi türüne göre görüntüyü ve başlığı ayarlayan yöntem
    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        // Bilgi türüne göre farklı görüntü ve başlık belirle
        switch itemInfoType {
        case .repos:
            symbolImageView.image = UIImage(systemName: SFSymbols.repos)
            titleLabel.text = "Public Repos"
        case .gists:
            symbolImageView.image = UIImage(systemName: SFSymbols.gists)
            titleLabel.text = "Public Gists"
        case .followers:
            symbolImageView.image = UIImage(systemName: SFSymbols.followers)
            titleLabel.text = "Followers"
        case .following:
            symbolImageView.image = UIImage(systemName: SFSymbols.following)
            titleLabel.text = "Following"
        }
        // Sayı etiketini ayarla
        countLabel.text = String(count)
    }
}

