//
//  GFUserInfoHeaderVC.swift
//  GHFollowers2
//
//  Created by Samet KATI on 24.05.2024.
//

import UIKit

// GFUserInfoHeaderVC sınıfı, UIViewController'dan miras alır ve kullanıcı bilgilerini başlık formatında görüntüler
class GFUserInfoHeaderVC: UIViewController {

    // Kullanıcı bilgi başlığı için UI elemanları oluşturuluyor
    let avatarImageView = GFAvatarImageView(frame: .zero) // Kullanıcının avatar görüntüsü
    let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 18) // Kullanıcı adı etiketi
    let nameLabel = GFSecondaryTitleLabel(fontSize: 18) // Kullanıcının tam adı etiketi
    let locationImageView = UIImageView() // Konum simgesi
    let locationLabel = GFSecondaryTitleLabel(fontSize: 18) // Konum etiketi
    let bioLabel = GFBodyLabel(textAlignment: .left) // Biyografi etiketi
    
    var user: User! // Kullanıcı verilerini tutan User nesnesi
    
    // Kullanıcı nesnesini kabul eden özel başlatıcı
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user // Kullanıcı verileri atanıyor
    }
    
    // Interface Builder'da bu view controller'ı kullanmak için gerekli başlatıcı (desteklenmiyor)
    required init?(coder: NSCoder) {
        fatalError("Unsupported") // Desteklenmiyor hatası fırlatılıyor
    }
    
    // Controller'ın view'ı belleğe yüklendikten sonra çağrılır
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews() // Alt görünümleri ekle
        layoutUI() // UI elemanlarını yerleştir
        configureUIElements() // UI elemanlarını yapılandır
    }
    
    // UI elemanlarını kullanıcı verileriyle yapılandırma
    func configureUIElements() {
        avatarImageView.downloadImage(from: user.avatarUrl) // Avatar görüntüsünü indir
        usernameLabel.text = user.login // Kullanıcı adını ayarla
        nameLabel.text = user.name ?? "No name" // Kullanıcının adını ayarla, eğer yoksa "No name"
        locationLabel.text = user.location ?? "No Location" // Kullanıcının konumunu ayarla, eğer yoksa "No Location"
        bioLabel.text = user.bio ?? "No bio available" // Kullanıcının biyografisini ayarla, eğer yoksa "No bio available"
        bioLabel.numberOfLines = 3 // Biyografi etiketi için maksimum satır sayısını ayarla
        
        // Konum simgesini yapılandırma
        locationImageView.image = UIImage(systemName: SFSymbols.location) // Konum simgesi görüntüsünü ayarla
        locationImageView.tintColor = .secondaryLabel // Konum simgesi rengi ayarla
    }
    
    // Alt görünümleri ana görünüme ekleme
    func addSubviews() {
        view.addSubview(avatarImageView) // Avatar görüntüsünü ekle
        view.addSubview(usernameLabel) // Kullanıcı adı etiketini ekle
        view.addSubview(nameLabel) // Kullanıcı tam adı etiketini ekle
        view.addSubview(locationImageView) // Konum simgesini ekle
        view.addSubview(locationLabel) // Konum etiketini ekle
        view.addSubview(bioLabel) // Biyografi etiketini ekle
    }
    
    // UI elemanlarını Auto Layout ile yerleştirme
    func layoutUI() {
        let padding: CGFloat = 20 // Genel kenar boşluğu
        let textImagePadding: CGFloat = 12 // Metin ve görüntü arası boşluk
        locationImageView.translatesAutoresizingMaskIntoConstraints = false // Konum simgesi için Auto Layout'u etkinleştir
        
        // Auto Layout kısıtlamalarını etkinleştirme
        NSLayoutConstraint.activate([
            // Avatar görüntüsü yerleşimi
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            // Kullanıcı adı etiketi yerleşimi
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            // Kullanıcı tam adı etiketi yerleşimi
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // Konum simgesi yerleşimi
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // Konum etiketi yerleşimi
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),

            // Biyografi etiketi yerleşimi
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            bioLabel.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

