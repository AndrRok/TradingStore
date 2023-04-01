//
//  UIViewController+Ext.swift
//  TradingStore
//
//  Created by ARMBP on 3/22/23.
//

import UIKit

extension UIViewController {
    
    func presentCustomAllertOnMainThred(allertTitle: String, message: String, butonTitle: String){
        DispatchQueue.main.async {
            let allertVC = AllertVC(allertTitle: allertTitle, message: message, buttonTitle: butonTitle)
            allertVC.modalPresentationStyle = .overFullScreen
            allertVC.modalTransitionStyle = .crossDissolve
            self.present(allertVC, animated: true)
        }
    }
}

