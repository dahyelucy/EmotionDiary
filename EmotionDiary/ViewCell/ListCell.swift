//
//  ListCell.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/09/06.
//  Copyright © 2020 최다혜. All rights reserved.
//

import UIKit


protocol ListCellDelegate:NSObjectProtocol {
    func pressDeleteCell(sender: Int)
}

class ListCell: UITableViewCell {
    
    @IBOutlet weak var listCellVw: UIView!
    @IBOutlet weak var dayLb: UILabel!
    @IBOutlet weak var weekLb: UILabel!
    @IBOutlet weak var emotionVw: UIImageView!
    @IBOutlet weak var emotionLb: UILabel!
    @IBOutlet weak var memoTxt: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var delegate:ListCellDelegate!
    var emotionId:Int?
    weak var viewController:UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        listCellVw.layer.borderWidth = 0.5
        listCellVw.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 100) //black
        dayLb.underline()
        editBtn.tintColor = .black
        deleteBtn.tintColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func pushEditBtn(_ sender: Any) {
        let nextVC = WriteVC.instantiate(.Main)
        nextVC.isFromEdit = true
        nextVC.emotionData = Emotion.qry("id == \(emotionId!)")[0]
        viewController?.present(nextVC, animated: true, completion: nil)
        
    }
    
    @IBAction func pushDeleteBtn(_ sender: Any) {
        let delPopup = UIAlertController().getAlert("일기 삭제","정말로 이 일기를 삭제할까요?",
            nil,
            { [self]   action in
                //ListVC로 선택된 index 넘겨주기
                guard let eid = emotionId else { return }
                delegate.pressDeleteCell(sender: eid)
            })
        viewController?.present(delPopup, animated: true, completion: nil)
    }
}

