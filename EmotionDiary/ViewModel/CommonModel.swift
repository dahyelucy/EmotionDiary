//
//  CommonModel.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/07/05.
//  Copyright © 2020 최다혜. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHandler = (() -> Void)
class DynamicValue<T> {

    var value: T {
        didSet {
            self.notify()
        }
    }

    private var observers = [String: CompletionHandler]()

    init(_ value: T) {
        self.value = value
    }

    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }

    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }

    private func notify() {
        observers.forEach({ $0.value() })
    }

    deinit {
        observers.removeAll()
    }
}

/**
 ViewModel Data 추상 클래스
 - var data: DynamicValue<[T]> : 바인딩을 지원하는 generic data type
 */
class ViewModelDataSource<T>: NSObject {
    /// 바인딩을 지원하는 generic data type
    var data: DynamicValue<[T]> = DynamicValue([])
}

