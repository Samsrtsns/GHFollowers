//
//  FollowersListVC.swift
//  GHFollowers2
//
//  Created by Samet KATI on 14.05.2024.
//

import UIKit

protocol FollowerListVCDelegete : AnyObject {
    func didRequestFollower(with username : String)
}

class FollowersListVC: UIViewController {
    
    enum Section {case main}
    
    // Kullanıcı adını tutan değişken
    var username: String!
    //Takipçileri tutan bir liste
    var followers : [Follower] = []
    var filteredFollowers : [Follower] = []
    var page = 1
    var isSearching = false
    // CollectionView nesnesini tutan değişken
    var collectionView: UICollectionView!
    var hasMoreFollowers = true
    
    var dataSource: UICollectionViewDiffableDataSource<Section , Follower>!

    // View yüklendiğinde çalışan fonksiyon
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    @objc func addButtonTapped(){
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username ) { [weak self] result in
            guard let self = self else {return}
            self.dismissLoadingView()
            
            switch result {
                
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                
                PersistenceManager.updateWith(favorite: favorite, actionType: .add ) { [weak self] error in
                    guard let self = self else {return}
                    
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success", message: "You have successfully favorited this user.🥳", buttonTitle: "Hooray")
                        return
                    }
                    
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                    
                }
            case .failure(let error):
                presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    // MARK: Configure Collection View
    
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
    
    // MARK: Searchbar configuration
    
    func configureSearchController(){
        let searchController                                    = UISearchController()
        searchController.searchResultsUpdater                   = self
        //Search barın hareketlerini dinlemek için bir delegete
        searchController.searchBar.delegate                     = self
        searchController.searchBar.placeholder                  = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation   = false
        //navigation bara searc bar ekliyor
        navigationItem.searchController                         = searchController
    }
 
    // MARK: Network Function
    
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
                
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers.Go follow them 😄. "
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view )
                    }
                    return
                }
                
                self.updateData(on: self.followers)
                //print(followers!)
                // Hata olursa
                case .failure(let error):
                    // Ana thread'de uyarı gösterir
                    self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    // MARK: CollectionView Data Source
    
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
    
    // MARK: Snapshot
    
    /// veri kaynağınızı güncellemek ve yeni verilerle koleksiyon görünümünüzü yeniden yüklemek için kullanılır.
    func updateData(on followers: [Follower]) {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Arama yaptığımızda hangi array aktif olacak ve ona göre tıklama işlemi yapılacak kontrolğ
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        // UserInfo screen için nesne
        let destVC = UserInfoVC()
        destVC.delegete = self
        destVC.username = follower.login
        
        let navController = UINavigationController(rootViewController: destVC)
        present(navController , animated: true)
        
    }
}

// MARK: Search Extension

extension FollowersListVC: UISearchResultsUpdating , UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased())}
        updateData(on: filteredFollowers)
    }
    //func
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
}

extension FollowersListVC : FollowerListVCDelegete {
    func didRequestFollower(with username: String) {
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
}
