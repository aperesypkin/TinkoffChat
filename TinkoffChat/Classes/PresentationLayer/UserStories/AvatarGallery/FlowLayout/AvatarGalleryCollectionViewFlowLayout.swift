//
//  AvatarGalleryCollectionViewFlowLayout.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 23/11/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

class AvatarGalleryCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let columnsCount: CGFloat = 3
        let itemOffset: CGFloat = 5
        let itemWidth = (collectionView.bounds.width - itemOffset * (columnsCount + 1)) / columnsCount
        let itemHeight = (collectionView.bounds.width - itemOffset * (columnsCount + 1)) / columnsCount
        
        sectionInset = UIEdgeInsets(all: itemOffset)
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        minimumLineSpacing = itemOffset
        minimumInteritemSpacing = itemOffset
    }
    
}
