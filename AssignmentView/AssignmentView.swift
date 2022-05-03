//
//  ViewController.swift
//  AssignmentView
//
//  Created by Hakan Kumdakçı on 28.04.2022.
//

import UIKit
import TinyConstraints
import SDWebImage

class AssignmentView: UIViewController {
    
    var images: [String] = [
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image1-500kb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image2-500kb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image3-500kb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image4-500kb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image1-1mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image2-1mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image3-1mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image4-1mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image1-1_5mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image2-1_5mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image3-1_5mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image4-1_5mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image1-2mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image2-2mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image3-2mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image4-2mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image1-3mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image2-3mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image3-3mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image4-3mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image1-5mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image2-5mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image3-5mb.png",
    "https://db62cod6cnasq.cloudfront.net/user-media/0/image4-5mb.png"]

    var subImages: [String] = ["https://db62cod6cnasq.cloudfront.net/user-media/0/image2-500kb.png"]
    
    let refreshControl = UIRefreshControl()
    
    lazy var assignmentView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(AssignmentViewCollectionViewCell.self, forCellWithReuseIdentifier: AssignmentViewCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    lazy var settingsButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setTitle("Settings", for: .normal)
        btn.tintColor = .systemBlue
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 16)
        btn.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        return btn
    }()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCacheSettings()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        settingsButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsButton.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCacheSettings()
        
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Images"
        
        self.navigationController?.navigationBar.addSubview(settingsButton)
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        
        
        view.addSubview(assignmentView)
        assignmentView.refreshControl = refreshControl
    }
    
    @objc func showSettings(){
        let vc = SettingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didPullToRefresh(_ sender: Any) {
        assignmentView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func setCacheSettings(){
        let userDefaults = UserDefaults.standard
        SDImageCacheConfig.default.shouldRemoveExpiredDataWhenTerminate = userDefaults.bool(forKey: "terminateCache")
        SDImageCacheConfig.default.shouldRemoveExpiredDataWhenEnterBackground = userDefaults.bool(forKey: "backgroundCache")
        SDImageCacheConfig.default.shouldCacheImagesInMemory = userDefaults.bool(forKey: "regularCache")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        assignmentView.edgesToSuperview(insets: UIEdgeInsets(top: 16, left: 8, bottom: -8, right: 8),usingSafeArea: true)
        
        settingsButton.topToSuperview(offset: 0)
        settingsButton.trailingToSuperview(offset: 12)
        settingsButton.bottomToSuperview()
        settingsButton.width(96)
    }
}

extension AssignmentView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssignmentViewCollectionViewCell.identifier, for: indexPath) as! AssignmentViewCollectionViewCell
        
        cell.configure(with: subImages[indexPath.row], width: self.view.frame.width/3.5, height: 128.0)
        cell.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/3.5 , height: 148.0)
    }
}
