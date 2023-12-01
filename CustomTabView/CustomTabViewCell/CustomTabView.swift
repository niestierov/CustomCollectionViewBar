//
//  CustomTabView.swift
//  CustomTabView
//
//  Created by Denys Niestierov on 16.11.2023.
//

import UIKit

final class CustomTabView: UIView {
    private enum Constant {
        static let defaultMinimumLineSpacing: CGFloat = 5
        static let itemInset: CGFloat = 35
        static let barTitleFontSize: CGFloat = 17
        static let maximumFullscreenTabsCount = 3
        static let selectionIndicatorMinimumWidth: CGFloat = 35
        static let selectionIndicatorCornerRadius: CGFloat = 2
        static let selectionIndicatorHeight: CGFloat = 5
        static let selectionIndicatorAnimationTime = 0.1
    }
    
    // MARK: - Properties -
    
    private var tabsList: [String] = []
    private var selectedIndex: Int = .zero
    private var selectedCellTextColor: UIColor = .cyan
    private var defaultCellTextColor: UIColor = .white
    
    // MARK: - UI Components -
    
    private var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constant.defaultMinimumLineSpacing
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.bounces = false
        view.showsHorizontalScrollIndicator = false
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
    
    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCollectionView()
    }
    
    // MARK: - Internal -
    
    func configure(with tabsList: [String]) {
        self.tabsList = tabsList
        collectionView.reloadData()
    }
    
    func configureCollectionView(
        showsHorizontalScrollIndicator: Bool = false,
        bounces: Bool = false
    ) {
        collectionView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        collectionView.bounces = bounces
    }
    
    func setBackgroundColor(with backgroundColor: UIColor) {
        collectionView.backgroundColor = backgroundColor
    }
    
    func setTabColorsWith(defaultStateColor: UIColor, selectedStateColor: UIColor) {
        selectedCellTextColor = selectedStateColor
        defaultCellTextColor = defaultStateColor
    }
    
    func setIndicatorColor(with color: UIColor) {
        selectionIndicatorView.backgroundColor = color
    }
}

// MARK: - Private -

private extension CustomTabView {
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
    
    func updateIndicatorPositionWithAnimation(frame: CGRect) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constant.selectionIndicatorAnimationTime) {
                self.selectionIndicatorView.frame = frame
            }
        }
    }
    
    func determineTitleWidth(for title: String) -> CGFloat {
        let maxSize = CGSize(width: .greatestFiniteMagnitude, height: self.frame.height)
        let font = UIFont.systemFont(ofSize: Constant.barTitleFontSize, weight: .medium)

        let boundingRect = title.boundingRect(
            with: maxSize,
            attributes: [.font: font],
            context: nil
        )
        
        return boundingRect.width
    }
    
    func determineOptimalTitleWidth(for title: String) -> CGFloat {
        max(determineTitleWidth(for: title), Constant.selectionIndicatorMinimumWidth)
    }
    
    func determineItemWidthForFullscreen() -> CGFloat {
        let tabsCount = CGFloat(tabsList.count)
        let itemSpacing = Constant.defaultMinimumLineSpacing * (tabsCount - 1)
        let width = UIScreen.main.bounds.width
        
        return (width - itemSpacing) / CGFloat(tabsList.count)
    }
    
    func calculateIndicatorFrame(for cell: UICollectionViewCell, titleWidth: CGFloat) -> CGRect {
        let indicatorX = cell.center.x - titleWidth / 2
        let indicatorY = cell.frame.origin.y + cell.frame.height - Constant.selectionIndicatorHeight

        return CGRect(
            x: indicatorX,
            y: indicatorY,
            width: titleWidth,
            height: Constant.selectionIndicatorHeight
        )
    }
    
    func updateIndicatorPositionIfNeeded(
        for cell: UICollectionViewCell,
        title: String,
        isNeeded: Bool
    ) {
        guard isNeeded else {
            return
        }

        let titleWidth = determineOptimalTitleWidth(for: title)
        let indicatorFrame = calculateIndicatorFrame(for: cell, titleWidth: titleWidth)

        updateIndicatorPositionWithAnimation(frame: indicatorFrame)
    }
    
    func configureCell(_ cell: CustomTabViewCell, at indexPath: IndexPath) {
        let title = tabsList[indexPath.item]
        let isSelected = selectedIndex == indexPath.item
        
        cell.configure(
            title: title,
            isSelected: isSelected,
            selectedStateColor: selectedCellTextColor,
            defaultStateColor: defaultCellTextColor
        )
        
        updateIndicatorPositionIfNeeded(for: cell, title: title, isNeeded: isSelected)
    }
    
    func calculateNeededItemSize(for title: String) -> CGSize {
        let itemWidth: CGFloat
        
        if tabsList.count > Constant.maximumFullscreenTabsCount {
            itemWidth = determineTitleWidth(for: title) + Constant.itemInset
        } else {
            itemWidth = determineItemWidthForFullscreen()
        }
        
        return CGSize(width: itemWidth, height: frame.height)
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
        
        configureCell(cell, at: indexPath)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate -

extension CustomTabView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout -

extension CustomTabView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return calculateNeededItemSize(for: tabsList[indexPath.item])
    }
}
