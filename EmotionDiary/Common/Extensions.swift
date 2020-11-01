//
//  RawValExt.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/08/10.
//  Copyright © 2020 최다혜. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    func toString() -> String {
        return "\(self)"
    }
}
extension Substring {
    func returnString() -> String {
        return "\(self)"
    }
}

extension String {
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        return dateFormatter.date(from: self)!
    }
}

extension Data {
    /// Data를 NSAttributedString으로 변환
    func toNSAttributedString(_ dataType:DataType) -> NSAttributedString {
        var result = NSAttributedString()
        var options:[NSAttributedString.DocumentReadingOptionKey:NSAttributedString.DocumentType]
        switch dataType {
        case .rtfd:
           options = [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.rtfd]
        }
        do {
            result = try NSAttributedString(data: self, options: options, documentAttributes: nil)
        } catch  {
            print(error)
        }
        return result
    }
}

extension UIImage {
    convenience init?(_ name:Image) {
        self.init(named:name.key)
    }
    
    class func image(_ name:Image) -> UIImage {
        return UIImage(named: name.key) ?? UIImage()
    }
    
    class func resizeImage(_ image:UIImage,_ newWidth:CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: textString.count))
            self.attributedText = attributedString
        }
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
extension Date {
    func toString(input: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let result = format.string(from: input)
        return result
    }
    
    func returnTodayDate() -> String {
        let result = toString(input: Date())
        return result
    }
    
    func returnUtilTodayCount() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let startDate = dateFormatter.date(from:"2020-01-01")!
        let endDate = dateFormatter.date(from: returnTodayDate())!

        let interval = endDate.timeIntervalSince(startDate)
        let days = Int(interval / 86400)
        return days
    }
    
    func returnMonthDayWeek(input: String) -> String {
        let weekend:[String] = ["일","월","화","수","목","금","토"]
        let calendar = Calendar(identifier: .gregorian)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        guard let inputDate = dateFormatter.date(from: input),
            let month = calendar.dateComponents([.month], from: inputDate).month,
            let day = calendar.dateComponents([.day], from: inputDate).day,
        let wd = calendar.dateComponents([.weekday], from: inputDate).weekday else { return "" }
        
        return "\(month)월 \(day)일 (\(weekend[wd-1]))"
    }
    
    func returnEachItem(input: DateItem) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let df = DateFormatter()
        df.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        switch input {
        case .year:
            df.dateFormat = "yyyy"
            return df.string(from: self)
        case .month:
            guard let month = calendar.dateComponents([.month], from: self).month else { return "" }
            return "\(month)"
        case .monthShort:
            df.dateFormat = "mm"
            guard let month = calendar.dateComponents([.month], from: self).month else { return "" }
            return "\(df.shortMonthSymbols[month-1])"
        case .monthLong:
            df.dateFormat = "mm"
            guard let month = calendar.dateComponents([.month], from: self).month else { return "" }
            return "\(df.monthSymbols[month-1])"
        case .day:
            df.dateFormat = "dd"
            return df.string(from: self)
        case .weekShort:
            guard let wd = calendar.dateComponents([.weekday], from: self).weekday else { return "" }
            return "\(calendar.shortWeekdaySymbols[wd-1])"
        }
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

extension UIAlertController {
    func getAlert(_ title:String, _ message:String, _ cancelHandler:((UIAlertAction)-> Void)?, _ okHandler:((UIAlertAction)-> Void)?) -> UIAlertController {
        //알림창을 정의
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
        //버튼을 정의
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: okHandler)
            
        //알림창에 버튼 추가
        alert.addAction(cancelAction)
        alert.addAction(okAction)

        return alert
    }
}
