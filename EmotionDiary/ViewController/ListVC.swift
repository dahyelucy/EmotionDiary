//
//  ListVC.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/08/23.
//  Copyright © 2020 최다혜. All rights reserved.
//

import UIKit


class ListVC: UIViewController, Storyboarded, ListVCDataSourceDelegate {
  

    @IBOutlet weak var listTv: UITableView!
    var emIdFromMain:Int?
    
    let dataSource = ListVCDataSource()
    lazy var viewModel: ListVM = {
        let viewModel = ListVM(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ListVC에서만 navigationController가 보이게 함
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.backItem?.title = ""
        
        listTv.delegate = self
        listTv.dataSource = dataSource
        dataSource.data.addAndNotify(observer: self) { [unowned self] in
            self.listTv.reloadData()
        }
        dataSource.viewController = self
        dataSource.delegate = self
        
        viewModel.fetchData()
        
        guard let index = emIdFromMain else { return }
        listTv.scrollTo(index)
        DispatchQueue.main.async {
            self.setNavigationBarDateTitle(index)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveWriteEvent), name: .WriteEmotion, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setNavigationBarDateTitle(_ index:Int) {
        guard let year = dataSource.data.value[index].updateDate?.toDate().returnEachItem(input: .year),
              let month = dataSource.data.value[index].updateDate?.toDate().returnEachItem(input: .monthLong).uppercased()
        else { return }
        self.navigationController?.navigationBar.topItem?.title = "\(month) \(year)"
    }
    
    func pressDeleteCellToVM(sender: Int) {
        Emotion.qry("id == \(sender)")[0].del() { [unowned self] in
            DispatchQueue.main.async {
                self.viewModel.fetchData()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .WriteEmotion, object: nil)
    }
    
    @objc func receiveWriteEvent() {
        // table view refresh
        viewModel.fetchData()
    }
}

extension ListVC: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("scrollViewWillBeginDragging")
        for cell in listTv.visibleCells {
            guard let indexPathItem = listTv.indexPath(for: cell) else { return }
            setNavigationBarDateTitle(indexPathItem.row)
        }
        
    }
}

extension UITableView {
    func scrollTo(_ index: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: index, section: 0)
            self.scrollToRow(at: indexPath, at: .middle, animated: false)
        }
    }
}
