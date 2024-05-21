//
//  NetworkManagers.swift
//  GHFollowers2
//
//  Created by Samet KATI on 15.05.2024.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let baseUrl = "https://api.github.com/users/"
    
    let cache = NSCache<NSString , UIImage>()
    
    private init() {}
    
    /// Bu fonksiyon belirtilen API'den veri almamızı sağlar
    /// - Parameters:
    ///   - username: Kullanıcı adını belirttiğimiz için username parametre olarak verilmiştir
    ///   - page: Birden fazla sayfadan oluşan veri olduğu için sayfa numarasını parametre olarak veriyoruz
    ///   - completed: Bu fonksiyon asenkron olduğu için bize her zaman eş zamanlı bir değer döndürmeyecek. Bu nedenle zaman uyuşmazlığına göre escaping kullanarak tamamlanma bloğunu belirliyoruz. Tamamlama bloğunda hata ve başarı durumunda fonksiyonun ne döndüreceğini belirliyoruz.
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower]? , GFError>) -> Void) {
    
        // API'nin endpoint'ini parametrelere göre ayarlıyoruz
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        
        // Endpoint'in doğru olup olmadığını kontrol ediyoruz. Eğer yanlışsa completion değerinde nil ve hata mesajı döndürüyoruz
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        // URLSession.shared.dataTask kullanarak URL'den veri alıyoruz
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Eğer hata varsa, hata mesajını içeren tamamlama bloğu çağırıyoruz
            if let _ = error {
                completed(.failure(.unableToComplate))
                return
            }
            
            // Sunucudan gelen yanıtın geçerli bir HTTPURLResponse ve durum kodunun 200 olduğunu kontrol ediyoruz
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            // Alınan verinin geçerli olup olmadığını kontrol ediyoruz
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            // Buraya ulaşıldığında, veri başarıyla alınmış demektir. Bu noktada veriyi işleyebiliriz.
            do {
                // JSONDecoder kullanarak gelen JSON verisini decode ediyoruz
                let decoder = JSONDecoder()
                // Anahtar isimlerini camelCase formatına çevirmek için convertFromSnakeCase stratejisini kullanıyoruz
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                // Veriyi [Follower] tipine decode ediyoruz
                let followers = try decoder.decode([Follower].self, from: data)
                // Decode işlemi başarılıysa tamamlanma bloğunu followers dizisi ve nil hata ile çağırıyoruz
                completed(.success(followers))
            } catch {
                // Decode işlemi başarısız olursa, hata mesajını içeren tamamlanma bloğunu çağırıyoruz
                completed(.failure(.invalidData))
            }
        }
        
        // İndirme görevini başlatıyoruz
        task.resume()
    }
}
