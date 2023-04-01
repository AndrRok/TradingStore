//
//  LikeAndShareView.swift
//  TradingStore
//
//  Created by ARMBP on 3/24/23.
//

import UIKit

class LikeAndShareView: UIView {
    
    private lazy var addToFavoritesButton = UIButton()
    private lazy var shareButton = UIButton()
    private lazy var separator = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    private func configure(){
        configureLikeButton()
        configureSeparator()
        configureShareButton()
    }
    
    private func configureLikeButton(){
        addSubview(addToFavoritesButton)
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        addToFavoritesButton.tintColor = Colors.blueBerry
        addToFavoritesButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addToFavoritesButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            addToFavoritesButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addToFavoritesButton.widthAnchor.constraint(equalToConstant: 30),
            addToFavoritesButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    private func configureSeparator(){
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = Colors.blueBerry
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: addToFavoritesButton.bottomAnchor, constant: 10),
            separator.centerXAnchor.constraint(equalTo: centerXAnchor),
            separator.widthAnchor.constraint(equalToConstant: 30),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func configureShareButton(){
        addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = Colors.blueBerry
        shareButton.addTarget(self, action: #selector(shareItem), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10),
            shareButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 30),
            shareButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func addToFavorites(){
    }
    
    @objc private func shareItem(){
    }
    
}
