//
//  SectionHeader.swift
//  TradingStore
//
//  Created by ARMBP on 3/20/23.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let reuseID = "sectionHeader"
    
    public lazy var label = UITextView()//change to func
    private lazy var viewAllButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        configureLabel()
        configrueButton()
    }
    
    //MARK: - Configure UI
    private func configureLabel(){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.textContainer.maximumNumberOfLines = 1
        label.textColor = .label
        label.backgroundColor = .systemGray.withAlphaComponent(0.0)
        label.textAlignment = .center
        label.isScrollEnabled = false
        label.font =  UIFont(name: "MontserratRoman-Bold", size: 24)
        label.centerVerticalText()
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    
    private func configrueButton(){
        addSubview(viewAllButton)
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        viewAllButton.setTitleColor(.secondaryLabel, for: .normal)
        viewAllButton.setTitle("View all", for: .normal)
        viewAllButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10)
        
        NSLayoutConstraint.activate([
            viewAllButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),
            viewAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            viewAllButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}
