//
//  HomeViewController.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 12.11.2023.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchData()
        configureCollectionView()
        
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let titleView = UIImageView(image: UIImage(systemName: "bird.fill"))
        titleView.tintColor = .systemBlue
        navigationItem.titleView = titleView
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35 )
        button.setImage(UIImage(named: "pp")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 35 / 2
        button.clipsToBounds = true
        
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 35)));
        view.addSubview(button);
        view.backgroundColor = .clear
        
        let leftButton = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = leftButton
         
    }
    
    private func configureCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        mainCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(mainCollectionView)
        mainCollectionView.frame = view.bounds
    }
    
    private func fetchData() {
        viewModel.fetchPosts { result in
            switch result {
            case .success:
                self.viewModel.fetchUsers { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.mainCollectionView.reloadData()
                        }
                    case .failure(let error):
                        print("Error fetching data: \(error)")
                    }
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    @objc func handleLikeTapped() {
        print("DEBUG like tapped")
    }
    
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuseIdentifier, for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell() }
        
        if let content = viewModel.postWithUsers(at: indexPath.row) {
            cell.configure(with: content, isLastItem: viewModel.numberOfItems() == indexPath.row + 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if let content = viewModel.postWithUsers(at: indexPath.row) {
                // Calculate the dynamic height based on your content
                let userFirstNameHeight = heightForLabel(text: content.1.name, font: UIFont.systemFont(ofSize: 13, weight: .bold))
                let titleHeight = heightForLabel(text: content.0.title, font: UIFont.systemFont(ofSize: 16, weight: .bold))
                let bodyHeight = heightForLabel(text: content.0.body, font: UIFont.systemFont(ofSize: 14))
                let actionViewHeight = 40.0
                let seperatorHeight = 4.0

                // Add additional space for padding, borders, etc., if needed
                let totalHeight = userFirstNameHeight + titleHeight + bodyHeight + actionViewHeight + seperatorHeight + /*additional space*/ 32

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
