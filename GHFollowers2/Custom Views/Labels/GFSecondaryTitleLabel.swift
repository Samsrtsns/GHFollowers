//
//  GFSecondaryTitleLabel.swift
//  GHFollowers2
//
//  Created by Samet KATI on 26.05.2024.
//

import UIKit

// GFSecondaryTitleLabel adlı özel bir UILabel sınıfı oluşturuyoruz.
class GFSecondaryTitleLabel: UILabel {

    // Standart init metodunu override ediyoruz. Bu metod, sınıfın programatik olarak başlatılması durumunda çağrılır.
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // Interface Builder (Storyboard veya XIB) tarafından kullanıldığında çağrılması gereken init metodu.
    // Bu projede kullanılmadığı için fatalError ile uygulama çökertecek şekilde ayarlandı.
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // Kullanıcı tarafından belirtilen font büyüklüğü ile sınıfı başlatan özel init metodu.
    init(fontSize : CGFloat){
        // UILabel'in init(frame:) metodunu çağırıyoruz ve çerçeve olarak .zero (yani boş bir çerçeve) belirtiyoruz.
        super.init(frame: .zero)
        // Fontu, belirli bir büyüklük ve ağırlık (medium) ile ayarlıyoruz.
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        // Ek yapılandırmaları yapmak için configure() metodunu çağırıyoruz.
        configure()
    }
    
    // Label'ın çeşitli özelliklerini ayarlayan özel yapılandırma metodu.
    private func configure(){
        // Label'ın metin rengini, iOS'un ikincil etiket renginde ayarlıyoruz (genellikle gri tonlarında).
        textColor = .secondaryLabel
        // Metin boyutunun etiket genişliğine sığacak şekilde otomatik olarak ayarlanmasını sağlıyoruz.
        adjustsFontSizeToFitWidth = true
        // Metin boyutunun minimum ölçekleme faktörünü belirliyoruz (burada %90).
        minimumScaleFactor = 0.90
        // Metin çok uzun olduğunda sonunu keserek '...' eklenmesini sağlıyoruz.
        lineBreakMode = .byTruncatingTail
        // Otomatik yerleşim kısıtlamalarının kullanılacağını belirtiyoruz.
        translatesAutoresizingMaskIntoConstraints = false
    }

}

