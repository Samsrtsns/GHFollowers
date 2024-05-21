//
//  GFEmptyStateView.swift
//  GHFollowers2
//
//  Created by Samet KATI on 21.05.2024.
//

import UIKit

// GFEmptyStateView adında UIView sınıfından türetilmiş özel bir view tanımlıyoruz.
// Bu view, boş bir durum görüntüsü ve mesaj göstermek için kullanılacak.

class GFEmptyStateView: UIView {
    
    let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    // Mesaj göstermek için bir etiket (label) tanımlıyoruz.
    // GFTitleLabel, önceden tanımlanmış özel bir UILabel sınıfıdır.

    let logoImageView = UIImageView()
    // Logo görüntüsünü göstermek için bir UIImageView tanımlıyoruz.

    override init(frame: CGRect) {
        super.init(frame: frame)
        // UIView'in frame ile başlatıcı metodunu çağırıyoruz.
        configure()
        // View'i yapılandırmak için configure metodunu çağırıyoruz.
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
        // Interface Builder ile başlatma desteklenmiyor.
    }
    
    init(message: String){
        super.init(frame: .zero)
        // View'i çerçevesiz olarak başlatıyoruz.
        messageLabel.text = message
        // Mesaj etiketinin metnini parametrre olarak alınan mesaj ile ayarlıyoruz.
        configure()
        // View'i yapılandırmak için configure metodunu çağırıyoruz.
    }
    
    private func configure(){
        addSubview(messageLabel)
        // messageLabel'i view'e ekliyoruz.
        addSubview(logoImageView)
        // logoImageView'i view'e ekliyoruz.
        
        messageLabel.numberOfLines = 3
        // Mesaj etiketinin satır sayısını 3 olarak ayarlıyoruz.
        messageLabel.textColor = .secondaryLabel
        // Mesaj etiketinin metin rengini ikincil etiket rengi olarak ayarlıyoruz.
        
        logoImageView.image = UIImage(named: "empty-state-logo")
        // logoImageView'in görüntüsünü "empty-state-logo" adlı resim ile ayarlıyoruz.
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        // Auto Layout kısıtlamalarını manuel olarak ayarlayacağımızı belirtiyoruz.
        
        NSLayoutConstraint.activate([
            // Auto Layout kısıtlamalarını aktif hale getiriyoruz.
            
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            // messageLabel'in Y ekseninde view'in merkezine hizalanmasını sağlıyoruz,
            // ve 150 puan yukarı kaydırıyoruz.
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            // messageLabel'in sol kenarını view'in sol kenarına 40 puan uzaklıkta hizalıyoruz.
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            // messageLabel'in sağ kenarını view'in sağ kenarına 40 puan uzaklıkta hizalıyoruz.
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            // messageLabel'in yüksekliğini 200 puan olarak ayarlıyoruz.
            
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            // logoImageView'in genişliğini view'in genişliğinin 1.3 katı olarak ayarlıyoruz.
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            // logoImageView'in yüksekliğini view'in genişliğinin 1.3 katı olarak ayarlıyoruz.
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            // logoImageView'in sağ kenarını view'in sağ kenarına 170 puan uzaklıkta hizalıyoruz.
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40)
            // logoImageView'in alt kenarını view'in alt kenarına 40 puan uzaklıkta hizalıyoruz.
        ])
    }
}

