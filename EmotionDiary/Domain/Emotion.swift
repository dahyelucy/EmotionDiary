//
//  Emotion.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/07/05.
//  Copyright © 2020 최다혜. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Emotion: Object {
    dynamic var id:Int = 0
    dynamic var emotionImage:Data? = nil
    dynamic var feeling:String = ""
    dynamic var memo:Data? = nil
    dynamic var uploadImage:Data? = nil
    dynamic var updateDate:String? = nil
    

    override static func primaryKey() -> String? {
        return "id"
    }
        
    class func incrementId() -> Int {
        let realm = try! Realm()
        return (realm.objects(Emotion.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
        
    class func fromFunc(emotionImage:Data, feeling:String, memo:Data?, uploadImage:Data?, updateDate:String) -> Emotion {
        let e = Emotion()
        e.id = Emotion.incrementId()
        e.emotionImage = emotionImage
        e.feeling = feeling
        e.memo = memo
        e.uploadImage = uploadImage
        e.updateDate = updateDate
        
        return e
    }
    
    class func qry(_ query:String) -> [Emotion] {
        let realm = try! Realm()
        return query == "" ? realm.objects(Emotion.self).map{$0} : realm.objects(Emotion.self).filter(query).map{$0}
    }
    
    class func sortQry(_ query:String, _ sortKey:String, _ isAsc:Bool?) -> [Emotion] {
        let realm = try! Realm()
        if sortKey == "" {
            return query == "" ? realm.objects(Emotion.self).map{$0} : realm.objects(Emotion.self).filter(query).map{$0}
        }
        else {
            //nil이면 오름차순 리턴
            if isAsc == nil {
                return query == "" ? realm.objects(Emotion.self).sorted(byKeyPath: sortKey, ascending: true).map{$0} : realm.objects(Emotion.self).filter(query).sorted(byKeyPath: sortKey, ascending: true).map{$0}
            }
            else {
                guard let tmp = isAsc else { return [Emotion]() }
                return query == "" ? realm.objects(Emotion.self).sorted(byKeyPath: sortKey, ascending: tmp).map{$0} : realm.objects(Emotion.self).filter(query).sorted(byKeyPath: sortKey, ascending: tmp).map{$0}
            }
        }
    }
    
    func del(_ completion:(() -> Void)? = nil) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
            completion?()
        }
    }
    
    func insert() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    func update(_ feeling:String, _ memo:Data) {
        let realm = try! Realm()
        try! realm.write() {
            self.feeling = feeling
            self.memo = memo
            realm.add(self)
        }
    }
    
    
}
