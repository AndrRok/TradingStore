//
//  UIView+Ext.swift
//  TradingStore
//
//  Created by ARMBP on 3/12/23.
//

import UIKit

extension UIView{
    
    func addSubviews(_ views: UIView...){ for view in views {addSubview(view)} }
    
    func pinToEdges(of superView: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            topAnchor.constraint(equalTo: superView.topAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
        
    }
}
