//
//  Protocol.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/07/07.
//  Copyright © 2020 최다혜. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboarded {
//    static func instantiate(_ name:String) -> Self
    static func instantiate(_ name: StoryBoard) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(_ name: StoryBoard) -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)
        
        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]
        
        // load our storyboard
        let storyboard = UIStoryboard(name: name.key, bundle: Bundle.main)
        
        // instantiate a view controller with that identifier, and force cast as the type that was requested

        let vc = storyboard.instantiateViewController(withIdentifier: className) as! Self

        return vc
    }

}

enum StoryBoard:String {
    case Main
    var key:String {
        return rawValue
    }
}

extension NSNotification.Name {
    static let WriteEmotion = NSNotification.Name("WriteEmotion")
}

enum DateItem:String {
    case year
    case month
    case monthShort
    case monthLong
    case day
    case weekShort
    var key:String {
        return rawValue
    }
}

enum DataType:String {
    case rtfd
    var key:String {
        return rawValue
    }
}

enum TextAlignment:String {
    case center
    case left
    case right
    var key:String {
        return rawValue
    }
    var image:UIImage {
        switch self {
        case .center: return UIImage(systemName: "text.aligncenter") ?? UIImage()
        case .left: return UIImage(systemName: "text.alignleft") ?? UIImage()
        case .right: return UIImage(systemName: "text.alignright") ?? UIImage()
        }
    }
    var returnNSTextAlignment:NSTextAlignment {
        switch self {
        case .center: return NSTextAlignment.center
        case .left: return NSTextAlignment.left
        case .right: return NSTextAlignment.right
        }
    }
}

enum Image :String {
    case e1
    case e2
    case e3
    case e4
    case e5
    case e6
    case e7
    case e8
    case e9
    
    var key:String {
        return rawValue
    }
    
    var image:UIImage {
        return UIImage.image(self)
    }
    
    var value:String {
        switch self {
        case .e1: return "그저그래"
        case .e2: return "걱정돼"
        case .e3: return "설레"
        case .e4: return "기분최고"
        case .e5: return "화나"
        case .e6: return "평온해"
        case .e7: return "신나"
        case .e8: return "피곤해"
        case .e9: return "슬퍼"
        }
    }
}

/// WriteVC 화면에서 Picker에 매핑할 구조체
struct PickerData {
    var year:String = ""
    /// 변환 전 데이터 08-19 ..
    var dateFormat:String = ""
    /// 변환 후 데이터 8월 19..
    var dateFormatToKorean:String = ""
}
