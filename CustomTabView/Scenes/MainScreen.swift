//
//  MainScreen.swift
//  CustomCollectionViewBar
//
//  Created by Denys Niestierov on 16.11.2023.
//

import UIKit

final class MainScreen: UIViewController {
    
    private struct Constant {
        static let tabViewHeight: CGFloat = 50
        
        struct TabsList {
            static let allTitle = "All"
            static let friendsTitle = "Friends"
            static let workTitle = "Work"
            static let universityTitle = "UniversityUniversity"
            static let groupsTitle = "Groups"
        }
        
        static let defaultTabsList = [
            Constant.TabsList.allTitle,
            Constant.TabsList.friendsTitle,
            Constant.TabsList.groupsTitle,
            Constant.TabsList.workTitle,
            Constant.TabsList.universityTitle,
            Constant.TabsList.groupsTitle,
            Constant.TabsList.universityTitle,
        ]
        
        static let smallTabsList = [
            Constant.TabsList.allTitle,
            Constant.TabsList.friendsTitle,
            Constant.TabsList.groupsTitle
        ]
    }
    
    // MARK: - UI Components -
    
    private lazy var tabView: CustomTabView = {
        let view = CustomTabView(tabs: Constant.defaultTabsList)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Life Cycle -
    
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
            tabView.heightAnchor.constraint(equalToConstant: Constant.tabViewHeight)
        ])
    }
}
