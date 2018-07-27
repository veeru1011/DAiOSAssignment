//
//  UTableViewCell.swift
//  DAiOSAssignment
//
//  Created by VEER BAHADUR TIWARI on 17/07/18.
//  Copyright © 2018 docAnywhere. All rights reserved.
//

import UIKit


class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "ImageViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "ImageViewCell")
        
        // Initialization code
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.collectionView.layoutIfNeeded()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var userModel: UserModel? {
        didSet {
            self.nameLabel.text  = " "
            self.profileView.image = #imageLiteral(resourceName: "placeholder")
            guard let userModel = userModel else { return }
            if let name = userModel.name {
                nameLabel.text = name
                
                if let imageUrl = userModel.image {
                    self.profileView.setImageFromServerURL(urlString: imageUrl)
                }
            }
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        let f = CGRect(x: collectionView.frame.minX, y: collectionView.frame.minY, width: targetSize.width-30, height: 1)
        collectionView.frame = f
        collectionView.layoutIfNeeded()
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.collectionViewLayout.prepare()
        var size = collectionView.collectionViewLayout.collectionViewContentSize
        size.height += self.profileView.frame.maxY + 22
        return size
    }
    
}

extension UserTableViewCell {
    
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
        self.contentView.layoutIfNeeded()
    }
    
}
