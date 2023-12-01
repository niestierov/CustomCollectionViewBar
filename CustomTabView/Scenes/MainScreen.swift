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
    
    private let tabsList = [
        Constant.Title.allTitle,
        Constant.Title.friendsTitle,
        Constant.Title.groupsTitle,
        Constant.Title.friendsTitle,
        Constant.Title.workTitle,
        Constant.Title.universityTitle
    ]
    
    // MARK: - UI Components -
    
    private lazy var tabView: CustomTabView = {
        let view = CustomTabView()
        view.configure(with: tabsList)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabView()
    }
    
    // MARK: - Private -
    
    private func setupTabView() {
        view.addSubview(tabView)
        
        NSLayoutConstraint.activate([
            tabView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tabView.heightAnchor.constraint(equalToConstant: Constant.collectionViewHeight)
        ])
    }
}
