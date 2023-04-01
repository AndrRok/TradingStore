//
//  LatestCell.swift
//  TradingStore
//
//  Created by ARMBP on 3/20/23.
//




import UIKit



class LatestCell: UICollectionViewCell {
    
    static  let reuseID = "latestCell"
    private lazy var imageImageView = ItemImage(frame: .zero)
    private lazy var titleLabel  = UITextView()
    private lazy var fullPriceLabel = UITextView()
    private lazy var categoryLabel = UITextView()
    private lazy var plusButton  = UIButton()
    public var item: Latests!
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
        configurePlusButton()
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
    
    
    public func setLatest(latest: Latests){
        item = latest
        DispatchQueue.main.async{ [self] in
            imageImageView.downloadImage(fromURL: latest.imageUrl)
            titleLabel.text = latest.name
            fullPriceLabel.text = "$\(formatNumber(latest.price) ?? "Sold out")"
            categoryLabel.text = latest.category
        }
    }
    
    
    private func configureImageView(){
        addSubview(imageImageView)
        imageImageView.translatesAutoresizingMaskIntoConstraints = false
        imageImageView.contentMode = .scaleToFill
        
        NSLayoutConstraint.activate([
            imageImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    private func configurePlusButton(){
        contentView.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.backgroundColor = .white
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = Colors.mainOrangeColor
        
        NSLayoutConstraint.activate([
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            plusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            plusButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    private func configureLabels(){
        imageImageView.addSubviews(titleLabel, fullPriceLabel, categoryLabel)
        let labelsArray = [fullPriceLabel, titleLabel, categoryLabel]
        for i in labelsArray{
            i.translatesAutoresizingMaskIntoConstraints = false
            i.isUserInteractionEnabled = false
            i.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            i.textColor = .white
            i.backgroundColor = .black.withAlphaComponent(0.8)
            i.isScrollEnabled = false
            i.font =  UIFont(name: "Montserrat", size: 12)
        }
        categoryLabel.backgroundColor = .systemGray.withAlphaComponent(0.8)
        fullPriceLabel.textContainer.maximumNumberOfLines = 1
        categoryLabel.textContainer.maximumNumberOfLines = 1
        titleLabel.textContainer.lineBreakMode = .byWordWrapping
        
        NSLayoutConstraint.activate([
            fullPriceLabel.bottomAnchor.constraint(equalTo: imageImageView.bottomAnchor, constant: -15),
            fullPriceLabel.leadingAnchor.constraint(equalTo: imageImageView.leadingAnchor, constant: 5),
            
            titleLabel.bottomAnchor.constraint(equalTo: fullPriceLabel.topAnchor, constant: -30),
            titleLabel.leadingAnchor.constraint(equalTo: imageImageView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: plusButton.centerXAnchor, constant: -2),
            
            categoryLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5),
            categoryLabel.leadingAnchor.constraint(equalTo: imageImageView.leadingAnchor, constant: 5),
        ])
    }
    
    
    private func setCornersRadius(){
        contentView.layer.cornerRadius = 20
        imageImageView.layer.cornerRadius = 20
        
        plusButton.clipsToBounds = true
        plusButton.layer.cornerRadius = 0.5 * plusButton.bounds.size.width
        plusButton.layer.masksToBounds = false
        plusButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        plusButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        plusButton.layer.shadowOpacity = 1.0
        plusButton.layer.shadowRadius = 5.0
        
        let labelsArray = [fullPriceLabel, titleLabel, categoryLabel]
        for i in labelsArray{
            i.clipsToBounds = true
            i.layer.cornerRadius = 5
        }
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
    
}
