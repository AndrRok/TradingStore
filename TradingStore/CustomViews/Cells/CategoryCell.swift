//
//  CategoryCell.swift
//  TradingStore
//
//  Created by ARMBP on 3/20/23.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    private lazy var imageImageView = ItemImage(frame: .zero)
    public static let reuseID = "categoryCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor =  Colors.mainBackGroundColor
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setImages(image: UIImage){
        
        DispatchQueue.main.async{
            self.imageImageView.image = image
        }
    }
    
    override var isSelected: Bool {
        didSet {
            DispatchQueue.main.async {
                self.contentView.backgroundColor  = self.isSelected ? Colors.mainOrangeColor   : Colors.mainBackGroundColor
                self.imageImageView.tintColor     = self.isSelected ? .white     : .systemGray
            }
        }
    }
    
    
    //MARK: - Configure
    private func configure(){
        addSubview(imageImageView)
        contentView.layer.cornerRadius = contentView.bounds.width/2
        contentView.layer.masksToBounds = true
        imageImageView.tintColor = .systemGray
        contentView.backgroundColor  = Colors.mainBackGroundColor
        imageImageView.translatesAutoresizingMaskIntoConstraints = false
        imageImageView.contentMode = .scaleToFill
        
        NSLayoutConstraint.activate([
            imageImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageImageView.widthAnchor.constraint(equalToConstant: 30),
            imageImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
