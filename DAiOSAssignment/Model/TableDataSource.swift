//
//  TableDataSource.swift
//  DAiOSAssignment
//
//  Created by VEER BAHADUR TIWARI on 16/07/18.
//  Copyright © 2018 docAnywhere. All rights reserved.
//

import UIKit
import Foundation

struct ImageCellConstant {
    
    static let column: CGFloat = 2
    static let minLineSpacing: CGFloat = 10.0
    static let minItemSpacing: CGFloat = 10.0
    
    static let offset: CGFloat = 1.0
    
    static func getItemWidth(boundWidth: CGFloat) -> CGFloat {
        
        let totalWidth = boundWidth - (offset + offset) - ((column - 1) * minItemSpacing)
        return totalWidth / column
    }
}

class TableDataSource: NSObject, UITableViewDataSource  {
    
    var items: [UserModel]
    var cellIdentifier: String
    var storedOffsets = [Int: CGFloat]()
    
    override init() {
        self.items = []
        self.cellIdentifier = "userCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! UserTableViewCell
        let userModel = self.items[indexPath.row]
        cell.userModel = userModel
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        cell.layoutIfNeeded()
        
        return cell
    }
    
}

extension TableDataSource: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let userModel = self.items[collectionView.tag]
        
        if let items = userModel.items {
            return items.count
        }
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let userModel = self.items[collectionView.tag]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath)
        
        let imageUrl = userModel.items![indexPath.item]
        if let ivCell = cell as? ImageViewCell {
            ivCell.posterView.setImageFromServerURL(urlString: imageUrl)
            ivCell.layoutIfNeeded()
            return ivCell
        }
        
        return cell
    }
    
}

extension TableDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var isNormal = true
        let userModel = self.items[collectionView.tag]
        if let items = userModel.items {
            if indexPath.item == 0 && items.count % 2 == 1 {
                isNormal = false
            }
        }
        var itemWidth = ImageCellConstant.getItemWidth(boundWidth: collectionView.bounds.size.width)
        if isNormal == false {
            itemWidth = collectionView.bounds.size.width
        }
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
