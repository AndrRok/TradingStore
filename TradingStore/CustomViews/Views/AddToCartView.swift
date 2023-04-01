//
//  AddToCartView.swift
//  TradingStore
//
//  Created by ARMBP on 3/24/23.
//

import UIKit

class AddToCartView: UIView {
    
    private lazy var quanntityLabel     = UILabel()
    private lazy var countLabel         = UILabel()
    private lazy var plusButton         = UIButton()
    private lazy var minusButton        = UIButton()
    private lazy var addToCartButton    = UIButton()
    
    lazy var priceLabel = UILabel()
    lazy var addToCartLabel = UILabel()
    
    private var count = Int()
    private var price = Double()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.darkBlue
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(price: Double, count: Int) {
        self.init(frame: .zero)
        
        priceLabel.text =  "$ \(String(describing: formatNumber(price)!))"
        self.count = count
        self.price = price
        countLabel.text = String(count)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 30, height:  30))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        configure()
        setCornersRadius()
    }
    
    
    private func configure(){
        configureQuanntityLabel()
        configureCountLabel()
        configureMinusButton()
        configurePlusButton()
        configureAddToCartButton()
    }
    
    
    private func configureButtonLabels(){
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textColor = .white
        priceLabel.font =  UIFont(name: "MontserratRoman-Bold", size: 8)
        
        addToCartLabel.translatesAutoresizingMaskIntoConstraints = false
        addToCartLabel.text = "ADD TO CART"
        addToCartLabel.textColor = .white
        addToCartLabel.font =  UIFont(name: "MontserratRoman-Bold", size: 12)
    }
    
    private func configureQuanntityLabel(){
        addSubview(quanntityLabel)
        quanntityLabel.translatesAutoresizingMaskIntoConstraints = false
        quanntityLabel.text = "Quantity:"
        quanntityLabel.textColor = .systemGray
        quanntityLabel.font =  UIFont(name: "Montserrat", size: 12)
        
        NSLayoutConstraint.activate([
            quanntityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            quanntityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }
    
    private func configureCountLabel(){
        addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        countLabel.textColor = .white
        countLabel.font =  UIFont(name: "Montserrat", size: 12)
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            countLabel.leadingAnchor.constraint(equalTo: quanntityLabel.trailingAnchor, constant: 10),
        ])
    }
    
    private func configureMinusButton(){
        addSubview(minusButton)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
        minusButton.tintColor = .white
        
        minusButton.backgroundColor = Colors.customPurple
        
        minusButton.addTarget(self, action: #selector(minusAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            minusButton.topAnchor.constraint(equalTo: quanntityLabel.bottomAnchor, constant: 20),
            minusButton.leadingAnchor.constraint(equalTo: quanntityLabel.leadingAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func configurePlusButton(){
        addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = .white
        plusButton.backgroundColor = Colors.customPurple
        
        plusButton.addTarget(self, action: #selector(plusAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: minusButton.topAnchor),
            plusButton.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor, constant: 25),
            plusButton.widthAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    
    private func configureAddToCartButton(){
        configureButtonLabels()
        addSubview(addToCartButton)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.addSubviews(priceLabel, addToCartLabel)
        addToCartButton.backgroundColor = Colors.customPurple
        addToCartButton.layer.cornerRadius = 30
        addToCartButton.addTarget(self, action: #selector(goCartVC), for: .touchUpInside)
      
        
        NSLayoutConstraint.activate([
            addToCartButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            addToCartButton.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor, constant: 25),
            addToCartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            addToCartButton.bottomAnchor.constraint(equalTo: plusButton.bottomAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: addToCartButton.leadingAnchor, constant: 20),
            priceLabel.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor),
            
            addToCartLabel.trailingAnchor.constraint(equalTo: addToCartButton.trailingAnchor, constant: -20),
            addToCartLabel.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor)
        ])
        
        
    }
    
    private func setCornersRadius(){
        minusButton.clipsToBounds = true
        minusButton.layer.cornerRadius = 10
        
        plusButton.clipsToBounds = true
        plusButton.layer.cornerRadius = 10
        
        addToCartButton.clipsToBounds = true
        addToCartButton.layer.cornerRadius = 10
    }
    
    
    @objc private func goCartVC(){
        NotificationCenter.default.post(name: Notification.Name("changeIndexToCart"), object: nil)
    }
    
    
    @objc private func plusAction(){
        count += 1
        countLabel.text = String(count)
        priceLabel.text =  "$ \(String(describing: formatNumber(price*Double(count))!))"
    }
    
    @objc private func minusAction(){
        
       
        switch count {
        
        case 1...:
            count -= 1
            priceLabel.text =  "$ \(String(describing: formatNumber(price*Double(count))!))"
            countLabel.text = String(count)
        default:
            break
        }
        
    }
    
    
    private func formatNumber(_ number: Double) -> String? {
       let formatter = NumberFormatter()
       formatter.minimumFractionDigits = 2 // minimum number of fraction digits on right
       formatter.maximumFractionDigits = 2 // maximum number of fraction digits on right, or comment for all available
       formatter.minimumIntegerDigits = 1 // minimum number of integer digits on left (necessary so that 0.5 don't return .500)
       let formattedNumber = formatter.string(from: NSNumber.init(value: number))
       return formattedNumber
    }
}
