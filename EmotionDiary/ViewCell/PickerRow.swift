//
//  PickerRow.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/08/04.
//  Copyright © 2020 최다혜. All rights reserved.
//

import Foundation
import UIKit

class PickerRow : UIView {

    var emotionVw = UIImageView()
    var dateLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let view = UIView()
        
        emotionVw = UIImageView(frame: CGRect(x: 15, y: 10, width: 30, height: 30))
        dateLb = UILabel(frame: CGRect(x: 54, y: 14.5, width: 110, height: 21))
        
        view.addSubview(emotionVw)
        view.addSubview(dateLb)
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
}
