//
//  SearchVC.swift
//  GHFollowers2
//
//  Created by Samet KATI on 13.05.2024.
//

import UIKit

/// Search VC ekranınındaki görüntüyü kontrol eden controller
class SearchVC: UIViewController {
    
    /// Buradaki nesneler classlardan oluşturuldu bu nesneler aşağıda fonksiyonlar içinde ekrana yerleştirilmek için oluşturuldu
    let logoImageView = UIImageView()
    let usernameTextField = GFTextField()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    /// TextField içinde bir yazı olmadığını gösteren bir computed property
    var isUsernameEmpty : Bool {
        return !usernameTextField.text!.isEmpty
    }
    
    /// Bu view controller yüklendiği zaman gerçekleşecek işlemleri içeren fonksiyon burası
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardGesture()
    }
    
    /// İlgili view controller görünür olacağı zaman yani henüz sayfa yüklenmeden önce olacak olan işlemler
    /// - Parameter animated: animasyon true mu false mu onu belirlemek için konulan bir parametre
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Navigation barın gizlenmesini istiyorsak bu yapıyı kullanıyoruz
        navigationController?.isNavigationBarHidden = true
    }
    
    /// Klavye açıldığında ekranın herhangi bir yerine tıkladığımızda klavyeyi kapatmak için yazılmış bir fonksiyon
    func createDismissKeyboardGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    /// Bir objective c fonksiyonu bu fonksiyon bize bulunduğumuz sayfadan farklı bri sayfaya veri geçirerek geçmemizi sağlar
    @objc func pushFollowerListVC(){
        // isUsernameEmpty sorgusu düzgün çalılıyor mu diye kontrol ediyor yani klasik if else sorgusu gibi bir yapı 
        guard isUsernameEmpty else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username.We need to know who to look for😄", buttonTitle: "Ok")
            return
        }
        
        let followerListVC = FollowersListVC()
        // FollowerListVC için navigation bar text ayarlamalarını burada yapıyoruz
        followerListVC.username = usernameTextField.text
        followerListVC.title = usernameTextField.text
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    /// logoImageView nesnesinin ekranda nerede duracağını belirlemek için oluşturulan bir fonksiyon
    func configureLogoImageView(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    /// usernameTextField nesnesinin ekranda nerede duracağını belirlemek için oluşturulan bir fonksiyon
    func configureTextField(){
        view.addSubview(usernameTextField)
        // Bu delegete text fieldin değişimleri dinleyeceğini belirtiyor
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    /// callToActionButton nesnesinin ekranda nerede duracağını belirlemek için oluşturulan bir fonksiyon
    func configureCallToActionButton(){
        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor , constant:  -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

//Extension kod karmaşasını önlemek ve kodu bölümlere ayırmak için kullanılır
extension SearchVC : UITextFieldDelegate {
    /// Klavyede go ya bastığımız zaman ne olması geretkiğini içeren bir fonksiyon
    /// - Parameter textField: text field için geçerli olduğunu belirtiyoruz
    /// - Returns: işlemin gerçekleşeceğini belirtiyor
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
