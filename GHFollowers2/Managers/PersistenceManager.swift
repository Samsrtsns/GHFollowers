//
//  PersistanceManager.swift
//  GHFollowers2
//
//  Created by Samet KATI on 7.06.2024.
//

import Foundation

// PersistenceActionType enum: Favorilere ekleme veya çıkarma işlemi için kullanılan enum.
enum PersistenceActionType {
    case add, remove
}

// PersistenceManager enum: Favori takipçileri yönetmek için kullanılan ana yönetici.
enum PersistenceManager {
    
    // UserDefaults standart kullanıcı varsayılanları.
    static private let defaults = UserDefaults.standard
    
    // Keys enum: UserDefaults anahtarlarını tutmak için kullanılıyor.
    enum Keys {
        static let favorites = "favorites" // Favoriler için anahtar.
    }
    
    // Favorileri güncellemek için kullanılan fonksiyon.
    // Belirli bir takipçiyi eklemek veya çıkarmak için PersistenceActionType kullanılıyor.
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        // Mevcut favorileri al.
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                var retrievedFavorites = favorites
                
                // Eylem türüne göre favorileri güncelle.
                switch actionType {
                case .add:
                    // Favori zaten mevcutsa hata döndür.
                    guard !retrievedFavorites.contains(favorite) else {
                        completed(.alreadyInFavorite)
                        return
                    }
                    // Yeni favoriyi ekle.
                    retrievedFavorites.append(favorite)
                    
                case .remove:
                    // Favoriyi listeden çıkar.
                    retrievedFavorites.removeAll { $0.login == favorite.login }
                }
                
                // Güncellenen favorileri kaydet ve sonucu döndür.
                completed(save(favorites: retrievedFavorites))
                
            case .failure(let error):
                // Favorileri alırken hata oluştuysa hatayı döndür.
                completed(error)
            }
        }
    }
    
    // Mevcut favorileri almak için kullanılan fonksiyon.
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        // UserDefaults'tan favorileri al.
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            // Eğer favoriler yoksa boş bir liste döndür.
            completed(.success([]))
            return
        }
        
        // JSONDecoder kullanarak favori verilerini decode et.
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            // Decode işlemi başarısız olursa hata döndür.
            completed(.failure(.unableToFavorites))
        }
    }
    
    // Favorileri kaydetmek için kullanılan fonksiyon.
    static func save(favorites: [Follower]) -> GFError? {
        // JSONEncoder kullanarak favorileri encode et.
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            // Encode edilmiş favorileri UserDefaults'a kaydet.
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            // Encode işlemi başarısız olursa hata döndür.
            return .unableToComplate
        }
    }
}
