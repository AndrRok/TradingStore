//
//  DropDownTableCell.swift
//  TradingStore
//
//  Created by ARMBP on 3/28/23.
//

import UIKit

class DropDownTableCell: UITableViewCell {
    
    public static let reuseID = "dropDownTableCell"
    
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLabel()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setLabel(searchResult: String){
        label.text = searchResult
    }
    
    
    private func configureLabel(){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font =  UIFont(name: "Montserrat", size: 12)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
