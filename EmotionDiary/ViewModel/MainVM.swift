//
//  MainVM.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/07/21.
//  Copyright © 2020 최다혜. All rights reserved.
//

import Foundation
import UIKit


protocol MainVCDataSourceDelegate:NSObjectProtocol {
    func didPressCellToVM(sender: Int)
}

struct MainVCDomain {
    var key:String? = ""
    var emotions:[Emotion]
}

class MainVCDataSource: ViewModelDataSource<MainVCDomain>, UICollectionViewDataSource, MainCellDelgate {
    var delegate:MainVCDataSourceDelegate!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as? MainCell else { return UICollectionViewCell() }
        cell.delegate = self
        let row = data.value[indexPath.row]
        guard let key = row.key else { return UICollectionViewCell() }
        
        let endIndex1 = key.index(key.startIndex, offsetBy: 4)
        let year = key[key.startIndex..<endIndex1]
        
        let startIndex = key.index(key.startIndex, offsetBy: 5)
        let endIndex2 = key.index(key.startIndex, offsetBy: 7)
        let month = key[startIndex..<endIndex2].returnString().toInt()
        
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "en-EN")
//        let monthText = cal.shortMonthSymbols[month].uppercased()
        let monthText = cal.monthSymbols[month-1].uppercased()
        
        cell.yealLb.text = year.returnString()
        cell.monthLb.text = monthText
        cell.emotions = row.emotions
        
        return cell
    }
    
    func didPressCell(sender: Int) {
        delegate.didPressCellToVM(sender: sender)
    }
 
}

struct MainVM {
    weak var dataSource:MainVCDataSource?

    init(dataSource:MainVCDataSource?) {
        self.dataSource = dataSource
    }

    func fetchData() {
//        let emotions:[Emotion] = Emotion.qry("")
        let emotions:[Emotion] = Emotion.sortQry("", "updateDate", true)
        var array:[MainVCDomain] = []
        for item in emotions {
            guard let ud = item.updateDate else { return }
            let endIndex = ud.index(ud.startIndex, offsetBy: 7)
            let key = ud[ud.startIndex..<endIndex]
            if array.count == 0 {
                var tempEmotion:[Emotion] = []
                tempEmotion.append(item)
                let tempDomain:MainVCDomain = MainVCDomain(key: key.returnString(), emotions: tempEmotion)
                array.append(tempDomain)
//                array[0].key = key.returnString()
//                array[0].emotions.append(item)
            }
            else {
                var isKeyExist = false
                for i in 0..<array.count {
                    if array[i].key == key.returnString() {
                        array[i].emotions.append(item)
                        isKeyExist = true
                        break
                    }
                }
                
                if isKeyExist == false {
                    var tempEmotion:[Emotion] = []
                    tempEmotion.append(item)
                    let tempDomain:MainVCDomain = MainVCDomain(key: key.returnString(), emotions: tempEmotion)
                    array.append(tempDomain)
                }
            }
            
        }
        dataSource?.data.value = array
    }
}
