//
//  MainScreen.swift
//  CustomCollectionViewBar
//
//  Created by Denys Niestierov on 16.11.2023.
//

import UIKit

final class MainScreen: UIViewController {
    private enum Constant {
        static let collectionViewHeight: CGFloat = 50
        
        enum Title {
            static let allTitle = "All"
            static let friendsTitle = "Friends"
            static let workTitle = "Work"
            static let universityTitle = "UniversityUniversity"
            static let groupsTitle = "Groups"
        }
    }
    
    // MARK: - Properties -
    
    private lazy var collectionView: CustomCollectionViewBar = {
        let view = CustomCollectionViewBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: Constant.collectionViewHeight)
        ])

        let barTitles = [
            Constant.Title.allTitle,
            Constant.Title.friendsTitle,
            Constant.Title.groupsTitle,
            Constant.Title.friendsTitle,
            Constant.Title.workTitle,
            Constant.Title.universityTitle
        ]
        
        collectionView.setupTabs(barTitles: barTitles)
    }
}
