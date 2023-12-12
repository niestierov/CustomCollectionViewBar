//
//  CustomTabView.swift
//  CustomTabView
//
//  Created by Denys Niestierov on 16.11.2023.
//

import UIKit

final class CustomTabView: UIView {
    private struct Constant {
        static let barTitleFontSize: CGFloat = 17
        static let maximumFullscreenTabsCount = 3
        static let selectionIndicatorCornerRadius: CGFloat = 2
        static let selectionIndicatorHeight: CGFloat = 4
        static let selectionIndicatorAnimationTime = 0.2
        static let totalCellInset: CGFloat = 20
    }
    
    // MARK: - Properties -
    
    private var tabsList: [String] = []
    private var selectedCellTextColor: UIColor = .cyan
    private var defaultCellTextColor: UIColor = .white
    private var selectedIndex: Int = .zero
    
    // MARK: - UI Components -
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        view.delegate = self
        view.dataSource = self
        view.register(
            CustomTabViewCell.self,
            forCellWithReuseIdentifier: CustomTabViewCell.identifier
        )
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.bounces = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var selectionIndicatorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .cyan
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = Constant.selectionIndicatorCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Life Cycle -
    
    convenience init(frame: CGRect = .zero, tabs: [String] = []) {
        self.init(frame: frame)
        
        self.tabsList = tabs
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialSetup()
    }
    
    // MARK: - Internal -
    
    func configure(tabs: [String] = []) {
        tabsList = tabs
        updateTabsList(isInitial: false)
    }
    
    func configure(
        backgroundColor: UIColor = .darkGray,
        indicatorColor: UIColor = .cyan,
        defaultTabColor: UIColor = .white,
        selectedTabColor: UIColor = .cyan
    ) {
        self.backgroundColor = backgroundColor
        selectionIndicatorView.backgroundColor = indicatorColor
        defaultCellTextColor = defaultTabColor
        selectedCellTextColor = selectedTabColor
        
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateTabsList(isInitial: true)
    }
}

// MARK: - Private -

private extension CustomTabView {
    func initialSetup() {
        self.backgroundColor = .darkGray
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        addSubview(collectionView)
        
        collectionView.addSubview(selectionIndicatorView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func updateTabsList(isInitial: Bool) {
        determineItemSize()
        
        if tabsList.count > .zero {
            if isInitial {
                collectionView.reloadData()
            }
            collectionView.layoutIfNeeded()
            
            let firstItemPath = IndexPath(item: selectedIndex, section: .zero)
            
            collectionView.selectItem(
                at: firstItemPath,
                animated: true, 
                scrollPosition: .centeredHorizontally
            )
            updateIndicatorPosition(for: firstItemPath)
        }
    }
    
    func determineItemWidthForFullscreen() -> CGFloat {
        let numberOfTabs = CGFloat(tabsList.count)
        
        guard numberOfTabs > .zero else {
            return .zero
        }
        return UIScreen.main.bounds.width / numberOfTabs
    }
    
    func getLayoutAttributes(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes =
                collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) else {
            return nil
        }
        return layoutAttributes
    }
    
    func updateIndicatorPosition(for indexPath: IndexPath) {
        guard let layoutAttributes = getLayoutAttributes(at: indexPath) else {
            return
        }
        
        let indicatorFrameWidth = layoutAttributes.frame.width - Constant.totalCellInset
        let indicatorFrameX = layoutAttributes.center.x - (indicatorFrameWidth / 2)
        let indicatorFrameY = layoutAttributes.bounds.height - Constant.selectionIndicatorHeight
        
        let indicatorFrame = CGRect(
            x: indicatorFrameX,
            y: indicatorFrameY,
            width: indicatorFrameWidth,
            height: Constant.selectionIndicatorHeight
        )
        
        updateIndicatorPositionWithAnimation(for: indicatorFrame)
    }
    
    func updateIndicatorPositionWithAnimation(for frame: CGRect) {
        UIView.animate(withDuration: Constant.selectionIndicatorAnimationTime)
        {
            self.selectionIndicatorView.frame = frame
        }
    }
    
    func determineItemSize()  {
        if tabsList.count > Constant.maximumFullscreenTabsCount {
            collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        } else {
            let itemSize = CGSize(
                width: determineItemWidthForFullscreen(),
                height: collectionView.frame.height
            )
            
            collectionViewFlowLayout.estimatedItemSize = .zero
            collectionViewFlowLayout.itemSize = itemSize
        }
    }
}

// MARK: - UICollectionViewDataSource -

extension CustomTabView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        tabsList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomTabViewCell.identifier,
            for: indexPath
        ) as! CustomTabViewCell
        
        cell.configure(
            title: tabsList[indexPath.item],
            selectedStateColor: selectedCellTextColor,
            defaultStateColor: defaultCellTextColor
        )
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate -

extension CustomTabView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
        updateIndicatorPosition(for: indexPath)
        
        selectedIndex = indexPath.item
    }
}
