//
//  PopupView.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/09/12.
//  Copyright © 2020 최다혜. All rights reserved.
//

import Foundation
import UIKit

class PopupView:UIView {
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupContent: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var popupOuterVw: UIView!
    
    /* func variable */
    var tmpCloseBtnFunc:(()->Void)? = nil
    var tmpOkBtnFunc:(()->Void)? = nil
    
    override class func awakeFromNib() {
        super.awakeFromNib()
//        popupOuterVw.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
//        popupOuterVw.layer.shadowRadius = 1.0
    }
    
    override init(frame: CGRect) {
        print("initCGRect")
        super.init(frame: frame)
        self.setPopupView()
        
    }
    
    required init?(coder: NSCoder) {
        print("initNSCoder")
        super.init(coder: coder)
//        self.setPopupView()
    }

//    class func setPopupView(_ title:String, _ content:String, _ close: () -> Void, _ok: () -> Void) {
//        self.popupTitle.text = title
//        self.popupContent.text = content
//
//        guard let xibName = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last else { return }
//        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
//        view.frame = self.bounds
//        self.addSubview(view)
//    }
    
    func setPopupView() {
        guard let xibName = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last else { return }
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    
    
    @IBAction func pushCloseBtn(_ sender: Any) {
        print("pushCloseBtn")
    }
    
    @IBAction func pushOkBtn(_ sender: Any) {
        print("pushOkBtn")
    }
}
