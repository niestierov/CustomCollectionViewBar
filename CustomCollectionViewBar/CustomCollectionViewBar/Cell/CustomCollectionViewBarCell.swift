//
//  CustomCollectionViewBarCell.swift
//  CustomCollectionViewBar
//
//  Created by Denys Niestierov on 16.11.2023.
//

import UIKit

final class CustomCollectionViewBarCell: UICollectionViewCell {
    private enum Constant {
        static let titleFontSize: CGFloat = 17
        static let titleNumberOfLines = 1
    }
    
    // MARK: - Properties -
    
    static let identifier = "CustomCollectionViewBarCell"
    
    // MARK: - UI Components -

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = Constant.titleNumberOfLines
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: Constant.titleFontSize, weight: .medium)
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

    // MARK: - Internal -
    
    func configure(
        title: String,
        isSelected: Bool,
        selectedStateColor: UIColor,
        defaultStateColor: UIColor
    ) {
        titleLabel.text = title
        titleLabel.textColor = isSelected ? selectedStateColor : defaultStateColor
    }
}

// MARK: - Private -

private extension CustomCollectionViewBarCell {
    func setupView() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
