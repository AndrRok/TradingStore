//
//  CustomTabBar.swift
//  TradingStore
//
//  Created by ARMBP on 3/12/23.
//

import UIKit

class CustomTabBar: UIViewController {
    
    private lazy var tabBar         = UIStackView()
    public  lazy var currentVC      = UIViewController()
    private lazy var cartVC         = UIViewController()
    private lazy var favoriteVC     = UIViewController()
    private lazy var chatVC         = UIViewController()
    private lazy var storeVC        = StoreVC()
    private lazy var profileVC      = ProfileVC()
    private lazy var itemInfoVC     = ItemInfoVC()
    private lazy var storeVCButton       = UIButton()
    private lazy var cartVCButton        = UIButton()
    private lazy var favoritesVCButton   = UIButton()
    private lazy var personVCButton      = UIButton()
    private lazy var chatVCButton        = UIButton()
    private var usersFirstName = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setVC(vc: storeVC)
        configureButtons()
        NotificationCenter.default.addObserver(self, selector: #selector(goExplorerVC(notification:)), name: Notification.Name("changeIndexToExplorer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goProfileVC(notification:)), name: Notification.Name("changeIndexToProfileVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goItemInfoVC(notification:)), name: Notification.Name("changeIndexToItemInfoVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goExplorerVC(notification:)), name: Notification.Name("changeIndexFromItemInfoToToExplorer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goCartVC(notification:)), name: Notification.Name("changeIndexToCart"), object: nil)
    }

    
    override func viewDidLayoutSubviews() {
        makeButtonCircle(buttons: [storeVCButton, cartVCButton, favoritesVCButton, personVCButton, chatVCButton])
    }
    
    
    private func configure(){
        view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.backgroundColor = .systemGray5
        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = 20
        tabBar.addArrangedSubview(storeVCButton)
        tabBar.addArrangedSubview(favoritesVCButton)
        tabBar.addArrangedSubview(cartVCButton)
        tabBar.addArrangedSubview(chatVCButton)
        tabBar.addArrangedSubview(personVCButton)
        tabBar.axis = .horizontal
        tabBar.alignment = .center
        tabBar.distribution = .equalCentering
        tabBar.spacing = 5
        tabBar.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tabBar.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            tabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 80),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
    
    
    private func configureButtons(){
        var storeButtonConfiguration = UIButton.Configuration.filled()
        storeButtonConfiguration.image = UIImage(systemName: "house")
        storeVCButton.configuration = storeButtonConfiguration
        storeVCButton.addAction(UIAction{_ in
            self.setVC(vc: self.storeVC)
        }, for: .touchUpInside)
        
        var cartButtonConfiguration = UIButton.Configuration.filled()
        cartButtonConfiguration.image = UIImage(systemName: "cart")?.withTintColor(.systemRed)
        cartVCButton.configuration = cartButtonConfiguration
        cartVCButton.addAction(UIAction{_ in
            self.setVC(vc: self.cartVC)
        }, for: .touchUpInside)
        
        var favoriteButtonConfiguration = UIButton.Configuration.filled()
        favoriteButtonConfiguration.image = UIImage(systemName: "heart")
        favoritesVCButton.configuration = favoriteButtonConfiguration
        favoritesVCButton.addAction(UIAction{ _ in
            self.setVC(vc: self.favoriteVC)
        }, for: .touchUpInside)
        
        var personButtonConfiguration = UIButton.Configuration.filled()
        personButtonConfiguration.image = UIImage(systemName: "person")
        personVCButton.configuration = personButtonConfiguration
        personVCButton.addAction(UIAction{_ in
            self.setVC(vc: self.profileVC)
        }, for: .touchUpInside)
        
        var supportButtonConfiguration = UIButton.Configuration.filled()
        supportButtonConfiguration.image = UIImage(systemName: "message")
        chatVCButton.configuration = supportButtonConfiguration
        chatVCButton.addAction(UIAction{_ in
            self.setVC(vc: self.chatVC)
        }, for: .touchUpInside)
    }
    
    
    
    private func setVC(vc: UIViewController){
        DispatchQueue.main.async { [self] in
            let arrayVC      = [storeVC, cartVC, favoriteVC, profileVC, chatVC, itemInfoVC]
            let buttonsArray = [storeVCButton, cartVCButton, favoritesVCButton, personVCButton, chatVCButton]
            
            for view in arrayVC {
                view.view.removeFromSuperview()
                willMove(toParent: nil)
                view.removeFromParent()
            }
            
            addChild(vc)
            vc.view.frame = view.bounds
            view.addSubview(vc.view)
            vc.didMove(toParent: self)
            
            for button in buttonsArray {
                button.configuration?.baseForegroundColor = .systemGray
                button.configuration?.baseBackgroundColor = .white
            }
            
            switch vc {
            case self.cartVC:
                cartVCButton.configuration?.baseForegroundColor = .systemGray
                cartVCButton.configuration?.baseBackgroundColor = .systemGray6
                view.bringSubviewToFront(tabBar)
            case self.storeVC:
                storeVC.usersFirstName = usersFirstName
                storeVCButton.configuration?.baseForegroundColor = .systemGray
                storeVCButton.configuration?.baseBackgroundColor = .systemGray6
                view.bringSubviewToFront(tabBar)
            case self.favoriteVC:
                favoritesVCButton.configuration?.baseForegroundColor = .systemGray
                favoritesVCButton.configuration?.baseBackgroundColor = .systemGray6
                view.bringSubviewToFront(tabBar)
            case self.profileVC:
                profileVC.firstName = usersFirstName
                personVCButton.configuration?.baseForegroundColor = .systemGray
                personVCButton.configuration?.baseBackgroundColor = .systemGray6
                view.bringSubviewToFront(tabBar)
            case self.chatVC:
                chatVCButton.configuration?.baseForegroundColor = .systemGray
                chatVCButton.configuration?.baseBackgroundColor = .systemGray6
                view.bringSubviewToFront(tabBar)
            case self.itemInfoVC:
                storeVCButton.configuration?.baseForegroundColor = .systemGray
                storeVCButton.configuration?.baseBackgroundColor = .systemGray6
                view.bringSubviewToFront(tabBar)
            default:
                break
            }
        }
    }
    
    
    private func makeButtonCircle(buttons: [UIButton]){
        for i  in buttons{
            i.widthAnchor.constraint(equalToConstant: 50).isActive = true
            i.heightAnchor.constraint(equalToConstant: 50).isActive = true
            i.clipsToBounds = true
            i.layer.cornerRadius = 0.5 * i.bounds.size.width
        }
    }
    
    @objc private func goExplorerVC(notification: NSNotification){
        setVC(vc: storeVC)
    }
    
    @objc private func goProfileVC(notification: NSNotification){
        setVC(vc: profileVC)
    }
    
    @objc private func goItemInfoVC(notification: NSNotification){
        setVC(vc: itemInfoVC)
    }
    
    @objc private func goCartVC(notification: NSNotification){
        setVC(vc: cartVC)
    }
}


extension CustomTabBar: SendUserProtocol{
    func sendUser(usersFirstName: String) {
        self.usersFirstName = usersFirstName
    }
}
