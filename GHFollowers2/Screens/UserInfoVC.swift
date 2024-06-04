//
//  UserInfoVC.swift
//  GHFollowers2
//
//  Created by Samet KATI on 23.05.2024.
//

import UIKit
import SafariServices

// Applying protocols for this VC to provide GFItemInfoVC comminicate
protocol UserInfoVCDelegete : AnyObject {
    func didTapGitHubProfile(for user : User)
    func didTapGetFollowers(for user : User)
}

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
                DispatchQueue.main.async { self.configureUIElements(with: user) }
            case .failure(let error):  // Başarısız olursa, hata mesajıyla bir uyarı göster
                self.presentGFAlertOnMainThread(title: "Bir Hata Oluştu", message: error.rawValue, buttonTitle: "Tamam")
            }
        }
    }
    
    // We added delegetes for ItemVC and add function
    func configureUIElements(with user : User){
        let repoItemVC = GFRepoItemVC(user: user)
        // activate delegete for repoItemVC
        repoItemVC.delegete = self
        
        let followerItemVC = GFFollowerItemVC(user: user)
        // activate delegete for followerItemVC
        followerItemVC.delegete = self
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        self.dateLabel.text = "GitHub Since \(user.createdAt.convertToDisplayFormat())"
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

// Using extension provide for the function in the protocols.
extension UserInfoVC : UserInfoVCDelegete {
    func didTapGitHubProfile(for user: User) {
        // Open the safari according to url
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid", buttonTitle: "Ok")
            return}
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
    func didTapGetFollowers(for user: User) {
        // Dissmiss VC
        // Reset collection view and make a network call according to username
    }
    
    
}
