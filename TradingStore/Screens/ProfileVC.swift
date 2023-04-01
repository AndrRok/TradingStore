//
//  ProfileVC.swift
//  TradingStore
//
//  Created by ARMBP on 3/12/23.
//



import UIKit

class ProfileVC: UIViewController {
    
    private lazy var tradeStoreLeftImageView         = UIImageView()
    private lazy var paymentMethodLeftImageView      = UIImageView()
    private lazy var balanceLeftImageView            = UIImageView()
    private lazy var tradeHistoryLeftImageView       = UIImageView()
    private lazy var restorePurchaseLeftImageView    = UIImageView()
    private lazy var helpLeftImageView               = UIImageView()
    private lazy var logOutLeftImageView             = UIImageView()
    
    private lazy var profileInfoStack        = UIStackView()
    private lazy var profileOptionsStack     = UIStackView()
    
    private lazy var titleLabel  = UILabel()
    private lazy var nameLabel   = UILabel()
    
    private lazy var goBackButton                = UIButton()
    private lazy var changeProfilePhotoButton    = UIButton()
    private lazy var uploadItemButton            = UIButton()

    private lazy var tradeStoreButton            = UIButton()
    private lazy var paymentMethodButton         = UIButton()
    private lazy var balanceButton               = UIButton()
    private lazy var tradeHistoryButton          = UIButton()
    private lazy var restorePurchaseButton       = UIButton()
    private lazy var helpButton                  = UIButton()
    private lazy var logOutButton                = UIButton()
    
    private lazy var profileView                = UIView()
    
    private lazy var imagePicker                = UIImagePickerController()
    private var imageNameMain                   = String()
    public var firstName                        = String()
    
    private lazy var uploadButtonImage = UIImageView()
    private lazy var imageImageView = ItemImage(frame: .zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageNameMain = PersistenceManager.sharedRealm.getUserById(primaryKey: firstName).imageIdentifier
        configure()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            imageImageView.setRounded()
            tradeStoreLeftImageView.setRounded()
            paymentMethodLeftImageView.setRounded()
            balanceLeftImageView.setRounded()
            tradeHistoryLeftImageView.setRounded()
            restorePurchaseLeftImageView.setRounded()
            helpLeftImageView.setRounded()
            logOutLeftImageView.setRounded()
    }
    
    
    private func configure(){
        configureTitleLabel()
        configureProfileView()
        configureProfilePhoto()
        configureChangeProfilePhotoButton()
        configureNameLabel()
        configureProfileInfoStackView()
        configureUploadItemButton()
        configureTradeStoreButton()
        configurePaymentMethodButton()
        configureBalanceButton()
        configureTradeHistoryButton()
        configureRestorePurchaseButton()
        configureHelpButton()
        configureLogOutButton()
        configureProfileOptionsStackView()
        configureGoBackButton()
    }
 
    
    //MARK: - Configure UI
    private func configureGoBackButton(){
        view.addSubview(goBackButton)
        goBackButton.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: configuration)
        goBackButton.setImage(image, for: .normal)
        goBackButton.tintColor = .label
        goBackButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            goBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
    }
    
    
    private func configureTitleLabel(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "MontserratRoman-Bold", size: 20)
        titleLabel.textColor = .label
        titleLabel.text = "Profile"
    
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    private func configureNameLabel(){
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "MontserratRoman-Bold", size: 20)
        nameLabel.textColor = .label
        nameLabel.text = firstName
        
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureProfileView(){
        profileView.addSubviews(imageImageView, changeProfilePhotoButton)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileView.widthAnchor.constraint(equalToConstant: 100),
            profileView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    
    private func configureChangeProfilePhotoButton(){
        changeProfilePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        changeProfilePhotoButton.setTitle("Change photo", for: .normal)
        changeProfilePhotoButton.titleLabel?.font =  UIFont(name: "Montserrat", size: 10)
        changeProfilePhotoButton.setTitleColor(.systemGray, for: .normal)
        changeProfilePhotoButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            changeProfilePhotoButton.topAnchor.constraint(equalTo: imageImageView.bottomAnchor),
            changeProfilePhotoButton.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            changeProfilePhotoButton.widthAnchor.constraint(equalToConstant: 120),
            changeProfilePhotoButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    private func configureProfilePhoto(){
        profileView.addSubview(imageImageView)
        imageImageView.tintColor = .systemGray
        imageImageView.layer.borderWidth  = 2
        imageImageView.layer.borderColor = UIColor.systemGray.cgColor
        imageImageView.translatesAutoresizingMaskIntoConstraints = false
        imageImageView.contentMode = .scaleAspectFill
        DispatchQueue.main.async { [self] in
            imageImageView.image = loadImageNamed(name: imageNameMain) ?? Images.placeholder!
        }

        NSLayoutConstraint.activate([
            imageImageView.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            imageImageView.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),
            imageImageView.widthAnchor.constraint(equalToConstant: 60),
            imageImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    private func configureProfileInfoStackView(){
        view.addSubview(profileInfoStack)
        profileInfoStack.translatesAutoresizingMaskIntoConstraints = false
        profileInfoStack.addArrangedSubview(titleLabel)
        profileInfoStack.addArrangedSubview(profileView)
        profileInfoStack.addArrangedSubview(nameLabel)
        profileInfoStack.axis = .vertical
        profileInfoStack.alignment = .center
        profileInfoStack.distribution = .equalSpacing
        profileInfoStack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        profileInfoStack.isLayoutMarginsRelativeArrangement = true
        profileInfoStack.spacing = 5
        
        NSLayoutConstraint.activate([
            profileInfoStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileInfoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileInfoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            profileInfoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            profileInfoStack.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    private func configureUploadItemButton(){
        view.addSubview(uploadItemButton)
        uploadItemButton.translatesAutoresizingMaskIntoConstraints = false
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        let appleLogoResized = UIImage(systemName: "square.and.arrow.up", withConfiguration: largeConfig)
        let appleLogo = UIImageView(image: appleLogoResized)
        appleLogo.translatesAutoresizingMaskIntoConstraints = false
        uploadItemButton.addSubview(appleLogo)
        uploadItemButton.tintColor = .white
        uploadItemButton.titleLabel?.font = UIFont(name: "MontserratRoman-Bold", size: 14)
        uploadItemButton.setTitle("Upload item", for: .normal)
        uploadItemButton.backgroundColor = UIColor(red: 0.306, green: 0.333, blue: 0.843, alpha: 1)
        uploadItemButton.layer.cornerRadius = 30
        
        NSLayoutConstraint.activate([
            uploadItemButton.topAnchor.constraint(equalTo: profileInfoStack.bottomAnchor, constant: 20),
            uploadItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadItemButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            uploadItemButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            uploadItemButton.heightAnchor.constraint(equalToConstant: 60),
            uploadItemButton.widthAnchor.constraint(equalToConstant: 100),
            
            appleLogo.trailingAnchor.constraint(equalTo: uploadItemButton.titleLabel!.leadingAnchor, constant: -20),
            appleLogo.centerYAnchor.constraint(equalTo: uploadItemButton.centerYAnchor)
        ])
    }
    
    
    //MARK: - Options buttons
    private func configureTradeStoreButton(){
        let configuration = UIImage.SymbolConfiguration(pointSize: 15)
        let image = UIImage(systemName: "creditcard.circle.fill", withConfiguration: configuration)
        tradeStoreLeftImageView.image = image
        tradeStoreLeftImageView.contentMode = .scaleAspectFit
        tradeStoreLeftImageView.contentMode = .center
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.text = "Trade store"
        buttonTitleLabel.font =  UIFont(name: "Montserrat", size: 20)
        let rightImageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
        rightImageView.tintColor = .black
        tradeStoreButton.addSubviews(tradeStoreLeftImageView, buttonTitleLabel, rightImageView)
        tradeStoreLeftImageView.backgroundColor = .systemGray6
        tradeStoreLeftImageView.tintColor = .label
      
        tradeStoreButton.translatesAutoresizingMaskIntoConstraints = false
        tradeStoreLeftImageView.translatesAutoresizingMaskIntoConstraints = false
        buttonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tradeStoreButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.9),
            
            tradeStoreLeftImageView.leadingAnchor.constraint(equalTo: tradeStoreButton.leadingAnchor, constant: 5),
            tradeStoreLeftImageView.centerYAnchor.constraint(equalTo: tradeStoreButton.centerYAnchor),
            tradeStoreLeftImageView.widthAnchor.constraint(equalToConstant: 30),
            tradeStoreLeftImageView.heightAnchor.constraint(equalToConstant: 30),
            
            buttonTitleLabel.leadingAnchor.constraint(equalTo: tradeStoreLeftImageView.trailingAnchor, constant: 5),
            buttonTitleLabel.centerYAnchor.constraint(equalTo: tradeStoreButton.centerYAnchor),
            
            rightImageView.trailingAnchor.constraint(equalTo: tradeStoreButton.trailingAnchor, constant: -5),
            rightImageView.centerYAnchor.constraint(equalTo: tradeStoreButton.centerYAnchor),
        ])
    }
    
    
    private func configurePaymentMethodButton(){
        let configuration = UIImage.SymbolConfiguration(pointSize: 15)
        let image = UIImage(systemName: "creditcard.circle.fill", withConfiguration: configuration)
        paymentMethodLeftImageView.image = image
        paymentMethodLeftImageView.contentMode = .scaleAspectFit
        paymentMethodLeftImageView.contentMode = .center
        
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.text = "Payment method"
        buttonTitleLabel.font =  UIFont(name: "Montserrat", size: 20)
        let rightImageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
        rightImageView.tintColor = .black
        paymentMethodButton.addSubviews(paymentMethodLeftImageView, buttonTitleLabel, rightImageView)
        paymentMethodLeftImageView.backgroundColor = .systemGray6
        paymentMethodLeftImageView.tintColor = .label
        paymentMethodButton.translatesAutoresizingMaskIntoConstraints = false
        paymentMethodLeftImageView.translatesAutoresizingMaskIntoConstraints = false
        buttonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            paymentMethodButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.9),
            
            paymentMethodLeftImageView.leadingAnchor.constraint(equalTo: paymentMethodButton.leadingAnchor, constant: 5),
            paymentMethodLeftImageView.centerYAnchor.constraint(equalTo: paymentMethodButton.centerYAnchor),
            paymentMethodLeftImageView.widthAnchor.constraint(equalToConstant: 30),
            paymentMethodLeftImageView.heightAnchor.constraint(equalToConstant: 30),
            
            buttonTitleLabel.leadingAnchor.constraint(equalTo: paymentMethodLeftImageView.trailingAnchor, constant: 5),
            buttonTitleLabel.centerYAnchor.constraint(equalTo: paymentMethodButton.centerYAnchor),
            
            rightImageView.trailingAnchor.constraint(equalTo: paymentMethodButton.trailingAnchor, constant: -5),
            rightImageView.centerYAnchor.constraint(equalTo: paymentMethodButton.centerYAnchor),
        ])
    }
    
    
    private func configureBalanceButton(){
        let configuration = UIImage.SymbolConfiguration(pointSize: 15)
        let image = UIImage(systemName: "creditcard.circle.fill", withConfiguration: configuration)
        balanceLeftImageView.image = image
        balanceLeftImageView.contentMode = .scaleAspectFit
        balanceLeftImageView.contentMode = .center
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.text = "Balance"
        buttonTitleLabel.font =  UIFont(name: "Montserrat", size: 20)
        let balanceLabel = UILabel()
        balanceLabel.text = "$1010"
        balanceLabel.font =  UIFont(name: "Montserrat", size: 20)
        balanceButton.addSubviews(balanceLeftImageView, buttonTitleLabel, balanceLabel)
        balanceLeftImageView.backgroundColor = .systemGray6
        balanceLeftImageView.tintColor = .label
        balanceButton.translatesAutoresizingMaskIntoConstraints = false
        balanceLeftImageView.translatesAutoresizingMaskIntoConstraints = false
        buttonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            balanceButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.9),
            
            balanceLeftImageView.leadingAnchor.constraint(equalTo: balanceButton.leadingAnchor, constant: 5),
            balanceLeftImageView.centerYAnchor.constraint(equalTo: balanceButton.centerYAnchor),
            balanceLeftImageView.widthAnchor.constraint(equalToConstant: 30),
            balanceLeftImageView.heightAnchor.constraint(equalToConstant: 30),
            
            buttonTitleLabel.leadingAnchor.constraint(equalTo: balanceLeftImageView.trailingAnchor, constant: 5),
            buttonTitleLabel.centerYAnchor.constraint(equalTo: balanceButton.centerYAnchor),
            
            balanceLabel.trailingAnchor.constraint(equalTo: balanceButton.trailingAnchor, constant: -5),
            balanceLabel.centerYAnchor.constraint(equalTo: balanceButton.centerYAnchor),
        ])
    }
    
    
    private func configureTradeHistoryButton(){
        let configuration = UIImage.SymbolConfiguration(pointSize: 15)
        let image = UIImage(systemName: "creditcard.circle.fill", withConfiguration: configuration)
        tradeHistoryLeftImageView.image = image
        tradeHistoryLeftImageView.contentMode = .scaleAspectFit
        tradeHistoryLeftImageView.contentMode = .center
        
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.text = "Trade history"
        buttonTitleLabel.font =  UIFont(name: "Montserrat", size: 20)
        let rightImageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
        rightImageView.tintColor = .black
        tradeHistoryButton.addSubviews(tradeHistoryLeftImageView, buttonTitleLabel, rightImageView)
        tradeHistoryLeftImageView.backgroundColor = .systemGray6
        tradeHistoryLeftImageView.tintColor = .label
        
        tradeHistoryButton.translatesAutoresizingMaskIntoConstraints = false
        tradeHistoryLeftImageView.translatesAutoresizingMaskIntoConstraints = false
        buttonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tradeHistoryButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.9),
            
            tradeHistoryLeftImageView.leadingAnchor.constraint(equalTo: tradeHistoryButton.leadingAnchor, constant: 5),
            tradeHistoryLeftImageView.centerYAnchor.constraint(equalTo: tradeHistoryButton.centerYAnchor),
            tradeHistoryLeftImageView.widthAnchor.constraint(equalToConstant: 30),
            tradeHistoryLeftImageView.heightAnchor.constraint(equalToConstant: 30),
            
            buttonTitleLabel.leadingAnchor.constraint(equalTo: tradeHistoryLeftImageView.trailingAnchor, constant: 5),
            buttonTitleLabel.centerYAnchor.constraint(equalTo: tradeHistoryButton.centerYAnchor),
            
            rightImageView.trailingAnchor.constraint(equalTo: tradeHistoryButton.trailingAnchor, constant: -5),
            rightImageView.centerYAnchor.constraint(equalTo: tradeHistoryButton.centerYAnchor),
        ])
    }
    
    
    private func configureRestorePurchaseButton(){
        let configuration = UIImage.SymbolConfiguration(pointSize: 15)
        let image = UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: configuration)
        restorePurchaseLeftImageView.image = image
        restorePurchaseLeftImageView.contentMode = .scaleAspectFit
        restorePurchaseLeftImageView.contentMode = .center
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.text = "Restore purchase"
        buttonTitleLabel.font =  UIFont(name: "Montserrat", size: 20)
        let rightImageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
        rightImageView.tintColor = .black
        restorePurchaseButton.addSubviews(restorePurchaseLeftImageView, buttonTitleLabel, rightImageView)
        restorePurchaseLeftImageView.backgroundColor = .systemGray6
        restorePurchaseLeftImageView.tintColor = .label
        restorePurchaseButton.translatesAutoresizingMaskIntoConstraints = false
        restorePurchaseLeftImageView.translatesAutoresizingMaskIntoConstraints = false
        buttonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            restorePurchaseButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.9),

            restorePurchaseLeftImageView.leadingAnchor.constraint(equalTo: restorePurchaseButton.leadingAnchor, constant: 5),
            restorePurchaseLeftImageView.centerYAnchor.constraint(equalTo: restorePurchaseButton.centerYAnchor),
            restorePurchaseLeftImageView.widthAnchor.constraint(equalToConstant: 30),
            restorePurchaseLeftImageView.heightAnchor.constraint(equalToConstant: 30),
            
            buttonTitleLabel.leadingAnchor.constraint(equalTo: restorePurchaseLeftImageView.trailingAnchor, constant: 5),
            buttonTitleLabel.centerYAnchor.constraint(equalTo: restorePurchaseButton.centerYAnchor),
            
            rightImageView.trailingAnchor.constraint(equalTo: restorePurchaseButton.trailingAnchor, constant: -5),
            rightImageView.centerYAnchor.constraint(equalTo: restorePurchaseButton.centerYAnchor),
        ])
    }
    
    
    private func configureHelpButton(){
        let configuration = UIImage.SymbolConfiguration(pointSize: 15)
        let image = UIImage(systemName: "questionmark.circle.fill", withConfiguration: configuration)
        helpLeftImageView.image = image
        helpLeftImageView.contentMode = .scaleAspectFit
        helpLeftImageView.contentMode = .center
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.text = "Help"
        buttonTitleLabel.font =  UIFont(name: "Montserrat", size: 20)
        helpButton.addSubviews(helpLeftImageView, buttonTitleLabel)
        helpLeftImageView.backgroundColor = .systemGray6
        helpLeftImageView.tintColor = .label
        helpButton.translatesAutoresizingMaskIntoConstraints = false
        helpLeftImageView.translatesAutoresizingMaskIntoConstraints = false
        buttonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            helpButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.9),
            
            helpLeftImageView.leadingAnchor.constraint(equalTo: helpButton.leadingAnchor, constant: 5),
            helpLeftImageView.centerYAnchor.constraint(equalTo: helpButton.centerYAnchor),
            helpLeftImageView.widthAnchor.constraint(equalToConstant: 30),
            helpLeftImageView.heightAnchor.constraint(equalToConstant: 30),
            
            buttonTitleLabel.leadingAnchor.constraint(equalTo: helpLeftImageView.trailingAnchor, constant: 5),
            buttonTitleLabel.centerYAnchor.constraint(equalTo: helpButton.centerYAnchor),
        ])
    }
    
    
    private func configureLogOutButton(){
        let configuration = UIImage.SymbolConfiguration(pointSize: 15)
        let image = UIImage(systemName: "iphone.and.arrow.forward", withConfiguration: configuration)
        logOutLeftImageView.image = image
        logOutLeftImageView.contentMode = .scaleAspectFit
        logOutLeftImageView.contentMode = .center
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.text = "Log out"
        buttonTitleLabel.font =  UIFont(name: "Montserrat", size: 20)
        logOutButton.addSubviews(logOutLeftImageView, buttonTitleLabel)
        logOutLeftImageView.backgroundColor = .systemGray6
        logOutLeftImageView.tintColor = .label
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutLeftImageView.translatesAutoresizingMaskIntoConstraints = false
        buttonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logOutButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.9),
            
            logOutLeftImageView.leadingAnchor.constraint(equalTo: logOutButton.leadingAnchor, constant: 5),
            logOutLeftImageView.centerYAnchor.constraint(equalTo: logOutButton.centerYAnchor),
            logOutLeftImageView.widthAnchor.constraint(equalToConstant: 30),
            logOutLeftImageView.heightAnchor.constraint(equalToConstant: 30),
            
            buttonTitleLabel.leadingAnchor.constraint(equalTo: logOutLeftImageView.trailingAnchor, constant: 5),
            buttonTitleLabel.centerYAnchor.constraint(equalTo: logOutButton.centerYAnchor),
        ])
    }
    
    
    private func configureProfileOptionsStackView(){
        view.addSubview(profileOptionsStack)
        profileOptionsStack.translatesAutoresizingMaskIntoConstraints = false
       
        profileOptionsStack.addArrangedSubview(tradeStoreButton)
        profileOptionsStack.addArrangedSubview(paymentMethodButton)
        profileOptionsStack.addArrangedSubview(balanceButton)
        profileOptionsStack.addArrangedSubview(tradeHistoryButton)
        profileOptionsStack.addArrangedSubview(restorePurchaseButton)
        profileOptionsStack.addArrangedSubview(helpButton)
        profileOptionsStack.addArrangedSubview(logOutButton)
        profileOptionsStack.axis = .vertical
        profileOptionsStack.alignment = .center
        profileOptionsStack.distribution = .fillEqually
        profileOptionsStack.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        profileOptionsStack.isLayoutMarginsRelativeArrangement = true
      
        NSLayoutConstraint.activate([
            profileOptionsStack.topAnchor.constraint(equalTo: uploadItemButton.bottomAnchor, constant: 10),
            profileOptionsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileOptionsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            profileOptionsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            profileOptionsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130)
        ])
    }
    
    
//MARK: - Buttons' actions
    @objc private func  addImageButtonTapped(){
        self.view.endEditing(true)
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @objc private func  logOut(){
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @objc private func dismissVC(){
        NotificationCenter.default.post(name: Notification.Name("changeIndexToExplorer"), object: nil)
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
}


//MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] is UIImage {
            let imageUrl          = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
            self.imageNameMain = (imageUrl?.lastPathComponent)!
            DispatchQueue.main.async { [self] in
                imageImageView.image = loadImageNamed(name: imageNameMain)
                PersistenceManager.sharedRealm.editUserPhoto(idUserForEdit: firstName, imageIdentifier: imageNameMain)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
