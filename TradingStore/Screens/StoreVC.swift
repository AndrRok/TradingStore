//
//  StoreVC.swift
//  TradingStore
//
//  Created by ARMBP on 3/12/23.
//

import UIKit


class StoreVC: DataLoadingVC {
    private var timer: Timer?
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createLayout(in: view))
    
    private lazy var searchTextField        = CustomTextField(frame: .zero)
    private lazy var dropDownTableView      = DropDownTableView()
    
    private lazy var titleLabel             = UILabel()
    
    private lazy var sideMenuButton         = UIButton()
    private lazy var profileButton          = UIButton()
    private lazy var locationButton         = UIButton()
    
    private lazy var chevronDownImage       = UIImageView()
    
    private lazy var latests:    [Latests]      = []
    private lazy var flashSales: [FlashSales]   = []
    private var searchArray:     [String]  = []
    private lazy var imageNameMain  = String()
    public  lazy var usersFirstName = String()
    
    private lazy var tableViewConfigured = Bool()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        view.backgroundColor = .systemBackground
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageNameMain = PersistenceManager.sharedRealm.getUserById(primaryKey: usersFirstName).imageIdentifier
        congifure()
        self.view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornersRadius()
    }
    
    
    private func congifure(){
        getLatestFromAPI()
        configureProfileButton()
        configureSideMenuButton()
        configureTitleLabel()
        configureLocationButton()
        configureSearchTextField()
        configureCollectionView()
        view.bringSubviewToFront(dropDownTableView)
    }
    
    //MARK: - Network calls
    private func getLatestFromAPI(){
        NetworkManager.shared.getLatestRequest() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let latestsResult):
                self.latests = latestsResult.latest
                self.getFlashSalesFromAPI()
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
        }
    }
    
    
    private func getFlashSalesFromAPI(){
        NetworkManager.shared.getFlashSalesRequest() { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let flashSalesResult):
                self.flashSales = flashSalesResult.flashSale
                self.reloadCollectionView()
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
        }
    }
    
    
    private func getSearchRequestFromAPI(){
        NetworkManager.shared.getSearchRequest() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let flashSalesResult):
                self.searchArray = flashSalesResult.words
                DispatchQueue.main.async {
                    let filteredSearchRequest = self.searchArray.filter { $0.lowercased().hasPrefix((self.searchTextField.text ?? "").lowercased()) }
                    self.dropDownTableView = DropDownTableView(searchArray: filteredSearchRequest)
                    switch self.view.subviews.contains(self.dropDownTableView)  {//check if view already exists
                    case false:
                        self.configureDropDownTableView()
                        self.reloadTableView()
                    default:
                        break
                    }
                }
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
        }
    }
    
    //MARK: - Configure UI
    private func configureSearchTextField(){
        view.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.autocapitalizationType = .none
        searchTextField.font = UIFont(name: "Montserrat", size: 15)
        searchTextField.placeholder = "What are you looking for?"
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let magnifyingglassView    = UIImageView()
        magnifyingglassView.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 10)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: configuration)
        magnifyingglassView.image = image
        magnifyingglassView.tintColor = .label
        searchTextField.addSubview(magnifyingglassView)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            magnifyingglassView.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: -10),
            magnifyingglassView.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            
        ])
    }
    
    
    private func configureDropDownTableView(){
        view.addSubview(dropDownTableView)
        dropDownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropDownTableView.layer.borderColor = UIColor.systemGray5.cgColor
        dropDownTableView.layer.borderWidth = 0.5
        dropDownTableView.estimatedRowHeight = 40
        dropDownTableView.rowHeight = UITableView.automaticDimension
        //dropDownTableView.isHidden = true
        
        NSLayoutConstraint.activate([
            dropDownTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            dropDownTableView.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            dropDownTableView.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor)
        ])
        
    }
    
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseID)
        collectionView.register(LatestCell.self, forCellWithReuseIdentifier: LatestCell.reuseID)
        collectionView.register(FlashSaleCell.self, forCellWithReuseIdentifier: FlashSaleCell.reuseID)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseID)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)//adds space in the end of tableView
        collectionView.contentInset = insets
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func configureTitleLabel(){
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "MontserratRoman-Bold", size: 20)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        
        let stringOne = "Trade by bata"
        let stringTwo = "bata"
        let range = (stringOne as NSString).range(of: stringTwo)
        let attributedText = NSMutableAttributedString.init(string: stringOne)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.306, green: 0.333, blue: 0.843, alpha: 1).cgColor , range: range)
        titleLabel.attributedText = attributedText
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: sideMenuButton.trailingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: profileButton.leadingAnchor)
        ])
    }
    
    
    private func configureProfileButton(){
        view.addSubview(profileButton)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.layer.borderColor = UIColor.systemGray.cgColor
        profileButton.layer.borderWidth = 2
        profileButton.addTarget(self, action: #selector(goProfileVC), for: .touchUpInside)
        DispatchQueue.main.async { [self] in
            profileButton.setImage(resizeImage(image: loadImageNamed(name: imageNameMain) ?? Images.placeholder!, targetSize: CGSize(width: 80, height: 80)), for: .normal)
        }
        
        NSLayoutConstraint.activate([
            profileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileButton.heightAnchor.constraint(equalToConstant: 50),
            profileButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func configureSideMenuButton(){
        view.addSubview(sideMenuButton)
        sideMenuButton.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "line.3.horizontal", withConfiguration: configuration)
        sideMenuButton.setImage(image, for: .normal)
        sideMenuButton.tintColor = .label
        
        NSLayoutConstraint.activate([
            sideMenuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            sideMenuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
    }
    
    
    private func configureLocationButton(){
        view.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 14)
        let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        chevronDownImage.image = image
        chevronDownImage.tintColor = .label
        chevronDownImage.translatesAutoresizingMaskIntoConstraints = false
        locationButton.addSubview(chevronDownImage)
        locationButton.setTitle("Location", for: .normal)
        locationButton.titleLabel?.font = UIFont(name: "Montserrat", size: 14)
        locationButton.setTitleColor(.label, for: .normal)
        
        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: 10),
            locationButton.trailingAnchor.constraint(equalTo: profileButton.trailingAnchor),
            locationButton.widthAnchor.constraint(equalToConstant: 100),
            
            chevronDownImage.trailingAnchor.constraint(equalTo: locationButton.trailingAnchor, constant: -5),
            chevronDownImage.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor)
        ])
    }
    
    //MARK: - SetCornersRadius
    private func setCornersRadius(){
        profileButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 0.5 * profileButton.bounds.size.width
        dropDownTableView.clipsToBounds = true
        dropDownTableView.layer.cornerRadius = 10
    }
    
    
    //MARK: - TextField did started to change func
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        timer?.invalidate()
        switch searchTextField.text?.isEmpty{
        case true:
            
            searchArray.removeAll()
            DispatchQueue.main.async {
                self.dropDownTableView.removeFromSuperview()
            }
        default:
            searchArray.removeAll()
            DispatchQueue.main.async {
                self.dropDownTableView.removeFromSuperview()
            }
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false){ [self] _ in
                self.getSearchRequestFromAPI()
            }
        }
    }
    
    
    //MARK: - Buttons' func
    @objc private func goProfileVC(){
        NotificationCenter.default.post(name: Notification.Name("changeIndexToProfileVC"), object: nil)
    }
    
    
    //MARK: - ReloadCollectionView
    private func reloadCollectionView(){
        DispatchQueue.main.async{
            self.collectionView.reloadData()
        }
    }
    
    
    //MARK: - ReloadTableView
    private func reloadTableView(){
        DispatchQueue.main.async{
            self.dropDownTableView.reloadData()
        }
    }
    
    
    //MARK: - DismissKeyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dropDownTableView.removeFromSuperview()
        self.view.endEditing(true)
    }
    
    
    //MARK: - Configure Image Name path
    private func getDocumentsURL() -> NSURL {
        let documentsURL = FileManager.default.temporaryDirectory
        return documentsURL as NSURL
    }
    
    
    private func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL?.path ?? ""
    }
    
    
    private func loadImageNamed(name: String) -> UIImage? {
        let imagePath = fileInDocumentsDirectory(filename: name)
        let image = UIImage(contentsOfFile: imagePath)
        if image == nil {
            print("missing image at: file://\(imagePath)")
        }
        print("Loading image from path: file://\(imagePath)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
    }
    
    
    //MARK: - ResizeImage
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
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


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension StoreVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return Images.categoriesImages.count
        case 1:
            return latests.count
        case 2:
            return flashSales.count
        default:
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch (indexPath.section) {
        case 0://Categories
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseID, for: indexPath) as! CategoryCell
            let image = Images.categoriesImages[indexPath.row]
            cell.setImages(image: image!)
            return cell
        case 1:// Latest
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LatestCell.reuseID, for: indexPath) as! LatestCell
            let latest = latests[indexPath.row]
            cell.setLatest(latest: latest)
            return cell
        case 2:// Flash Sale
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlashSaleCell.reuseID, for: indexPath) as! FlashSaleCell
            let flashSale = flashSales[indexPath.row]
            cell.setFlashSale(flashSale: flashSale, userName: usersFirstName)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseID, for: indexPath) as! SectionHeader
            switch (indexPath.section) {
            case 1:
                sectionHeader.label.text = "Latest"
            case 2:
                sectionHeader.label.text = "Flash Sale"
            default:
                break
            }
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            NotificationCenter.default.post(name: Notification.Name("changeIndexToItemInfoVC"), object: nil)
        default:
            break
        }
    }
}

//MARK: - UITextFieldDelegate
extension StoreVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case searchTextField:
            searchTextField.placeholder = ""

        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case searchTextField:
            searchTextField.placeholder = "What are you looking for?"
            //textFieldDidEndEditing = true
            timer?.invalidate()
            
            DispatchQueue.main.async {
                self.dropDownTableView.removeFromSuperview()
            }
            
        default:
            break
        }
    }
}
