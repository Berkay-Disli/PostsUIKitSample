//
//  HomeViewController.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import UIKit
import SDWebImage
import SideMenu

class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()
    
    private let mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 24, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    
    private lazy var ppButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35 )
        button.layer.cornerRadius = 35 / 2
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleSideMenu), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchData()
        configureCollectionView()
        
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let titleView = UIImageView(image: UIImage(systemName: "bird.fill"))
        titleView.tintColor = .systemGreen
        navigationItem.titleView = titleView
        
        
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 35)))
        view.addSubview(ppButton)
        view.backgroundColor = .clear
        let leftButton = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = leftButton
        
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openNewPostSheet))
        self.navigationItem.rightBarButtonItem = rightButton
         
    }
    
    private func configureCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        mainCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(mainCollectionView)
        mainCollectionView.frame = view.bounds
    }
    
    @objc func openNewPostSheet() {
        let newPostVC = NewPostViewController()
        newPostVC.onPostCreated = { [weak self] in
            self?.fetchData()
        }
        
        newPostVC.modalPresentationStyle = .overFullScreen
        present(newPostVC, animated: true)
    }
    
    @objc func createDataDebug() {
        viewModel.createPost(content: "Lets go!") { error in
            if let error = error {
                print("DEBUG Error creating post: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchData() {
        viewModel.fetchPosts { error in
            if let error = error {
                print("DEBUG error in fetchData: \(error)")
            } else {
                self.mainCollectionView.reloadData()
            }
        }
    }
    
    private func fetchUserPp() {
        DataManager.shared.fetchUser { url in
            if let url = url {
                print("DEBUG url is \(url)")
                self.ppButton.sd_setImage(with: url, for: .normal)
            }
        }
    }
    
    @objc func handleLikeTapped() {
        print("DEBUG like tapped")
    }
    
    @objc func handleSideMenu() {
        let menu = SideMenuNavigationController(rootViewController: SideMenuViewController())
        menu.leftSide = true
        present(menu, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        fetchUserPp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fetchUserPp()
    }
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuseIdentifier, for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell() }
        
        if let content = viewModel.post(at: indexPath.row) {
            cell.configure(with: content, isLastItem: viewModel.numberOfItems() == indexPath.row + 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if let content = viewModel.post(at: indexPath.row) {
                let userFirstNameHeight = heightForLabel(text: content.userInfo.username, font: UIFont.systemFont(ofSize: 13, weight: .bold))
                let titleHeight = heightForLabel(text: content.timestamp, font: UIFont.systemFont(ofSize: 16, weight: .regular))
//                let bodyHeight = heightForLabel(text: content.content, font: UIFont.systemFont(ofSize: 14))
                let actionViewHeight = 40.0
                let seperatorHeight = 4.0

                // Add additional space for padding, borders, etc., if needed
                let totalHeight = 32 /*userFirstNameHeight*/ + titleHeight + /*bodyHeight +*/ actionViewHeight + seperatorHeight + 24

                return CGSize(width: UIScreen.main.bounds.width, height: totalHeight)
            }

            // Return a default size if there's an issue with the data
            return CGSize(width: UIScreen.main.bounds.width, height: 400)
        }

        // Helper method to calculate the height of a label based on its text and font
        private func heightForLabel(text: String, font: UIFont) -> CGFloat {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = font
            label.text = text
            label.sizeToFit()
            return label.frame.height
        }
}
