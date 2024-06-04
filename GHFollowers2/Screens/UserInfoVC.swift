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
    var dateLabel = GFBodyLabel(textAlignment: .center)
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
    
    // MARK: Network
    
    // Bu metod, ağ üzerinden kullanıcı bilgilerini alır.
    func getUserInfo(){
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }  // Self'in mevcut olduğundan emin ol
            
            switch result {  // Ağ çağrısının sonucunu işle
            case .success(let user):  // Başarılı olursa, kullanıcı bilgi başlık görünümünü ekle
                DispatchQueue.main.async {
                    //burada child view controllera eklemek için çağrılır
                    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                    self.add(childVC: GFRepoItemVC(user: user), to: self.itemViewOne)
                    self.add(childVC: GFFollowerItemVC(user: user), to: self.itemViewTwo)
                    self.dateLabel.text = "GitHub Since \(user.createdAt.convertToDisplayFormat())"
                }
            case .failure(let error):  // Başarısız olursa, hata mesajıyla bir uyarı göster
                self.presentGFAlertOnMainThread(title: "Bir Hata Oluştu", message: error.rawValue, buttonTitle: "Tamam")
            }
        }
    }
    
    // MARK: UI configure
    
    // Bu metod, UI elemanlarını düzenler.
    func layoutUI(){
        itemViews = [headerView, itemViewOne, itemViewTwo,dateLabel]  // Öğeleri diziye ekle
        let padding: CGFloat = 20  // Kenar boşluğu
        let itemHeight: CGFloat = 180  // Öğe yüksekliği
        
        for itemView in itemViews {  // Her bir öğe için
            view.addSubview(itemView)  // Görünüme öğeyi ekle
            itemView.translatesAutoresizingMaskIntoConstraints = false  // Otomatik boyutlandırmayı devre dışı bırak
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),  // Sol kenar boşluğunu ayarla
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),  // Sağ kenar boşluğunu ayarla
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),  // Başlık görünümünün üst konumunu ayarla
            headerView.heightAnchor.constraint(equalToConstant: 180),  // Başlık görünümünün yüksekliğini ayarla
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),  // Birinci öğenin üst konumunu ayarla
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),  // Birinci öğenin yüksekliğini ayarla
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),  // İkinci öğenin üst konumunu ayarla
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),  // İkinci öğenin yüksekliğini ayarla
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    // MARK: Child view Adding process
    
    // Bu metod, bir child view controller'ı belirtilen containerView'e ekler.
    func add(childVC: UIViewController, to containerView: UIView){
        addChild(childVC)  // Child view controller'ı ekle
        containerView.addSubview(childVC.view)  // Child view'i containerView'e ekle
        childVC.view.frame = containerView.bounds  // Child view'in çerçevesini containerView'in boyutlarına ayarla
        // .bounds ekran boyutunu alır
        childVC.didMove(toParent: self)  // Child view controller'ın parent'a taşındığını bildir
    }
    
    // Bu metod, view controller'ı kapatır.
    @objc func dismissVC(){
        dismiss(animated: true)  // View controller'ı animasyonlu olarak kapat
    }
}

