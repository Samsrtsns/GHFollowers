//
//  UserInfoVC.swift
//  GHFollowers2
//
//  Created by Samet KATI on 23.05.2024.
//

import UIKit

// Bu sınıf, kullanıcı bilgilerini görüntülemek için bir view controller tanımlar.
class UserInfoVC: UIViewController {
    
    var headerView = UIView()          // Başlık bölümü için UIView
    var itemViewOne = UIView()         // Birinci öğe bölümü için UIView
    var itemViewTwo = UIView()         // İkinci öğe bölümü için UIView
    var itemViews: [UIView] = []       // Tüm öğe görünümlerini tutmak için dizi
    var username: String!              // Kullanıcı adını tutacak özellik
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()     // View controller'ı yapılandırma metodunu çağır
        layoutUI()                    // UI elemanlarını yerleştirme metodunu çağır
        getUserInfo()                 // Kullanıcı bilgilerini alma metodunu çağır
    }
    
    // Bu metod, view controller'ın temel özelliklerini yapılandırır.
    func configureViewController(){
        view.backgroundColor = .systemBackground  // View'in arka plan rengini ayarla
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))  // 'done' butonunu oluştur
        navigationItem.rightBarButtonItem = doneButton  // 'done' butonunu sağ bar buton öğesi olarak ayarla
    }
    
    // Bu metod, ağ üzerinden kullanıcı bilgilerini alır.
    func getUserInfo(){
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }  // Self'in mevcut olduğundan emin ol
            
            switch result {  // Ağ çağrısının sonucunu işle
            case .success(let user):  // Başarılı olursa, kullanıcı bilgi başlık görünümünü ekle
                DispatchQueue.main.async {
                    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                }
            case .failure(let error):  // Başarısız olursa, hata mesajıyla bir uyarı göster
                self.presentGFAlertOnMainThread(title: "Bir Hata Oluştu", message: error.rawValue, buttonTitle: "Tamam")
            }
        }
    }
    
    // Bu metod, UI elemanlarını düzenler.
    func layoutUI(){
        itemViews = [headerView, itemViewOne, itemViewTwo]  // Öğeleri diziye ekle
        let padding: CGFloat = 20  // Kenar boşluğu
        let itemHeight: CGFloat = 140  // Öğe yüksekliği
        
        for itemView in itemViews {  // Her bir öğe için
            view.addSubview(itemView)  // Görünüme öğeyi ekle
            itemView.translatesAutoresizingMaskIntoConstraints = false  // Otomatik boyutlandırmayı devre dışı bırak
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),  // Sol kenar boşluğunu ayarla
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),  // Sağ kenar boşluğunu ayarla
            ])
        }

        itemViewOne.backgroundColor = .systemPink  // Birinci öğe arka plan rengini ayarla
        itemViewTwo.backgroundColor = .systemBlue  // İkinci öğe arka plan rengini ayarla
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),  // Başlık görünümünün üst konumunu ayarla
            headerView.heightAnchor.constraint(equalToConstant: 180),  // Başlık görünümünün yüksekliğini ayarla
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),  // Birinci öğenin üst konumunu ayarla
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),  // Birinci öğenin yüksekliğini ayarla
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),  // İkinci öğenin üst konumunu ayarla
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight)  // İkinci öğenin yüksekliğini ayarla
        ])
    }
    
    // Bu metod, bir child view controller'ı belirtilen containerView'e ekler.
    func add(childVC: UIViewController, to containerView: UIView){
        addChild(childVC)  // Child view controller'ı ekle
        containerView.addSubview(childVC.view)  // Child view'i containerView'e ekle
        childVC.view.frame = containerView.bounds  // Child view'in çerçevesini containerView'in boyutlarına ayarla
        childVC.didMove(toParent: self)  // Child view controller'ın parent'a taşındığını bildir
    }
    
    // Bu metod, view controller'ı kapatır.
    @objc func dismissVC(){
        dismiss(animated: true)  // View controller'ı animasyonlu olarak kapat
    }
}

