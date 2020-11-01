//
//  ViewController.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/06/28.
//  Copyright © 2020 최다혜. All rights reserved.
//

import UIKit


class MainVC: UIViewController, MainVCDataSourceDelegate {

    @IBOutlet weak var mainCv: UICollectionView!
    @IBOutlet weak var selectBtn: UIButton!
    
    //콜렉션 뷰 carousel용 변수
    var isOneStepPaging = true
    var currentIndex: CGFloat = 0
    
    //최초 진입인지 ListVC에서 진입한 것인지 판별하는 변수
    var isFromListVC:Bool = false
    
    let dataSource = MainVCDataSource()
    lazy var viewModel: MainVM = {
        let viewModel = MainVM(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectBtn.tintColor = .black
        
        setupFlowLayout()
        mainCv.delegate = self
        mainCv.dataSource = dataSource
        dataSource.data.addAndNotify(observer: self) { [unowned self] in
            self.mainCv.reloadData()
        }
        dataSource.delegate = self
        
        // 스크롤 시 빠르게 감속 되도록 설정
        mainCv.decelerationRate = UIScrollView.DecelerationRate.fast

        navigationController?.navigationBar.isHidden = true
        viewModel.fetchData()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveWriteEvent), name: .WriteEmotion, object: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //MainVC에 최초 진입이면
        //가장 최신 달로 이동
        if isFromListVC == false {
            guard let row = viewModel.dataSource?.data.value.count else { return }
            mainCv.scrollToItem(at: IndexPath(row: row-1, section: 0), at: .top, animated: false)
        }
        //ListVC에서 넘어왔으면 데이터 reload
        else {
            viewModel.fetchData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .WriteEmotion, object: nil)
    }
    
    @objc func receiveWriteEvent() {
        // table view refresh
        viewModel.fetchData()
    }
    
    @IBAction func pushSelectBtn(_ sender: Any) {
        let nextVC = SelectVC.instantiate(.Main)
        present(nextVC, animated: true, completion: nil)
    }

    private func setupFlowLayout() {
        //calendar 모양의 cell 등록
        let nib = UINib(nibName: "MainCell", bundle: nil)
        mainCv.register(nib, forCellWithReuseIdentifier: "MainCell")
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        //-50 안해주면 CV 밖으로 빠져나감
        flowLayout.itemSize = CGSize(width: mainCv.frame.width-50, height: mainCv.frame.height)
        self.mainCv.collectionViewLayout = flowLayout
    }
    
    func didPressCellToVM(sender: Int) {
        isFromListVC = true
        let listVC = ListVC.instantiate(.Main)
        listVC.emIdFromMain = sender
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
}

extension MainVC: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = mainCv.collectionViewLayout as! UICollectionViewFlowLayout
        let cellHeightIncludingSpacing = layout.itemSize.height + layout.minimumLineSpacing
        
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.y + scrollView.contentInset.top) / cellHeightIncludingSpacing
        var roundedIndex = round(index)
        
        // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
        // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
//        if scrollView.contentOffset.y > targetContentOffset.pointee.y {
//            roundedIndex = floor(index)
//        } else if scrollView.contentOffset.y < targetContentOffset.pointee.y {
//            roundedIndex = ceil(index)
//        } else {
//            roundedIndex = round(index)
//        }
//
//        if isOneStepPaging {
//            if currentIndex > roundedIndex {
//                currentIndex -= 1
//                roundedIndex = currentIndex
//            } else if currentIndex < roundedIndex {
//                currentIndex += 1
//                roundedIndex = currentIndex
//            }
//        }
        
        if scrollView.contentOffset.y > targetContentOffset.pointee.y {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        }
        
        
        // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
//        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        offset = CGPoint(x: -scrollView.contentInset.left, y: roundedIndex * cellHeightIncludingSpacing - scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
    
}
