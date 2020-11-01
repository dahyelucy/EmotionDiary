//
//  SelectVC.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/06/28.
//  Copyright © 2020 최다혜. All rights reserved.
//

import UIKit


//protocol emotionDelegate:class {
//    func sendEmotion(image:UIImage, text:String)
//}

class SelectVC: UIViewController, Storyboarded {

    @IBOutlet weak var outerVw: UIView!
    var images:[UIImage] = []
    var img:[Image] = [.e1,.e2,.e3,.e4,.e5,.e6,.e7,.e8,.e9]
    var datepickerIndex = 0
    //var delegate:emotionDelegate?
    @IBOutlet weak var emotionCv: UICollectionView!
    @IBOutlet weak var todaylbl: UILabel!
    
    let dataSource = SelectVCDataSource()
    
    lazy var viewModel: SelectVM = {
        let viewModel = SelectVM(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = img.map{ $0.image }
        
        self.setupFlowLayout()
        emotionCv.delegate = self
        emotionCv.dataSource = dataSource
        
        dataSource.data.addAndNotify(observer: self) { [unowned self] in
            self.emotionCv.reloadData()
        }
        
        viewModel.fetchData(imgs: img)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveWriteEvent), name: .WriteEmotion, object: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        outerVw.addGestureRecognizer(gesture)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .WriteEmotion, object: nil)
    }
    
    @objc func receiveWriteEvent() {
        dismiss(animated: true, completion: nil)
    }

    @objc func tapGesture() {
        dismiss(animated: true, completion: nil)
    }

    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 75 , height: 75)
        self.emotionCv.collectionViewLayout = flowLayout
    }

}

extension SelectVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //이모티콘을 select 하면 write 페이지로 이동
        let nextVC = WriteVC.instantiate(.Main)
        nextVC.selectImg = images[indexPath.row]
        nextVC.selectTxt = img[indexPath.row].value
        present(nextVC, animated: true, completion: nil)
    }
    
}
