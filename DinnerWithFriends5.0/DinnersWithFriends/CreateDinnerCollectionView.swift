//
//  CreateDinnerCollectionView.swift
//  DinnerWithFriends5.0
//
//  Created by Bart Bronselaer on 13/01/18.
//  Copyright © 2018 Bart Bronselaer. All rights reserved.
//

import UIKit

class CreateDinnerCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    var menuItems = ["friendsIcon", "dinnerItemIcon", "wineIcon", "dessertsIcon","searchIcon"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuBarCollectionViewCell
        cell.menuBarImage.image = UIImage(named: menuItems[indexPath.row])
        return cell
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

