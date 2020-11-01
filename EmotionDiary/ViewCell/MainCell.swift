//
//  MainCell.swift
//  EmotionDiary
//
//  Created by 임병철 on 2020/08/23.
//  Copyright © 2020 최다혜. All rights reserved.
//

import UIKit

protocol MainCellDelgate:NSObjectProtocol {
    func didPressCell(sender: Int)
}

class MainCell: UICollectionViewCell {

    @IBOutlet weak var yealLb: UILabel!
    @IBOutlet weak var monthLb: UILabel!
    @IBOutlet weak var emotionListCv: UICollectionView!
    var delegate:MainCellDelgate!
    
    var emotions = [Emotion]() {
        didSet {
            emotionListCv.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupFlowLayout()
        emotionListCv.delegate = self
        emotionListCv.dataSource = self
    }


    private func setupFlowLayout() {
        let nib = UINib(nibName: "MainDetailCell", bundle: nil)
        emotionListCv.register(nib, forCellWithReuseIdentifier: "MainDetailCell")
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let itemSpacing:CGFloat = 3.0
        let itemsInOneLine:CGFloat = 6.0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let width = emotionListCv.frame.width - itemSpacing * CGFloat(itemsInOneLine + 1)
        flowLayout.itemSize = CGSize(width: floor(width/itemsInOneLine), height: width/itemsInOneLine)
        flowLayout.minimumInteritemSpacing = 0.0
//        flowLayout.minimumLineSpacing = 3
        
        self.emotionListCv.collectionViewLayout = flowLayout
    }
    
    func getPreviousEmotionCount(id: Int) -> Int {
        var result:Int = 0
        let emotions = Emotion.sortQry("", "updateDate", true)
        for e in emotions {
            if e.id == id {
                break
            }
            result += 1
        }
        return result
    }
}

extension MainCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //navigation에 리스트 뷰 추가
        let emotionIndex = getPreviousEmotionCount(id: emotions[indexPath.row].id)
        delegate.didPressCell(sender: emotionIndex)
    }
    
}

extension MainCell : UICollectionViewDataSource {
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let noOfCellsInRow = 5   //number of column you want
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//        let totalSpace = flowLayout.sectionInset.left
//            + flowLayout.sectionInset.right
//            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
//
//        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
//        return CGSize(width: size, height: size)
//
//
//        let numberOfSets = CGFloat(6)
//
//        let width = (collectionView.frame.size.width - (10 * (numberOfSets+1))) / numberOfSets
//
//        let height = collectionView.frame.size.height / 2
//        return CGSize(width: width, height: height)
//    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainDetailCell", for: indexPath) as? MainDetailCell else { return UICollectionViewCell() }
//        cell.delegate = self
        guard let ei = emotions[indexPath.row].emotionImage else { return UICollectionViewCell() }
        cell.imageVw.image = UIImage(data: ei)
        return cell
    }
}
