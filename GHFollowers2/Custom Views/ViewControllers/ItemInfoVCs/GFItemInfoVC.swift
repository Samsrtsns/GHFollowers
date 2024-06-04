//
//  GFItemInfoVC.swift
//  GHFollowers2
//
//  Created by Samet KATI on 30.05.2024.
//

import UIKit

// Parent ItemInfo class
class GFItemInfoVC: UIViewController {
    
    let stackView = UIStackView()
    let itemInfoViewOne = GFItemInfoView()
    let itemInfoViewTwo = GFItemInfoView()
    let actionButton = GFButton()
    
    var user: User! // Kullanıcı verilerini tutan User nesnesi
    
    // Kullanıcı nesnesini kabul eden özel başlatıcı
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user // Kullanıcı verileri atanıyor
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        configureStackView()
        layoutUI()
    }
    
    private func configureBackgroundView(){
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
    // StackView için bazı özelleştirmeler ve içine eklenecek viewlar
    private func configureStackView(){
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }
    
    // Layout ayarlamak için bir fonksiyon
    private func layoutUI(){
        view.addSubview(stackView)
        view.addSubview(actionButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding : CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor , constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}
