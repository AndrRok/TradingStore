//
//  UIHelper.swift
//  TradingStore
//
//  Created by ARMBP on 3/20/23.
//

import UIKit


enum UIHelper{
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }
    
    
    static func createLayout(in view: UIView) -> UICollectionViewCompositionalLayout{
        
        return UICollectionViewCompositionalLayout{ (sectionNumber, ewv) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                // Item
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                // Group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(60), heightDimension: .absolute(60)), repeatingSubitem: item, count: 1)
                // Sections
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
                
            case 1:
                // Item
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                // Group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(0.3)), repeatingSubitem: item, count: 1)
                // Sections
                let section = NSCollectionLayoutSection(group: group)
                
                
                let headerKind = UICollectionView.elementKindSectionHeader
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
                let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: headerKind, alignment: .top)
                // for sticky header
                headerElement.pinToVisibleBounds = true
                section.boundarySupplementaryItems = [headerElement]
                section.orthogonalScrollingBehavior = .continuous
                
                return section
                
            case 2:
                // Item
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                // Group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.4)), repeatingSubitem: item, count: 2)
                // Sections
                let section = NSCollectionLayoutSection(group: group)
                let headerKind = UICollectionView.elementKindSectionHeader
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
                let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: headerKind, alignment: .top)
                // for sticky header
                headerElement.pinToVisibleBounds = true
                section.boundarySupplementaryItems = [headerElement]
                // Return
                return section
                
            default:
                // Item
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                // Group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), repeatingSubitem: item, count: 1)
                // Sections
                
                let section = NSCollectionLayoutSection(group: group)
                
                let headerKind = UICollectionView.elementKindSectionHeader
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
                
                let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: headerKind, alignment: .top)
                
                section.boundarySupplementaryItems = [headerElement]
                // Return
                return section
            }
        }
    }
}

