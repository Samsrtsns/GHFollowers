//
//  UIViewController+Ext..swift
//  GHFollowers2
//
//  Created by Samet KATI on 15.05.2024.
//

import UIKit

fileprivate var containerView : UIView!

extension UIViewController {
    
    // UIViewController için bir extension (genişletme) tanımlıyoruz.
    // Bu, UIViewController'a yeni işlevler eklememizi sağlar.
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        // Main thread'de bir alert görüntülemek için bir fonksiyon tanımlıyoruz.
        // title: Alert başlığı
        // message: Alert mesajı
        // buttonTitle: Alert'teki butonun başlığı

        DispatchQueue.main.async {
            // UI güncellemeleri her zaman ana thread'de yapılmalıdır.
            // Bu, alert'in ana thread'de sunulmasını garanti eder.

            let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            // GFAlertVC isimli özel bir alert view controller oluşturuyoruz.
            // Bu alert view controller, başlık, mesaj ve buton başlığı ile başlatılır.

            alertVC.modalPresentationStyle = .overFullScreen
            // Alert'in tam ekranın üzerinde görüntülenmesini sağlar.
            // Arka planın bulanıklaşması gibi efektler için kullanılır.

            alertVC.modalTransitionStyle = .crossDissolve
            // Alert'in görüntülenirken yaptığı geçiş animasyonunu belirler.
            // .crossDissolve, yumuşak bir geçiş efekti sağlar.

            self.present(alertVC, animated: true)
            // Oluşturduğumuz alert view controller'ı sunar (present).
            // animated: true ile geçişin animasyonlu olmasını sağlarız.
        }
    }
    
    func showLoadingView(){
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25){ containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView(){
        
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }

    }
}
