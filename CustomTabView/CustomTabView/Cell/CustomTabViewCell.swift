//
//  CustomTabViewCell.swift
//  CustomTabView
//
//  Created by Denys Niestierov on 16.11.2023.
//

import UIKit

final class CustomTabViewCell: UICollectionViewCell {
    private struct Constant {
        static let titleFontSize: CGFloat = 18
        static let titleNumberOfLines = 1
        static let defaultHorizontalInset: CGFloat = 12
    }
    
    // MARK: - Properties -
    
    static let identifier = String(describing: CustomTabViewCell.self)
    private var selectedStateColor: UIColor = .cyan
    private var defaultStateColor: UIColor = .white
    
    // MARK: - UI Components -
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Constant.titleNumberOfLines
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Constant.titleFontSize, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life Cycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override var isSelected: Bool {
        didSet {
            updateTitleColor()
        }
    }
    
    // MARK: - Internal -
    
    func configure(
        title: String,
        selectedStateColor: UIColor,
        defaultStateColor: UIColor
    ) {
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        self.selectedStateColor = selectedStateColor
        self.defaultStateColor = defaultStateColor

        updateTitleColor()
    }
}

// MARK: - Private -

private extension CustomTabViewCell {
    func setupView() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constant.defaultHorizontalInset
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constant.defaultHorizontalInset
            ),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func updateTitleColor() {
        titleLabel.textColor = isSelected ? selectedStateColor : defaultStateColor
    }
}
