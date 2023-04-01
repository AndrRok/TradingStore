//
//  ItemInfoVC.swift
//  TradingStore
//
//  Created by ARMBP on 3/12/23.
//

import UIKit

class ItemInfoVC: DataLoadingVC {
    
    private lazy var navBar = UINavigationBar(frame: .zero)
    
    private lazy var scrollView  = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
    private lazy var mainImageView = ItemImage(frame: .zero)
    
    private lazy var itemNameLabel      = UILabel()
    private lazy var itemCategoryLabel  = UILabel()
    private lazy var priceLabel         = UILabel()
    private lazy var descriptionLabel   = UILabel()
    
    private lazy var colorLabel         = UILabel()
    private lazy var colorsStack        = UIStackView()
    
    private let firstColorButton   = UIButton()
    private let secondColorButton  = UIButton()
    private let thirdColorButton   = UIButton()
    
    private lazy var likeAndShareView   = LikeAndShareView()
    private lazy var ratingView         = RatingView()
    private lazy var addToCartView      = AddToCartView()

    private lazy var imagesURLSArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getItemFromAPI()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.subviews.forEach({ $0.removeFromSuperview() }) 
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornersRadius()
    }
    
    
    private func configure(){
        configureNB()
        configureScrollView()
        configureMainImageView()
        configureCollectionView()
        configureItemNameLabel()
        configureItemCategoryLabel()
        configurePriceLabel()
        configureDescriptionLabel()
        configureRatingView()
        configureColorLabel()
        configureColorButtons()
        configureColorsStack()
        configureLikeAndShareView()
        configureAddToCartView()
    }
    
    //MARK: - Network calls
    private func getItemFromAPI(){
        showLoadingView()
        NetworkManager.shared.getItemRequest() { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let itemResult):
                DispatchQueue.main.async { [self] in
                    self.imagesURLSArray = itemResult.imageUrls
                    self.addToCartView = AddToCartView(price: Double(itemResult.price), count: 1)
                    self.configure()
                    self.mainImageView.downloadImage(fromURL: itemResult.imageUrls[1])
                    self.itemNameLabel.text = itemResult.name
                    self.descriptionLabel.text = itemResult.description
                    self.priceLabel.text = "$ \(itemResult.price)"
                    self.itemCategoryLabel.text = "Sneakers"//no data from API
                    self.ratingView.set(rating: itemResult.rating, reviews: itemResult.numberOfReviews)
                    self.firstColorButton.backgroundColor = self.hexStringToUIColor(hex: itemResult.colors[0])
                    self.secondColorButton.backgroundColor = self.hexStringToUIColor(hex: itemResult.colors[1])
                    self.thirdColorButton.backgroundColor = self.hexStringToUIColor(hex: itemResult.colors[2])
                }
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
        }
    }
    
    //MARK: - Configure UI
    private func configureNB(){
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navBar.shadowImage = UIImage()
        let goBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: configuration)
        goBackButton.setImage(image, for: .normal)
        goBackButton.tintColor = .label
        goBackButton.layer.cornerRadius = 10
        goBackButton.layer.masksToBounds = true
        goBackButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        let navItem = UINavigationItem()
        let backButton          = UIBarButtonItem(customView: goBackButton)
        navItem.leftBarButtonItem = backButton
        navBar.setItems([navItem], animated: false)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            navBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        contentView.pinToEdges(of: scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: view.frame.height*1.3)
        ])
    }

    private func configureMainImageView(){
        contentView.addSubview(mainImageView)
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
      
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainImageView.widthAnchor.constraint(equalToConstant: view.frame.width*0.6),
            mainImageView.heightAnchor.constraint(equalToConstant: view.frame.width*0.6)
        ])
    }
    
    
    private func configureCollectionView(){
        contentView.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .top, animated: false)
        }
    }
    
    
    private func configureLikeAndShareView(){
        mainImageView.addSubview(likeAndShareView)
        likeAndShareView.translatesAutoresizingMaskIntoConstraints = false
        likeAndShareView.backgroundColor = Colors.lightGray
        
        NSLayoutConstraint.activate([
            likeAndShareView.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 10),
            likeAndShareView.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -5),
            likeAndShareView.heightAnchor.constraint(equalToConstant: 95),
            likeAndShareView.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    
    private func configureItemNameLabel(){
        contentView.addSubview(itemNameLabel)
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.text = "TestName"
        itemNameLabel.textColor = .label
        itemNameLabel.font =  UIFont(name: "MontserratRoman-Bold", size: 12)
        itemNameLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ])
    }
    
    
    private func configureItemCategoryLabel(){
        contentView.addSubview(itemCategoryLabel)
        itemCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        itemCategoryLabel.text = "TestCategory"
        itemCategoryLabel.textColor = .label
        itemCategoryLabel.font =  UIFont(name: "MontserratRoman-Bold", size: 12)
        itemCategoryLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            itemCategoryLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 10),
            itemCategoryLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor)
        ])
    }
    
    
    private func configurePriceLabel(){
        contentView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.text = "TestPrice"
        priceLabel.textColor = .label
        priceLabel.font =  UIFont(name: "MontserratRoman-Bold", size: 12)
        priceLabel.textAlignment = .right
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: itemNameLabel.topAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    
    private func configureDescriptionLabel(){
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "TestDescription"
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.font =  UIFont(name: "MontserratRoman-Bold", size: 12)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 5
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: itemCategoryLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    
    
    
    private func configureRatingView(){
        contentView.addSubview(ratingView)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ratingView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    private func configureColorLabel(){
        contentView.addSubview(colorLabel)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.text = "Color:"
        colorLabel.textColor = .secondaryLabel
        colorLabel.font =  UIFont(name: "MontserratRoman-Bold", size: 12)
        colorLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            colorLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 10),
            colorLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            colorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    
    private func configureColorsStack(){
        contentView.addSubview(colorsStack)
        colorsStack.addArrangedSubview(firstColorButton)
        colorsStack.addArrangedSubview(secondColorButton)
        colorsStack.addArrangedSubview(thirdColorButton)
        colorsStack.translatesAutoresizingMaskIntoConstraints = false
        colorsStack.axis = .horizontal
        colorsStack.alignment = .center
        colorsStack.distribution = .equalSpacing
        colorsStack.spacing = 10
        
        NSLayoutConstraint.activate([
            colorsStack.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 10),
            colorsStack.leadingAnchor.constraint(equalTo: colorLabel.leadingAnchor, constant: 5),
        ])
    }
    
    
    private func configureColorButtons(){
        let buttonsArray = [firstColorButton, secondColorButton, thirdColorButton]
        for i in buttonsArray{
            i.layer.borderColor = UIColor.darkGray.cgColor
            i.widthAnchor.constraint(equalToConstant: 35).isActive = true
            i.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
        firstColorButton.backgroundColor = .systemBrown
        secondColorButton.backgroundColor = .black
        thirdColorButton.backgroundColor = .systemRed
        firstColorButton.layer.borderWidth = 5
        secondColorButton.layer.borderWidth = 1
        thirdColorButton.layer.borderWidth = 1
        firstColorButton.addTarget(self, action: #selector(chooseFirstColor), for: .touchUpInside)
        secondColorButton.addTarget(self, action: #selector(chooseSecondColor), for: .touchUpInside)
        thirdColorButton.addTarget(self, action: #selector(chooseThirdColor), for: .touchUpInside)
        
    }

    
    private func configureAddToCartView(){
        view.addSubview(addToCartView)
        addToCartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addToCartView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addToCartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addToCartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addToCartView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    private func reloadCollectionView(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    private func setCornersRadius(){
        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 10
        
        likeAndShareView.clipsToBounds = true
        likeAndShareView.layer.cornerRadius = 20
        
        firstColorButton.clipsToBounds = true
        firstColorButton.layer.cornerRadius = 10
        
        secondColorButton.clipsToBounds = true
        secondColorButton.layer.cornerRadius = 10
        
        thirdColorButton.clipsToBounds = true
        thirdColorButton.layer.cornerRadius = 10
    }
    
    
    @objc private func dismissVC(){
        NotificationCenter.default.post(name: Notification.Name("changeIndexFromItemInfoToToExplorer"), object: nil)
    }
    
    //MARK: - Buttons' actions
    @objc func chooseFirstColor(){
        firstColorButton.layer.borderWidth = 5
        secondColorButton.layer.borderWidth = 1
        thirdColorButton.layer.borderWidth = 1
    }
    
    
    @objc func chooseSecondColor(){
        firstColorButton.layer.borderWidth = 1
        secondColorButton.layer.borderWidth = 5
        thirdColorButton.layer.borderWidth = 1
    }
    
    
    @objc func chooseThirdColor(){
        firstColorButton.layer.borderWidth = 1
        secondColorButton.layer.borderWidth = 1
        thirdColorButton.layer.borderWidth = 5
        
    }
    
    
    //MARK: - Convert color
    private func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ItemInfoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLSArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.reuseID, for: indexPath) as! CarouselCell
        let itemImage = imagesURLSArray[indexPath.row]
        cell.setImages(url: itemImage)
        return cell
    }
    
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates(nil, completion: nil)
        mainImageView.downloadImage(fromURL: imagesURLSArray[indexPath.row])
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.indexPathsForSelectedItems?.first {
        case .some(indexPath):
            return CGSize(width: collectionView.frame.width/4 + 20, height: collectionView.frame.height * 0.6 + 10)
        default:
    
            return CGSize(width:  collectionView.frame.width/4, height: collectionView.frame.height * 0.6)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = Int(collectionView.frame.width/4) * imagesURLSArray.count
        let totalSpacingWidth = 20 * (imagesURLSArray.count - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}
