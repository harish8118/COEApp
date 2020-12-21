//
//  detailVC.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 23/07/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import SpreadsheetView


struct courses: Codable {
    let PROGRAMNAME: String?
    let EXAMINATION: String?
    let COURSENAME: String?
    let PERCENTAGE: Double?
    
    private enum CodingKeys: String, CodingKey {
        case PROGRAMNAME
        case EXAMINATION
        case COURSENAME
        case PERCENTAGE
    }
}

struct codeData: Codable {
    let PROGRAMNAME: String?
    let EXAMINATION: String?
    let COURSENAME: String?
    let CODESLIPS_PERCENTAGE: String?
    let AWARDS_PERCENTAGE: String?
    let PMARKS_PERCENTAGE: String?
    let IMARKS_PERCENTAGE: String?
    
    private enum CodingKeys: String, CodingKey {
        case PROGRAMNAME
        case EXAMINATION
        case COURSENAME
        case CODESLIPS_PERCENTAGE
        case AWARDS_PERCENTAGE
        case PMARKS_PERCENTAGE
        case IMARKS_PERCENTAGE
    }
}



class detailVC: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    
    let details = [  "SubCourse", "Internal Maarks %", "Practical Marks %", "Awards %", "CodeSlips %",""]
    
    @IBOutlet weak var detailSpredVW: SpreadsheetView!
    @IBOutlet weak var courseTF: UITextField!
    @IBOutlet weak var examInfo: UILabel!
    
    var coursePicker : UIPickerView!
    var courseIds : [courses]?
    var codeDtls : [codeData]?
    
    let dayColors = [UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1),
    UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
    UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
    UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1),
    UIColor(red: 0.400, green: 0.584, blue: 0.141, alpha: 1),
    UIColor(red: 0.835, green: 0.655, blue: 0.051, alpha: 1),
    UIColor(red: 0.153, green: 0.569, blue: 0.835, alpha: 1)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.courseTF.layer.cornerRadius = 6.0
        self.courseTF.layer.masksToBounds = true
        self.courseTF.layer.borderWidth = 1.0
        self.courseTF.layer.borderColor = UIColor.black.cgColor
        
        self.coursePicker = UIPickerView.init()
        self.coursePicker.showsSelectionIndicator = true
        self.coursePicker.delegate = self
        self.coursePicker.dataSource = self
        self.courseTF.inputView = self.coursePicker
        
        let defaults = UserDefaults.standard
        self.examInfo.text = "\(defaults.value(forKey: "exmSelct") ?? "I SEM")"
        
        
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "SELECT", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.courseTF.inputAccessoryView = toolBar5
        
//        let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
//        loadingView.shouldTapToDismiss = false
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadingView.show(on: view)
                
        let defaults = UserDefaults.standard
        let pgrm = "\(defaults.value(forKey: "pgrmSelct") ?? "PG")"
        let sem = "\(defaults.value(forKey: "exmSelct") ?? "I SEM")"
        print("selct:\(pgrm)--\(sem)");
        
        guard let gitUrll = URL(string: courseAPI + "\(pgrm )/\(sem )".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else { loadingView.hide()
            return
            
        }
        print("url:\(gitUrll)");
        
        URLSession.shared.dataTask(with: gitUrll) { (data, response, error) in
        
            if let err = error {
                print("err:\(err)")
                
                if Connectivity.isConnectedToInternet() {
                    print("Yes! internet is available.")
                    // do some tasks..
                }else{
                    let alert = UIAlertController(title: "Alert", message: "No internet is available. Please connect to network.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        guard let data = data else { return }
        do {
                            
            let decoder = JSONDecoder()
            self.courseIds = try decoder.decode([courses].self, from: data)
                        
            print("gitData:\(self.courseIds)")
                            
            DispatchQueue.main.sync {
                
            if  self.courseIds == nil {
                
                loadingView.hide()
                //SKActivityIndicator.dismiss()
                let alert = UIAlertController(title: "Message", message: "No Data Found..", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                                    
            }else {
                loadingView.hide()
            //SKActivityIndicator.dismiss()
                self.coursePicker.reloadAllComponents()
            }
                
            }
                            
        } catch let err {
            loadingView.hide()
            //SKActivityIndicator.dismiss()
            print("Err", err)
            
            }
        }.resume()
        
    }
    
    // MARK: DataSource

    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        if self.codeDtls != nil {
            return 6
        }
            return 0
        
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        if self.codeDtls != nil {
            return (self.codeDtls?.count ?? 0)+1
        }
            
        return 0
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
       if self.codeDtls != nil {
            if case 0 = column {
                return 150
            } else {
                return 150
            }
        }
        return 0
        
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        
        if self.codeDtls != nil {
            if case 0 = row {
                return 32
            }  else {
                return 50
            }
        }
        return 0
        
    }

    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
      if self.codeDtls != nil {
          return 1
      }
            return 0
        
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        if self.codeDtls != nil {
            return 1
        }
            return 0
        
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case (1...7, 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTitleCell.self), for: indexPath) as! DayTitleCell
            cell.label.text = details[indexPath.column - 1]
            cell.label.textColor = dayColors[indexPath.column]
            return cell
            
        }else if case (0, 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeTitleCell.self), for: indexPath) as! TimeTitleCell
            cell.label.text = "COURSE"
            cell.label.textAlignment = .center
            cell.label.backgroundColor = .groupTableViewBackground
            return cell
            
        }else if case (0, 1...(self.codeDtls?.count ?? 0)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
            
            cell.label.text = self.courseTF.text ?? "MBA"
            cell.label.textColor = dayColors[indexPath.column]
            cell.label.textAlignment = .center
            cell.label.backgroundColor = .groupTableViewBackground
            return cell
            
        }else if case (1, 1...(self.codeDtls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
            
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            
            
            cell.label.text = "\(self.codeDtls?[indexPath.row-1].COURSENAME ?? "ug")"
            let color = dayColors[indexPath.column]
            cell.label.textColor = color
            cell.label.textAlignment = .center
            cell.color = color.withAlphaComponent(0.2)
            cell.borders.top = .solid(width: 2, color: color)
            cell.borders.bottom = .solid(width: 2, color: color)
            
            return cell
            
        }else if case (2, 1...(self.codeDtls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
            
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            
            
            cell.label.text =  "\(self.codeDtls?[indexPath.row-1].IMARKS_PERCENTAGE ?? "0")%"
            let color = dayColors[indexPath.column]
            cell.label.textColor = color
            cell.label.textAlignment = .center
            cell.label.numberOfLines = 10;
            cell.color = color.withAlphaComponent(0.2)
            cell.borders.top = .solid(width: 2, color: color)
            cell.borders.bottom = .solid(width: 2, color: color)
            
            return cell
            
        }else if case (3, 1...(self.codeDtls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
            
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            
            
            cell.label.text =  "\(self.codeDtls?[indexPath.row-1].PMARKS_PERCENTAGE ?? "0")%"
            let color = dayColors[indexPath.column]
            cell.label.textColor = color
            cell.label.textAlignment = .center
            cell.color = color.withAlphaComponent(0.2)
            cell.borders.top = .solid(width: 2, color: color)
            cell.borders.bottom = .solid(width: 2, color: color)
            
            return cell
            
        }else if case (4, 1...(self.codeDtls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
            
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            
            
            cell.label.text =  "\(self.codeDtls?[indexPath.row-1].AWARDS_PERCENTAGE ?? "0")%"
            let color = dayColors[indexPath.column]
            cell.label.textColor = color
            cell.label.textAlignment = .center
            cell.color = color.withAlphaComponent(0.2)
            cell.borders.top = .solid(width: 2, color: color)
            cell.borders.bottom = .solid(width: 2, color: color)
            
            return cell
            
        }else if case (5, 1...(self.codeDtls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
            
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            
            
            cell.label.text =  "\(self.codeDtls?[indexPath.row-1].CODESLIPS_PERCENTAGE ?? "0")%"
            let color = dayColors[indexPath.column]
            cell.label.textColor = color
            cell.label.textAlignment = .center
            cell.color = color.withAlphaComponent(0.2)
            cell.borders.top = .solid(width: 2, color: color)
            cell.borders.bottom = .solid(width: 2, color: color)
            
            return cell
            
        }
        
        return nil
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        if case (2, 1...(self.codeDtls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
            print("Imarks:\(self.codeDtls?[indexPath.row-1].IMARKS_PERCENTAGE ?? "0")%")
            
            let defaults = UserDefaults.standard
            defaults.setValue("\(self.codeDtls?[indexPath.row-1].COURSENAME ?? "0")", forKey: "crseSelct")
            
            let vc:intrnlVC = self.storyboard?.instantiateViewController(withIdentifier: "intrnlVC") as! intrnlVC
            self.navigationController?.isNavigationBarHidden = false
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else  if case (3, 1...(self.codeDtls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
            print("Pmarks:\(self.codeDtls?[indexPath.row-1].PMARKS_PERCENTAGE ?? "0")%")
            
            let defaults = UserDefaults.standard
            defaults.setValue("\(self.codeDtls?[indexPath.row-1].COURSENAME ?? "0")", forKey: "crseSelct")
            
            let vc:practVC = self.storyboard?.instantiateViewController(withIdentifier: "practVC") as! practVC
            self.navigationController?.isNavigationBarHidden = false
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if case (4, 1...(self.codeDtls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
            print("Awards:\(self.codeDtls?[indexPath.row-1].AWARDS_PERCENTAGE ?? "0")%")
            
            let defaults = UserDefaults.standard
            defaults.setValue("\(self.codeDtls?[indexPath.row-1].COURSENAME ?? "0")", forKey: "crseSelct")
            
            let vc:award1VC = self.storyboard?.instantiateViewController(withIdentifier: "award1VC") as! award1VC
            self.navigationController?.isNavigationBarHidden = false
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if case (5, 1...(self.codeDtls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
            print("Cdslips:\(self.codeDtls?[indexPath.row-1].CODESLIPS_PERCENTAGE ?? "0")%")
            
            let defaults = UserDefaults.standard
            defaults.setValue("\(self.codeDtls?[indexPath.row-1].COURSENAME ?? "0")", forKey: "crseSelct")
            
            let vc:codSlpVC = self.storyboard?.instantiateViewController(withIdentifier: "codSlpVC") as! codSlpVC
            self.navigationController?.isNavigationBarHidden = false
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
        }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == self.coursePicker {
                return self.courseIds?.count ?? 0
                
            }
           return 10
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
            if (pickerView==self.coursePicker) {
                return self.courseIds?[row].COURSENAME
               
            }
            return "-- NO DATA --"
       }
       
       func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
    
           var pickerLabel = view as? UILabel;

           if (pickerLabel == nil)
           {
               pickerLabel = UILabel()

               pickerLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
               pickerLabel?.textAlignment = NSTextAlignment.center
           }

    
            if (pickerView==self.coursePicker) {
                pickerLabel?.text = self.courseIds?[row].COURSENAME
               
            }
           
           return pickerLabel!
           
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
           
            if pickerView == self.coursePicker {
               self.courseTF.text = self.courseIds?[row].COURSENAME
                

            }
           
       }
    
    
    @IBAction func homeAct(_ sender: UIBarButtonItem) {
        let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func resign(){
        self.courseTF.resignFirstResponder()
        
        loadingView.show(on: view)
                
        let defaults = UserDefaults.standard
        let pgrm = defaults.value(forKey: "pgrmSelct")
        let sem = defaults.value(forKey: "exmSelct")
        
         guard let gitUrl = URL(string: codeAPI + "\(pgrm ?? "PG")/\(sem ?? "I SEM")/\(self.courseTF.text ?? "MBA")".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else { return }
         print("url:\(gitUrl)");
        URLSession.shared.dataTask(with: gitUrl) { (data, response, error) in
        
            if let err = error {
                print("err:\(err)")
                
                if Connectivity.isConnectedToInternet() {
                    print("Yes! internet is available.")
                    // do some tasks..
                }else{
                    let alert = UIAlertController(title: "Alert", message: "No internet is available. Please connect to network.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        guard let data = data else { return }
        do {
                            
            let decoder = JSONDecoder()
            self.codeDtls = try decoder.decode([codeData].self, from: data)
                        
            print("gitData:\(self.codeDtls)")
                            
            DispatchQueue.main.sync {
                
            if  self.codeDtls == nil {
                
                loadingView.hide()
                //SKActivityIndicator.dismiss()
                let alert = UIAlertController(title: "Message", message: "No Data Found..", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                                    
            }else {
                loadingView.hide()
            //SKActivityIndicator.dismiss()
                self.detailSpredVW.layer.borderWidth = 1
                self.detailSpredVW.layer.masksToBounds = true
                
                self.detailSpredVW.dataSource = self
                self.detailSpredVW.delegate = self

                //self.detailSpredVW.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

                self.detailSpredVW.intercellSpacing = CGSize(width: 4, height: 1)
                self.detailSpredVW.gridStyle = .none

                self.detailSpredVW.register(DateCell.self, forCellWithReuseIdentifier: String(describing: DateCell.self))
                self.detailSpredVW.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
                self.detailSpredVW.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
                self.detailSpredVW.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
                self.detailSpredVW.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
                
                self.detailSpredVW.reloadData()
            }
                
            }
                            
        } catch let err {
            loadingView.hide()
            //SKActivityIndicator.dismiss()
            print("Err", err)
            
            }
        }.resume()
 
    }

}
