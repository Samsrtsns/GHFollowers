//
//  FavoritesListVC.swift
//  GHFollowers2
//
//  Created by Samet KATI on 13.05.2024.
//

import UIKit

// Favori takipçilerin listesini gösteren bir görünüm denetleyicisi
class FavoritesListVC: UIViewController {
    
    let tableView = UITableView() // Favori takipçileri göstermek için UITableView oluşturuluyor
    var favorites: [Follower] = [] // Favori takipçileri tutmak için bir dizi oluşturuluyor

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController() // Görünüm denetleyicisini yapılandır
        configureTableView() // Tablo görünümünü yapılandır
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites() // Favori takipçileri almak için çağrılır
    }
    
    // Görünüm denetleyicisini yapılandırma
    func configureViewController() {
        view.backgroundColor = .systemBackground // Arka plan rengini sistem rengine ayarla
        title = "Favorites" // Başlığı "Favorites" olarak ayarla
        navigationController?.navigationBar.prefersLargeTitles = true // Navigasyon çubuğunda büyük başlıkları kullan
    }
    
    // Tablo görünümünü yapılandırma
    func configureTableView() {
        view.addSubview(tableView) // TableView'i alt görünüme ekle
        
        tableView.frame = view.bounds // TableView'in çerçevesini ana görünümün sınırlarına göre ayarla
        tableView.rowHeight = 80 // Satır yüksekliğini 80 birim olarak ayarla
        tableView.delegate = self // TableView'in delegesi olarak kendisini ayarla
        tableView.dataSource = self // TableView'in veri kaynağı olarak kendisini ayarla
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID) // FavoriteCell'i yeniden kullanılabilir hale getir
    }
    
    // Favori takipçileri alma
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in // Favori takipçileri alma işlemi başlatılıyor
            guard let self = self else { return } // Self referansı güçlü tutulamıyorsa işlemi sonlandır
            
            switch result {
            case .success(let favorites): // İşlem başarılı olursa
                if favorites.isEmpty {
                    // Favori yoksa boş durumu göster
                    self.showEmptyStateView(with: "No favorites?\nAdd one on the follower screen.", in: self.view)
                } else {
                    self.favorites = favorites // Favori takipçileri diziye ata
                    DispatchQueue.main.async {
                        self.tableView.reloadData() // TableView'i yeniden yükle
                        self.view.bringSubviewToFront(self.tableView) // TableView'i öne getir
                    }
                }
            case .failure(let error): // İşlem başarısız olursa
                // Hata mesajını göster
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

// UITableViewDelegate ve UITableViewDataSource protokollerini genişletme
extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    // Tablo görünümündeki satır sayısını döndürür
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count // Favori sayısını döndür
    }
    
    // Belirli bir satır için hücreyi yapılandırır ve döndürür
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell // Yeniden kullanılabilir hücreyi al
        let favorite = favorites[indexPath.row] // İlgili favori takipçiyi al
        cell.set(favorite: favorite) // Hücreyi favori takipçi ile yapılandır
        return cell // Hücreyi döndür
    }
    
    // Belirli bir satır seçildiğinde yapılacak işlemleri tanımlar
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row] // Seçilen favori takipçiyi al
        let destVC = FollowersListVC() // Yeni bir FollowersListVC oluştur
        destVC.username = favorite.login // Kullanıcı adını ayarla
        destVC.title = favorite.login // Başlığı kullanıcı adı olarak ayarla
        
        navigationController?.pushViewController(destVC, animated: true) // Yeni görünüm denetleyicisine geç
    }
    
    // Belirli bir satırda kaydırarak silme işlemi yapılabilir
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return } // Silme işlemi değilse geri dön
        
        let favorite = favorites[indexPath.row] // Silinecek favori takipçiyi al
        favorites.remove(at: indexPath.row) // Favori takipçiyi diziden çıkar
        tableView.deleteRows(at: [indexPath], with: .left) // Satırı tablo görünümünden sil
        
        // Favori takipçiyi kalıcı depolamadan çıkar
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return } // Self referansı güçlü tutulamıyorsa işlemi sonlandır
            guard let error = error else { return } // Hata yoksa geri dön
            // Hata mesajını göster
            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "OK")
        }
    }
}
