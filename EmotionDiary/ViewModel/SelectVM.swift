//
//  SelectVM.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/07/06.
//  Copyright © 2020 최다혜. All rights reserved.
//

import Foundation
import UIKit

class SelectVCDataSource: ViewModelDataSource<Image>, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCell", for: indexPath) as? SelectCell else { return UICollectionViewCell() }
        cell.imageVw.image = data.value[indexPath.row].image
        return cell
    }

}

struct SelectVM {
    weak var dataSource:SelectVCDataSource?

    init(dataSource:SelectVCDataSource?) {
        self.dataSource = dataSource
    }

    func fetchData(imgs:[Image]) {
        dataSource?.data.value = imgs
    }
}
