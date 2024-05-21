//
//  GFAvatarImageView.swift
//  GHFollowers2
//
//  Created by Samet KATI on 18.05.2024.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    // NetworkManager'dan gelen önbellek (cache) nesnesini kullanır
    let cache = NetworkManager.shared.cache
    
    // Yer tutucu (placeholder) resim
    let placeholderImage = UIImage(named: "avatar-placeholder")

    // Kodla başlatma için kullanılan initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    // Interface Builder (IB) ile başlatma desteklenmiyor
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // Görüntü görünümünü yapılandırır
    func configure() {
        // Köşe yuvarlatma
        layer.cornerRadius = 10
        
        // Görüntünün sınırları aşmasını önler
        clipsToBounds = true
        
        // Başlangıçta yer tutucu görüntüyü ayarlar
        image = placeholderImage
        
        // Otomatik yerleşim kısıtlamalarını manuel ayarlama için false olarak ayarlar
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Verilen URL'den görüntü indirir
    func downloadImage(from urlString: String) {
        
        // URL'yi cache anahtarı olarak kullanmak için NSString'e dönüştürür
        let cacheKey = NSString(string: urlString)
        
        // Öncelikle cache'de görüntü olup olmadığını kontrol eder
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        // URL'yi oluşturur
        guard let url = URL(string: urlString) else { return }
        
        // URLSession'da veri görevi başlatır
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            // `self`'in varlığını doğrular, aksi halde çıkış yapar
            guard let self = self else { return }
            
            // Hata kontrolü
            if error != nil { return }
            
            // HTTP yanıtını ve durum kodunu kontrol eder
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            // Verinin varlığını kontrol eder
            guard let data = data else { return }
            
            // Veriyi UIImage'a dönüştürür
            guard let image = UIImage(data: data) else { return }
            
            // Görüntüyü cache'e ekler
            self.cache.setObject(image, forKey: cacheKey)
            
            // Ana iş parçacığında görüntüyü günceller
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
        // Görevi başlatır
        task.resume()
    }
}

