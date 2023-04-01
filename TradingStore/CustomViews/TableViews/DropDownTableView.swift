//
//  DropDownTableView.swift
//  TradingStore
//
//  Created by ARMBP on 3/28/23.
//

import UIKit

class DropDownTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var searchArray: [String] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.register(DropDownTableCell.self, forCellReuseIdentifier: DropDownTableCell.reuseID)
        self.delegate = self
        self.dataSource = self
        self.showsVerticalScrollIndicator = false
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(searchArray: [String]) {
        self.init(frame: .zero)
        self.searchArray = searchArray
    }
    
    //MARK: Dynamic size
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
    
    //MARK: Filling TableView
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         switch searchArray.count {
         case 0:
             return 1
         default:
             return searchArray.count
         }
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: DropDownTableCell.reuseID) as! DropDownTableCell
        switch searchArray.count {
        case 0:
            cell.setLabel(searchResult: "No results")
        default:
            let searchResult = searchArray[indexPath.row]
            cell.setLabel(searchResult: searchResult)
        }
        return cell
    }
}

