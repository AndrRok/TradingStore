//
//  CarouselCell.swift
//  TradingStore
//
//  Created by ARMBP on 3/24/23.
//

import UIKit



class CarouselCell: UICollectionViewCell {
    private lazy var imageImageView = ItemImage(frame: .zero)
    public static let reuseID = "carouselCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor =  Colors.mainBackGroundColor
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setImages(url: String){
        DispatchQueue.main.async{
            self.imageImageView.downloadImage(fromURL: url)
        }
    }
    
    public func setDefaultImage(){
        DispatchQueue.main.async{
            self.imageImageView.image = Images.placeholder
        }
    }

    
//MARK: - Configure
    private func configure(){
        addSubview(imageImageView)
        imageImageView.translatesAutoresizingMaskIntoConstraints = false
        imageImageView.contentMode = .scaleToFill
        DispatchQueue.main.async { [self] in
            contentView.layer.cornerRadius = 10
            imageImageView.layer.cornerRadius = 10
        }
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        contentView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        contentView.layer.shadowOpacity = 1.0
        contentView.layer.shadowRadius = 5.0
    
        NSLayoutConstraint.activate([
            imageImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
}
