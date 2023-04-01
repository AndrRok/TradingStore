//
//  FlashSaleCell.swift
//  TradingStore
//
//  Created by ARMBP on 3/20/23.
//

import UIKit

class FlashSaleCell: UICollectionViewCell {
    static let reuseID = "flashSaleCell"
    private lazy var imageImageView = ItemImage(frame: .zero)
    private lazy var userImage = UIImageView()
    
    private lazy var titleLabel     = UITextView()
    private lazy var fullPriceLabel = UITextView()
    private lazy var categoryLabel  = UITextView()
    private lazy var discountLabel  = UITextView()
    
    private lazy var addToFavoritesButton   = UIButton()
    private lazy var plusButton             = UIButton()
    
    public var item: FlashSales!
    private var usersFirstName = String()
    
    private lazy var inFavorites = Bool()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    private func configure(){
        configureImageView()
        configurePlusButton()
        configureAddToFavoritesButton()
        configureUserImage()
        configureLabels()
        bringSubviewToFront(contentView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornersRadius()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        DispatchQueue.main.async{
            self.imageImageView.image = Images.placeholder
        }
    }
    
    
    public func setFlashSale(flashSale: FlashSales, userName: String){
        item = flashSale
        usersFirstName = userName
        DispatchQueue.main.async{ [self] in
            imageImageView.downloadImage(fromURL: flashSale.imageUrl)
            titleLabel.text = flashSale.name
            fullPriceLabel.text = "$\(formatNumber(flashSale.price) ?? "Sold out")"
            categoryLabel.text = flashSale.category
            discountLabel.text = "\(String(flashSale.discount))% off"
            
            guard PersistenceManager.sharedRealm.favoriteObjectExist(primaryKey: usersFirstName, imageIdentifier: item.imageUrl) else {
                addToFavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
                return
            }
            addToFavoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    //MARK: - Configure UI
    private func configureImageView(){
        addSubview(imageImageView)
        imageImageView.translatesAutoresizingMaskIntoConstraints = false
        imageImageView.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            imageImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    private func configureAddToFavoritesButton(){
        contentView.addSubview(addToFavoritesButton)
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavoritesButton.backgroundColor = .white
        addToFavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        addToFavoritesButton.tintColor = Colors.mainOrangeColor
        addToFavoritesButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addToFavoritesButton.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -10),
            addToFavoritesButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            addToFavoritesButton.widthAnchor.constraint(equalToConstant: 30),
            addToFavoritesButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    private func configurePlusButton(){
        contentView.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.backgroundColor = .white
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = Colors.mainOrangeColor
        plusButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            plusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            plusButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    private func configureLabels(){
        imageImageView.addSubviews(fullPriceLabel, titleLabel, categoryLabel, discountLabel)
        let labelsArray = [fullPriceLabel, titleLabel, categoryLabel, discountLabel]
        for i in labelsArray{
            i.translatesAutoresizingMaskIntoConstraints = false
            i.isUserInteractionEnabled      = false
            i.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            i.isScrollEnabled = false
            i.textColor = .white
            i.font =  UIFont(name: "Montserrat", size: 16)
        }
        
        fullPriceLabel.textContainer.maximumNumberOfLines = 1
        categoryLabel.textContainer.maximumNumberOfLines = 1
        discountLabel.textContainer.maximumNumberOfLines = 1
        
        categoryLabel.backgroundColor = .systemGray.withAlphaComponent(0.8)
        titleLabel.backgroundColor = .black.withAlphaComponent(0.8)
        fullPriceLabel.backgroundColor = .black.withAlphaComponent(0.8)
        discountLabel.backgroundColor = .systemGray.withAlphaComponent(0.0)
        discountLabel.backgroundColor = .systemRed
        
        fullPriceLabel.textAlignment = .left
        titleLabel.textAlignment = .left
        categoryLabel.textAlignment = .left
        discountLabel.textAlignment = .right
        
        
        NSLayoutConstraint.activate([
            discountLabel.topAnchor.constraint(equalTo: imageImageView.topAnchor, constant: 10),
            discountLabel.trailingAnchor.constraint(equalTo: imageImageView.trailingAnchor, constant: -10),
            //discountLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 60),
            
            fullPriceLabel.bottomAnchor.constraint(equalTo: imageImageView.bottomAnchor, constant: -15),
            fullPriceLabel.leadingAnchor.constraint(equalTo: imageImageView.leadingAnchor, constant: 5),
            
            titleLabel.bottomAnchor.constraint(equalTo: fullPriceLabel.topAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: imageImageView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: addToFavoritesButton.centerXAnchor, constant: -2),
            
            categoryLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5),
            categoryLabel.leadingAnchor.constraint(equalTo: imageImageView.leadingAnchor, constant: 5),
        ])
    }
    
    
    private func setCornersRadius(){
        contentView.layer.cornerRadius = 20
        imageImageView.layer.cornerRadius = 20
        addToFavoritesButton.clipsToBounds = true
        addToFavoritesButton.layer.cornerRadius = 0.5 * addToFavoritesButton.bounds.size.width
        addToFavoritesButton.layer.masksToBounds = false
        addToFavoritesButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addToFavoritesButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        addToFavoritesButton.layer.shadowOpacity = 1.0
        addToFavoritesButton.layer.shadowRadius = 5.0
        
        plusButton.clipsToBounds = true
        plusButton.layer.cornerRadius = 0.5 * plusButton.bounds.size.width
        plusButton.layer.masksToBounds = false
        plusButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        plusButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        plusButton.layer.shadowOpacity = 1.0
        plusButton.layer.shadowRadius = 5.0
        
        let labelsArray = [fullPriceLabel, titleLabel, categoryLabel, discountLabel]
        for i in labelsArray{
            i.clipsToBounds = true
            i.layer.cornerRadius = 10
        }
        
        userImage.setRounded()
    }
    
    
    private func configureUserImage(){
        imageImageView.addSubview(userImage)
        userImage.image = resizeImage(image: Images.placeholder!, targetSize: CGSize(width: 50, height: 50))
        userImage.contentMode = .scaleAspectFit
        userImage.contentMode = .center
        userImage.layer.borderColor = UIColor.systemGray.cgColor
        userImage.layer.borderWidth = 2
        userImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userImage.leadingAnchor.constraint(equalTo: imageImageView.leadingAnchor, constant: 5),
            userImage.topAnchor.constraint(equalTo: imageImageView.topAnchor, constant: 5),
            userImage.widthAnchor.constraint(equalToConstant: 50),
            userImage.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    //MARK: - Resize image
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
    
    
    //MARK: - Format Number
    private func formatNumber(_ number: Double) -> String? {
       let formatter = NumberFormatter()
       formatter.minimumFractionDigits = 2 // minimum number of fraction digits on right
       formatter.maximumFractionDigits = 2 // maximum number of fraction digits on right, or comment for all available
       formatter.minimumIntegerDigits = 1 // minimum number of integer digits on left (necessary so that 0.5 don't return .500)
       let formattedNumber = formatter.string(from: NSNumber.init(value: number))
       return formattedNumber
    }
    
    
    //MARK: - Buttons' actions
    @objc private func addToFavorites(){
        inFavorites = PersistenceManager.sharedRealm.favoriteObjectExist(primaryKey: usersFirstName, imageIdentifier: item.imageUrl)
        switch inFavorites {
        case true:
            addToFavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
            PersistenceManager.sharedRealm.editUserFavorites(idUserForEdit: usersFirstName, imageIdentifier: item.imageUrl, add: false)
        default:
            addToFavoritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            PersistenceManager.sharedRealm.editUserFavorites(idUserForEdit: usersFirstName, imageIdentifier: item.imageUrl, add: true)
        }
    }
    
    
    @objc private func addToCart(){
        
    }
}
