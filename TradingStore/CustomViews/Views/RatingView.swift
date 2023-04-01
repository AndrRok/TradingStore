//
//  RatingView.swift
//  TradingStore
//
//  Created by ARMBP on 3/24/23.
//

import UIKit

class RatingView: UIView {
    
    private lazy var ratingStack = UIStackView()
    private lazy var starImageView = UIImageView()
    private lazy var ratingLabel = UILabel()
    private lazy var reviewsLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(rating: Double, reviews: Int){// change to object next time
        ratingLabel.text = "\(rating)"
        reviewsLabel.text = "(\(reviews))"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let configuration = UIImage.SymbolConfiguration(pointSize: frame.size.height*0.8)
        let image = UIImage(systemName: "star", withConfiguration: configuration)
        starImageView.image = image
    }
    
    private func configure(){
        configureImageView()
        configureRatingLabel()
        configureViewsLabel()
        configureStackView()
    }
    
    private func configureImageView(){
        starImageView.tintColor = .systemYellow
        starImageView.contentMode = .center
        
        //starImageView.image = resizeImage(image: Images.placeholder!, targetSize: CGSize(width: 50, height: 50))
            
        
    }
    
    private func configureRatingLabel(){
        ratingLabel.text = "3.9"
        ratingLabel.font =  UIFont(name: "Montserrat", size: 12)
        ratingLabel.textColor  = .label
        ratingLabel.numberOfLines = 1
    }
    
    private func configureViewsLabel(){
        reviewsLabel.text = "(9002)"
        reviewsLabel.font =  UIFont(name: "Montserrat", size: 12)
        reviewsLabel.textColor  = .secondaryLabel
        reviewsLabel.numberOfLines = 1
        
    }
    
    
    
    private func configureStackView(){
        addSubview(ratingStack)
        ratingStack.translatesAutoresizingMaskIntoConstraints = false
        ratingStack.addArrangedSubview(starImageView)
        ratingStack.addArrangedSubview(ratingLabel)
        ratingStack.addArrangedSubview(reviewsLabel)
       
        ratingStack.axis = .horizontal
        ratingStack.alignment = .fill // .leading .firstBaseline .center .trailing .lastBaseline
        ratingStack.distribution = .fill // .fillEqually .fillProportionally .equalSpacing .equalCentering
        ratingStack.spacing = 5
        
       
            NSLayoutConstraint.activate([
                ratingStack.topAnchor.constraint(equalTo: topAnchor),
                ratingStack.leadingAnchor.constraint(equalTo: leadingAnchor),
                ratingStack.trailingAnchor.constraint(equalTo: trailingAnchor),
                ratingStack.bottomAnchor.constraint(equalTo: bottomAnchor)
                
            ])
        
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    

}
