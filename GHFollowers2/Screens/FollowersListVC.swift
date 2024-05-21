//
//  FollowersListVC.swift
//  GHFollowers2
//
//  Created by Samet KATI on 14.05.2024.
//

import UIKit

class FollowersListVC: UIViewController {
    
    enum Section {case main}
    
    // Kullanıcı adını tutan değişken
    var username: String!
    //Takipçileri tutan bir liste
    var followers : [Follower] = []
    var page = 1
    // CollectionView nesnesini tutan değişken
    var collectionView: UICollectionView!
    var hasMoreFollowers = true
    
    var dataSource: UICollectionViewDiffableDataSource<Section , Follower>!

    // View yüklendiğinde çalışan fonksiyon
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    // View görünmeden hemen önce çalışan fonksiyon
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation bar'ı gösterir
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    /// ViewController için bazı özellikleri yapılandırır
    func configureViewController() {
        // View'in arka plan rengini sistem arka plan rengi yapar
        view.backgroundColor = .systemBackground
        // Navigation bar'da büyük başlıkları tercih eder
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    /// CollectionView nesnesi oluşturup register ve genel özelliklerini belirleyen bir fonksiyon
    func configureCollectionView() {
        // CollectionView'i oluşturur ve çerçevesini view'in sınırlarına göre ayarlar
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        // Oluşturulan CollectionView'i ana view'e ekler
        view.addSubview(collectionView)
        // Collection View dinlenerek değişiklikler belirlenerek
        collectionView.delegate = self
        // CollectionView'in arka plan rengini pembe olarak ayarlar
        collectionView.backgroundColor = .systemBackground
        // CollectionView'de kullanılacak hücreyi kaydeder
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }

    /// Takipçileri aldığımız fonksiyon
    func getFollowers(username: String , page : Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) {[weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            // Sonuca göre işlem yapar
            switch result {
                // Başarılı olursa
                case .success(let followers):
                
                if followers!.count < 100 {self.hasMoreFollowers = false}
                // Takipçileri yazdırır
                self.followers.append(contentsOf: followers!)
                self.updateData()
                //print(followers!)
                // Hata olursa
                case .failure(let error):
                    // Ana thread'de uyarı gösterir
                    self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    /// UICollectionView'unuzun veri kaynağını (data source) yapılandırmak için kullanılır. Bu fonksiyon, UICollectionViewDiffableDataSource'u ayarlayarak koleksiyon görünümünüzün nasıl veri göstereceğini belirler.
    func configureDataSource() {
        // UICollectionViewDiffableDataSource örneğini Section ve Follower türleriyle oluşturur
        dataSource = UICollectionViewDiffableDataSource<Section, Follower> (collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            // Belirtilen hücreyi koleksiyon görünümünden yeniden kullanmak üzere çıkarır
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            // Hücrenin içeriğini verilen Follower nesnesiyle günceller
            cell.set(follower: follower)
            // Güncellenmiş hücreyi geri döndürür
            return cell
        })
    }
    
    /// veri kaynağınızı güncellemek ve yeni verilerle koleksiyon görünümünüzü yeniden yüklemek için kullanılır.
    func updateData() {
        // Yeni bir NSDiffableDataSourceSnapshot oluşturur
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        
        // Snapshota 'main' adında bir section ekler
        snapshot.appendSections([.main])
        
        // Snapshota followers adlı veri kümesini ekler
        snapshot.appendItems(followers)
        
        // Snapshot'u data source'a uygular ve animasyonlu geçişlerle görünümü günceller
        DispatchQueue.main.async {self.dataSource.apply(snapshot, animatingDifferences: true)}
    }
}

// MARK: Pagination

// FollowersListVC sınıfının UICollectionViewDelegate protokolünü uyguladığı bir uzantı
extension FollowersListVC: UICollectionViewDelegate {
    
    // Kullanıcı kaydırmayı bırakıp, eylem tamamlandığında çağrılan fonksiyon
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // Kaydırma işlemi tamamlandığında scrollView'un dikey (y) eksenindeki ofsetini alır
        let offsetY = scrollView.contentOffset.y
        // İçerik yüksekliğini alır (tüm içerik)
        let contentHeight = scrollView.contentSize.height
        // Görünür alanın (ekranın) yüksekliğini alır
        let height = scrollView.frame.size.height

        // Kullanıcı ekranın alt kısmına geldiğinde bu if bloğu çalışır
        if offsetY > contentHeight - height {
            // Daha fazla takipçi olup olmadığını kontrol eder
            guard hasMoreFollowers else { return }
            // Sayfa numarasını artırır
            page += 1
            // Yeni sayfa için takipçileri getirir
            getFollowers(username: username, page: page)
        }
    }
}

