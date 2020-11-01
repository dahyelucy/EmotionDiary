//
//  WriteVC.swift
//  EmotionDiary
//
//  Created by 최다혜 on 2020/06/28.
//  Copyright © 2020 최다혜. All rights reserved.
//

import UIKit

class WriteVC: UIViewController, Storyboarded {

    /* Outer View */
    @IBOutlet var topVw: UIView!
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var titleVw: UIView!
    /* Write View */
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var emotionVw: UIImageView!
    @IBOutlet weak var emotionTxt: UITextView!
    @IBOutlet weak var memoTxt: UITextView!
    @IBOutlet weak var weekLb: UILabel!
    @IBOutlet weak var dayLb: UILabel!
    @IBOutlet weak var writeVw: UIView!
    /* Picker View */
    @IBOutlet weak var pickerOOuterVw: UIView!
    @IBOutlet weak var pickerOuterVw: UIView!
    @IBOutlet weak var pickerYearLb: UILabel!
    @IBOutlet weak var pickerVw: UIPickerView!
    @IBOutlet weak var pickerCloseBtn: UIButton!
    @IBOutlet weak var pickerSaveBtn: UIButton!
    
    var pickerDateArr:[PickerData] = []
    var nowPickerData:PickerData? = nil
    var selectImg:UIImage? = nil
    var selectTxt:String = ""
    
    //ListVC에서 넘어오는 수정용 변수
    var isFromEdit:Bool = false
    var emotionData:Emotion?
    
    /* 사진앨범 선택 */
    lazy var imagePicker = UIImagePickerController()
    
    /* 텍스트 정렬 */
    var nowMemoTextAlign:TextAlignment = .center
    var toolBarKeyboard = UIToolbar()
    var btnBars:[UIBarButtonItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerOOuterVw.isHidden = true
        
        //ListVC의 Edit화면에서 온 경우
        if isFromEdit {
            guard let updateDate = emotionData?.updateDate?.toDate(), let eimg = emotionData?.emotionImage, let txt = emotionData?.feeling, let memo = emotionData?.memo else { return }
            selectImg = UIImage(data: eimg)
            selectTxt = txt
            setWriteVC(updateDate, selectImg, selectTxt, memo)
            memoTxt.becomeFirstResponder()
        }
        else {
            //오늘 날짜에 데이터가 생성되어 있으면 pickerView 보여주기,
            if isExistTodayData() {
                setPickerView()
            }
            //오늘 날짜에 데이터가 생성되어 있지 않으면 write view 보여주기
            else {
                let date = Date()
                setWriteVC(date, selectImg, selectTxt, nil)
                memoTxt.becomeFirstResponder()
            }
        }
    }
    
    @IBAction func pushCloseBtn(_ sender: Any) {
        memoTxt.resignFirstResponder()
        //1. customrView
//        let popupView = PopupView()
//        topVw.addSubview(popupView)
//        popupView.frame = self.topVw.frame
//        self.topVw.addSubview(popupView)
        
        //2. Alert default
        let temp = UIAlertController().getAlert("나가기","작성한 내용이 저장되지 않아요. 화면을 닫을까요?",
            nil,
            {   action in
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: .WriteEmotion, object: nil) })
        self.present(temp, animated: true, completion: nil)
    
    }
    
    @IBAction func pushSaveBtn(_ sender: Any) {
        guard let simg = selectImg else { return }
        guard let dimg = simg.pngData() else { return }
//        var feeling:String = selectTxt
        let feeling:String = emotionTxt.text
        var rtfdData:Data
        var updateDate:String = Date().returnTodayDate()
        
        do {
            rtfdData = try memoTxt.attributedText.data(from: .init(location: 0, length: memoTxt.attributedText.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
            
            if isFromEdit {
                guard let temp = emotionData else { return }
                temp.update(feeling, rtfdData)
            }
            else {
                //오늘 날짜에 데이터가 생성되어 있음
                if isExistTodayData() {
                    guard let tmpDate = nowPickerData?.dateFormat else { return }
                    updateDate = tmpDate
                }
                else {
                    updateDate = Date().returnTodayDate()
                }
                Emotion.fromFunc(emotionImage: dimg, feeling: feeling, memo: rtfdData, uploadImage: nil, updateDate: updateDate).insert()
            }
            
            self.dismiss(animated: true, completion: nil)
            //추가된 데이터 mainVC에 전달
            NotificationCenter.default.post(name: .WriteEmotion, object: nil)
            
        } catch {
            print(error)
        }
    }
    
    @IBAction func pushPickerCloseBtn(_ sender: Any) {
        pickerOOuterVw.isHidden = true
        guard let nowPickerDate = nowPickerData?.dateFormat else { return }
        setWriteVC(nowPickerDate.toDate(), selectImg, selectTxt, nil)
    }
    
    @IBAction func pushPickerSaveBtn(_ sender: Any) {
        //picker 선택된 곳에 데이터 있으면 신규 생성 안됨
        guard let pickerSelectDate = nowPickerData?.dateFormat else { return }
        if isExistData(pickerSelectDate) {
            pickerOuterVw.shake()
        }
        else {
            pickerOOuterVw.isHidden = true
            setWriteVC(pickerSelectDate.toDate(), selectImg, selectTxt, nil)
            memoTxt.becomeFirstResponder()
        }
    }
    
    func isExistTodayData() -> Bool {
        let today = Date().returnTodayDate()
        return Emotion.qry("updateDate == '\(today)'").count > 0 ? true : false
    }
    
    func isExistData(_ date: String) -> Bool {
        return Emotion.qry("updateDate == '\(date)'").count > 0 ? true : false
    }
    
    func findMaxDateInfoWithNoData() -> [String:Any] {
        var result = [String:Any]()
        for i in stride(from: pickerDateArr.count-1, to: 0, by: -1) {
            let date = pickerDateArr[i].dateFormat
            if !isExistData(date) {
                result["date"] = date
                result["index"] = i
                break
            }
        }
        return result
    }
    
    func setPickerDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let startDate = dateFormatter.date(from:"2020-01-01")!
        for i in 0..<Date().returnUtilTodayCount() {
            let nextDate = Calendar.current.date(byAdding: .day, value: i, to: startDate)!
            let nextDateToStr = dateFormatter.string(from: nextDate)
            let result = Date().returnMonthDayWeek(input: nextDateToStr)
            guard let year = Calendar(identifier: .gregorian).dateComponents([.year], from: nextDate).year else { return }
            
            pickerDateArr.append(PickerData(year: year.toString(), dateFormat: nextDateToStr, dateFormatToKorean: result))
        }
    }
    
    func setPickerView() {
        //2020-01-01부터 현재일까지 PickerDate 셋팅
        setPickerDate()
        let maxDateInfo = findMaxDateInfoWithNoData()
        let maxDate = maxDateInfo["date"] as! String
        let maxDateIndex = maxDateInfo["index"] as! Int
        //nowPickerData 기본값 세팅
        nowPickerData = pickerDateArr[maxDateIndex]
        
        pickerVw.delegate = self
        pickerVw.dataSource = self
        pickerOOuterVw.isHidden = false
        pickerCloseBtn.tintColor = .black
        pickerSaveBtn.tintColor = .black
        
        setWriteVC(maxDate.toDate(), selectImg, selectTxt, nil)
        pickerVw.selectRow(maxDateIndex, inComponent: 0, animated: true)
        
    }
    
    
    func setWriteVC(_ date:Date, _ img:UIImage?, _ txt:String, _ memo:Data?) {
        
        scrollVw.delegate = self
        
        dayLb.underline()
        writeVw.layer.borderWidth = 0.5
        writeVw.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 100) //black
        
        memoTxt.delegate = self
        memoTxt.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 100) //white
        memoTxt.textAlignment = nowMemoTextAlign.returnNSTextAlignment
        memoTxt.isScrollEnabled = false
//        memoTxt.translatesAutoresizingMaskIntoConstraints = true
        
        closeBtn.tintColor = .black
        saveBtn.tintColor = .black
        
        let year = date.returnEachItem(input: .year)
        let month = date.returnEachItem(input: .monthLong).uppercased()
        let day = date.returnEachItem(input: .day)
        let week = date.returnEachItem(input: .weekShort).uppercased()
        
        dateLb.text = "\(month) \(year)"
        dayLb.text = day
        weekLb.text = week
        
        emotionVw.image = img
        emotionTxt.text = txt
        memoTxt.layer.borderWidth = 0.5
        if memo != nil {
            memoTxt.attributedText = memo!.toNSAttributedString(.rtfd)
        }
        setMemoTextViewKeyboardToolBar()
    }

    func setMemoTextViewKeyboardToolBar() {
        toolBarKeyboard.sizeToFit()
        btnBars = [UIBarButtonItem]()
        
        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(self.pushMemoTextViewCameraBtn))
        let textAlignment = UIBarButtonItem(image: nowMemoTextAlign.image, style: .plain, target: self, action: #selector(self.pushMemoTextViewTextAlignmentBtn))
        
        btnBars.append(camera)
        btnBars.append(textAlignment)
        toolBarKeyboard.setItems(btnBars, animated: true)
        memoTxt.inputAccessoryView = toolBarKeyboard
    }
    
    @objc func pushMemoTextViewCameraBtn() {
        //사진앨범 불러오기
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func pushMemoTextViewTextAlignmentBtn() {
        //텍스트 정렬 버튼
        let nowAlignment:TextAlignment = nowMemoTextAlign
        switch nowAlignment {
        case .center :
            nowMemoTextAlign = .left
            break
        case .left :
            nowMemoTextAlign = .right
            break
        case .right :
            nowMemoTextAlign = .center
            break
        }
        memoTxt.textAlignment = nowMemoTextAlign.returnNSTextAlignment
        setMemoTextViewKeyboardToolBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension WriteVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Date().returnUtilTodayCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return pickerDateArr[row].dateFormatToKorean
    }
}

extension WriteVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pr = PickerRow(frame: CGRect(x: 0, y: 0, width: 170, height: 50))
        let rowDate = pickerDateArr[row].dateFormat
        let isNone = Emotion.qry("updateDate == '\(rowDate)'").count == 0 ? true : false
        if isNone == false {
            guard let data = Emotion.qry("updateDate == '\(rowDate)'")[0].emotionImage else { return UIView() }
            pr.emotionVw.image = UIImage(data: data)
        }
        guard let ad = pickerDateArr[row].dateFormatToKorean as? String else { return UIView() }
        pr.dateLb.text = ad
        return pr
    }
    
    //pickerView 선택 시 작동되는 함수, year 변경하기
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerYearLb.text = pickerDateArr[row].year
        nowPickerData = pickerDateArr[row]
    }
}

extension WriteVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] else { return }
        //불러온 이미지 압축하기
        guard let resizeImage = UIImage.resizeImage(image as! UIImage, memoTxt.bounds.size.width - 50) else { return }
        
        //image 객체 생성
        let attachImage = NSTextAttachment()
        attachImage.image = resizeImage
        let attachString = NSAttributedString(attachment: attachImage)
        memoTxt.textStorage.insert(attachString, at: memoTxt.selectedRange.location)
        memoTxt.textAlignment = nowMemoTextAlign.returnNSTextAlignment
        

        dismiss(animated: true, completion: nil)
    }
}

extension WriteVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
//        memoTxt.textAlignment = .center
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let size = CGSize(width: memoTxt.frame.width, height: .infinity)
        let estimateSize = memoTxt.sizeThatFits(size)
        print("emotionVw constraints : \(emotionVw.constraints)")
        print("emotionVw height : \(emotionVw.bounds.height)")
        print("emotionVw width : \(emotionVw.bounds.width)")
        
        memoTxt.constraints.forEach{ (constraints) in
            if constraints.firstAttribute == .height {
                constraints.constant = estimateSize.height
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        memoTxt.textAlignment = .center
    }
    
}

extension WriteVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
