//
//  CustomCollectionViewBar.swift
//  CustomCollectionViewBar
//
//  Created by Denys Niestierov on 16.11.2023.
//

import UIKit

final class CustomCollectionViewBar: UICollectionView {
    private enum Constant {
        static let defaultMinimumLineSpacing: CGFloat = 5
        static let itemInset: CGFloat = 30
        static let sectionInset: CGFloat = 10
        static let viewBackgroundColor = UIColor.darkGray
        static let barTitleFontSize: CGFloat = 17
        static let maximumFullscreenTabsCount = 3
        static let selectionIndicatorMinimumWidth: CGFloat = 35
        static let selectionIndicatorCornerRadius: CGFloat = 2
        static let selectionIndicatorHeight: CGFloat = 5
        static let selectionIndicatorAnimationTime = 0.1
    }
    
    // MARK: - Properties -
    
    private var barTitles: [String] = []
    private var selectedIndex: Int = .zero
    
    // MARK: - UIComponents -
    
    private var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constant.defaultMinimumLineSpacing
        return layout
    }()
    private lazy var selectionIndicatorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .cyan
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = Constant.selectionIndicatorCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LifeCycle -
    
    init() {
        super.init(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        
        setupCollectionView()
        setupSelectionIndicatorView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCollectionView()
        setupSelectionIndicatorView()
    }
    
    // MARK: - Internal -
    
    func setupTabs(barTitles: [String]) {
        self.barTitles = barTitles
        self.reloadData()
    }
}

// MARK: - Private -

private extension CustomCollectionViewBar {
    func setupCollectionView() {
        delegate = self
        dataSource = self
        
        register(
            CustomCollectionViewBarCell.self,
            forCellWithReuseIdentifier: CustomCollectionViewBarCell.identifier
        )
        
        backgroundColor = Constant.viewBackgroundColor
        showsHorizontalScrollIndicator = false
        bounces = false
    }
    
    func setupSelectionIndicatorView() {
        addSubview(selectionIndicatorView)
    }
    
    func changeIndicatorPositionWithAnimation(frame: CGRect) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constant.selectionIndicatorAnimationTime) {
                self.selectionIndicatorView.frame = frame
            }
        }
    }
    
    func determineTitleWidth(for title: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: Constant.barTitleFontSize, weight: .medium)
        let textSize = title.size(withAttributes: [.font: font])
        
        return textSize.width
    }
    
    func determineOptimalTitleWidth(for title: String) -> CGFloat {
        max(determineTitleWidth(for: title), Constant.selectionIndicatorMinimumWidth)
    }
    
    func determineTitleWidthForFullscreen() -> CGFloat {
        let tabsCount = CGFloat(barTitles.count)
        let itemSpacing = Constant.defaultMinimumLineSpacing * (tabsCount - 1)
        let sectionSpacing = Constant.sectionInset * 2
        let totalSpacing = itemSpacing + sectionSpacing
        let width = UIScreen.main.bounds.width
        
        return (width - totalSpacing) / CGFloat(barTitles.count)
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

        changeIndicatorPositionWithAnimation(frame: indicatorFrame)
    }
    
    func configureCell(_ cell: CustomCollectionViewBarCell, at indexPath: IndexPath) {
        let title = barTitles[indexPath.item]
        let isSelected = selectedIndex == indexPath.item
        
        cell.configure(title: title, isSelected: isSelected)
        
        updateIndicatorPositionIfNeeded(for: cell, title: title, isNeeded: isSelected)
    }
    
    func calculateNeededItemSize(for title: String) -> CGSize {
        let itemWidth: CGFloat
        
        if barTitles.count > Constant.maximumFullscreenTabsCount {
            itemWidth = determineTitleWidth(for: title) + Constant.itemInset
        } else {
            itemWidth = determineTitleWidthForFullscreen()
        }
        
        return CGSize(width: itemWidth, height: frame.height)
    }
}

// MARK: - UICollectionViewDataSource -

extension CustomCollectionViewBar: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        barTitles.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCollectionViewBarCell.identifier,
            for: indexPath
        ) as! CustomCollectionViewBarCell
        
        configureCell(cell, at: indexPath)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate -

extension CustomCollectionViewBar: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout -

extension CustomCollectionViewBar: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let title = barTitles[indexPath.item]
        return calculateNeededItemSize(for: title)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: .zero,
            left: Constant.sectionInset,
            bottom: .zero,
            right: Constant.sectionInset
        )
    }
}
