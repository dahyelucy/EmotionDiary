//
//  ListVM.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/09/06.
//  Copyright © 2020 최다혜. All rights reserved.
//

import Foundation
import UIKit

protocol ListVCDataSourceDelegate:NSObjectProtocol {
    func pressDeleteCellToVM(sender: Int)
}
class ListVCDataSource: ViewModelDataSource<Emotion>, UITableViewDataSource, ListCellDelegate  {
    weak var viewController: UIViewController?
    var delegate:ListVCDataSourceDelegate!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell else { return UITableViewCell()}
        cell.viewController = viewController
        cell.delegate = self
        
        guard let ud = data.value[indexPath.row].updateDate else { return UITableViewCell() }
        guard let ei = data.value[indexPath.row].emotionImage else { return UITableViewCell() }
        guard let memoData = data.value[indexPath.row].memo else { return UITableViewCell() }
        let memoAttrStr = memoData.toNSAttributedString(.rtfd)
        
        cell.dayLb.text = ud.toDate().returnEachItem(input: .day)
        cell.weekLb.text = ud.toDate().returnEachItem(input: .weekShort).uppercased()
        cell.emotionVw.image = UIImage(data: ei)
        cell.emotionLb.text = data.value[indexPath.row].feeling
        cell.emotionId = data.value[indexPath.row].id
        cell.memoTxt.attributedText = memoAttrStr
        
        return cell
    }

    func pressDeleteCell(sender: Int) {
        delegate.pressDeleteCellToVM(sender: sender)
    }
   
}

struct ListVM {
    weak var dataSource:ListVCDataSource?

    init(dataSource:ListVCDataSource?) {
        self.dataSource = dataSource
    }

    func fetchData() {
        let emotions:[Emotion] = Emotion.sortQry("", "updateDate", true)
        dataSource?.data.value = emotions
    }
}

