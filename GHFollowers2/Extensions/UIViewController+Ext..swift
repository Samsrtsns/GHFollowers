//
//  UIViewController+Ext..swift
//  GHFollowers2
//
//  Created by Samet KATI on 15.05.2024.
//

import UIKit
import SafariServices

// Bu kod, UIViewController'a ek işlevsellik kazandırmak için bir extension tanımlar.
// UIViewController, UIKit framework'ünde tüm view controller'ların temelini oluşturur.

fileprivate var containerView : UIView!
// containerView adında bir UIView değişkeni tanımlanır. Bu değişken, extension içinde
// sadece bu dosyada kullanılabilir olacak şekilde fileprivate olarak tanımlanmıştır.

// UIViewController sınıfına yeni işlevler eklemek için bir extension tanımlıyoruz.
extension UIViewController {
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        // Ana thread'de bir alert (uyarı) görüntülemek için bir fonksiyon tanımlıyoruz.
        // Bu fonksiyon, alert başlığı, mesajı ve buton başlığı parametrelerini alır.

        DispatchQueue.main.async {
            // UI güncellemeleri her zaman ana thread'de yapılmalıdır.
            // Bu nedenle alert'in ana thread'de sunulmasını garanti ederiz.

            let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            // GFAlertVC adında özel bir alert view controller oluşturuyoruz.
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
    
    // A funciton to load safari Vc
    func presentSafariVc(with url : URL){
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
    /// // Yükleme göstergesini (loading indicator) göstermek için bir fonksiyon tanımlıyoruz.
    func showLoadingView(){
        containerView = UIView(frame: view.bounds)
        // containerView'i, mevcut view'in boyutlarıyla aynı olacak şekilde başlatıyoruz.
        view.addSubview(containerView)
        // containerView'i mevcut view'in alt view'ı olarak ekliyoruz.

        containerView.backgroundColor = .systemBackground
        // containerView'in arka plan rengini sistemin arka plan rengine ayarlıyoruz.
        containerView.alpha = 0
        // Başlangıçta containerView'in alfa (saydamlık) değeri 0 olarak ayarlanır.

        UIView.animate(withDuration: 0.25){ containerView.alpha = 0.8 }
        // 0.25 saniyelik bir animasyonla containerView'in alfa değeri 0.8'e getirilir.
        // Bu, view'in yavaşça görünür hale gelmesini sağlar.

        let activityIndicator = UIActivityIndicatorView(style: .large)
        // Büyük stil bir UIActivityIndicatorView (aktivite göstergesi) oluşturuyoruz.
        containerView.addSubview(activityIndicator)
        // Aktivite göstergesini containerView'e ekliyoruz.

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        // Auto Layout kısıtlamalarını manuel olarak ayarlayacağımızı belirtiyoruz.

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        // Aktivite göstergesinin X ve Y eksenlerinde view'in merkezine hizalanmasını sağlıyoruz.

        activityIndicator.startAnimating()
        // Aktivite göstergesini başlatıyoruz (dönmeye başlar).
    }
    
    /// // Yükleme göstergesini gizlemek için bir fonksiyon tanımlıyoruz.
    func dismissLoadingView(){
        DispatchQueue.main.async {
            // UI güncellemelerinin ana thread'de yapılmasını garanti ederiz.

            containerView.removeFromSuperview()
            // containerView'i superview'den (ebeveyn view) kaldırıyoruz.
            containerView = nil
            // containerView'i nil yaparak bellekten serbest bırakılmasını sağlıyoruz.
        }
    }
    
    func showEmptyStateView(with message :String, in view : UIView){
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}

