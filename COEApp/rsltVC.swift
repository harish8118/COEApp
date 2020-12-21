//
//  rsltVC.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 25/08/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

struct prgrm: Codable {
    let PROGRAM: String?
    
    private enum CodingKeys: String, CodingKey {
        case PROGRAM
    }
}

struct exam: Codable {
    let EXAMINATION: String?
    
    private enum CodingKeys: String, CodingKey {
        case EXAMINATION
    }
}

struct crse: Codable {
    let COURSE: String?
    
    private enum CodingKeys: String, CodingKey {
        case COURSE
    }
}

struct subCrse: Codable {
    let COURSENAME: String?
    
    private enum CodingKeys: String, CodingKey {
        case COURSENAME
    }
}

class rsltVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var prgrmTF: UITextField!
    @IBOutlet weak var examTF: UITextField!
    @IBOutlet weak var courseTF: UITextField!
    @IBOutlet weak var subCourseTF: UITextField!
    @IBOutlet weak var submitBttn: UIButton!
    
    @IBOutlet weak var prgrmErr: UILabel!
    @IBOutlet weak var examErr: UILabel!
    @IBOutlet weak var courseErr: UILabel!
    @IBOutlet weak var subCourseErr: UILabel!
    
    var prgrmPicker : UIPickerView!
    var examPicker : UIPickerView!
    var coursePicker : UIPickerView!
    var subCoursePicker : UIPickerView!
    
    var prgrms : [prgrm]?
    var crses : [crse]?
    var exams : [exam]?
    var subCrses : [subCrse]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated:true);
        
        self.submitBttn.layer.cornerRadius = 6.0
        self.submitBttn.layer.masksToBounds = true
        
        self.prgrmTF.layer.cornerRadius = 6.0
        self.prgrmTF.layer.masksToBounds = true
        self.prgrmTF.layer.borderWidth = 1.0
        self.prgrmTF.layer.borderColor = UIColor.black.cgColor
        
        self.examTF.layer.cornerRadius = 6.0
        self.prgrmTF.layer.masksToBounds = true
        self.prgrmTF.layer.borderWidth = 1.0
        self.prgrmTF.layer.borderColor = UIColor.black.cgColor
        
        self.courseTF.layer.cornerRadius = 6.0
        self.courseTF.layer.masksToBounds = true
        self.courseTF.layer.borderWidth = 1.0
        self.courseTF.layer.borderColor = UIColor.black.cgColor
        
        self.subCourseTF.layer.cornerRadius = 6.0
        self.subCourseTF.layer.masksToBounds = true
        self.subCourseTF.layer.borderWidth = 1.0
        self.subCourseTF.layer.borderColor = UIColor.black.cgColor
        
        self.prgrmPicker = UIPickerView.init()
        self.prgrmPicker.showsSelectionIndicator = true
        self.prgrmPicker.delegate = self
        self.prgrmPicker.dataSource = self
        self.prgrmTF.inputView = self.prgrmPicker
        
        self.examPicker = UIPickerView.init()
        self.examPicker.showsSelectionIndicator = true
        self.examPicker.delegate = self
        self.examPicker.dataSource = self
        self.examTF.inputView = self.examPicker
        
        self.coursePicker = UIPickerView.init()
        self.coursePicker.showsSelectionIndicator = true
        self.coursePicker.delegate = self
        self.coursePicker.dataSource = self
        self.courseTF.inputView = self.coursePicker
        
        self.subCoursePicker = UIPickerView.init()
        self.subCoursePicker.showsSelectionIndicator = true
        self.subCoursePicker.delegate = self
        self.subCoursePicker.dataSource = self
        self.subCourseTF.inputView = self.subCoursePicker
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "SELECT", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.courseTF.inputAccessoryView = toolBar5
        self.prgrmTF.inputAccessoryView = toolBar5
        self.examTF.inputAccessoryView = toolBar5
        self.subCourseTF.inputAccessoryView = toolBar5
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadingView.show(on: view)
        
        guard let gitUrll = URL(string: rsltPgrmAPI ) else { loadingView.hide()
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
            self.prgrms = try decoder.decode([prgrm].self, from: data)
                        
            print("gitData:\(self.prgrms)")
                            
            DispatchQueue.main.sync {
                
            if  self.prgrms == nil {
                
                loadingView.hide()
                //SKActivityIndicator.dismiss()
                let alert = UIAlertController(title: "Message", message: "No Data Found..", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                                    
            }else {
                loadingView.hide()
            //SKActivityIndicator.dismiss()
                self.prgrmPicker.reloadAllComponents()
            }
                
            }
                            
        } catch let err {
            loadingView.hide()
            //SKActivityIndicator.dismiss()
            print("Err", err)
            
            }
        }.resume()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
        }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == self.prgrmPicker {
                return self.prgrms?.count ?? 0
                
            }else  if pickerView == self.examPicker {
                return self.exams?.count ?? 0
                
            }else if pickerView == self.coursePicker {
                return self.crses?.count ?? 0
                
            }else if pickerView == self.subCoursePicker {
                return self.subCrses?.count ?? 0
                
            }
        
           return 10
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
            if (pickerView==self.prgrmPicker) {
                return self.prgrms?[row].PROGRAM
               
            }else if (pickerView==self.examPicker) {
                return self.exams?[row].EXAMINATION
               
            }else if (pickerView==self.coursePicker) {
                return self.crses?[row].COURSE
               
            }else if (pickerView==self.subCoursePicker) {
                return self.subCrses?[row].COURSENAME
               
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

    
            if (pickerView==self.prgrmPicker) {
                pickerLabel?.text = self.prgrms?[row].PROGRAM
               
            }else if (pickerView==self.examPicker) {
                pickerLabel?.text = self.exams?[row].EXAMINATION
               
            }else if (pickerView==self.coursePicker) {
                pickerLabel?.text = self.crses?[row].COURSE
               
            }else  if (pickerView==self.subCoursePicker) {
                pickerLabel?.text = self.subCrses?[row].COURSENAME
               
            }
           
           return pickerLabel!
           
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
           
            if pickerView == self.prgrmPicker {
               self.prgrmTF.text = self.prgrms?[row].PROGRAM
                
                loadingView.show(on: view)
                
                guard let gitUrll = URL(string: rsltExamAPI + (self.prgrms?[row].PROGRAM ?? " ") .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else { loadingView.hide()
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
                    self.exams = try decoder.decode([exam].self, from: data)
                                
                    print("gitData:\(self.exams)")
                                    
                    DispatchQueue.main.sync {
                        
                    if  self.exams == nil {
                        
                        loadingView.hide()
                        //SKActivityIndicator.dismiss()
                        let alert = UIAlertController(title: "Message", message: "No Data Found..", preferredStyle: UIAlertController.Style.actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)

                                            
                    }else {
                        loadingView.hide()
                    //SKActivityIndicator.dismiss()
                        self.examPicker.reloadAllComponents()
                    }
                        
                    }
                                    
                } catch let err {
                    loadingView.hide()
                    //SKActivityIndicator.dismiss()
                    print("Err", err)
                    
                    }
                }.resume()

            }else if pickerView == self.examPicker {
                self.examTF.text = self.exams?[row].EXAMINATION
                    
                loadingView.show(on: view)
                
                guard let gitUrll = URL(string: rsltCourseAPI + "\(self.prgrmTF.text ?? " ")/\(self.exams?[row].EXAMINATION ?? " ")" .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else { loadingView.hide()
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
                    self.crses = try decoder.decode([crse].self, from: data)
                                
                    print("gitData:\(self.crses)")
                                    
                    DispatchQueue.main.sync {
                        
                    if  self.crses == nil {
                        
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
                
            }else if pickerView == self.coursePicker {
                self.courseTF.text = self.crses?[row].COURSE
                    
                loadingView.show(on: view)
                
                guard let gitUrll = URL(string: rsltSubCourseAPI + "\(self.prgrmTF.text ?? " ")/\(self.examTF.text ?? " ")/\(self.crses?[row].COURSE ?? " ")" .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else { loadingView.hide()
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
                    self.subCrses = try decoder.decode([subCrse].self, from: data)
                                
                    print("gitData:\(self.subCrses)")
                                    
                    DispatchQueue.main.sync {
                        
                    if  self.subCrses == nil {
                        
                        loadingView.hide()
                        //SKActivityIndicator.dismiss()
                        let alert = UIAlertController(title: "Message", message: "No Data Found..", preferredStyle: UIAlertController.Style.actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)

                                            
                    }else {
                        loadingView.hide()
                    //SKActivityIndicator.dismiss()
                        self.subCoursePicker.reloadAllComponents()
                    }
                        
                    }
                                    
                } catch let err {
                    loadingView.hide()
                    //SKActivityIndicator.dismiss()
                    print("Err", err)
                    
                    }
                }.resume()
                
            }else if pickerView == self.subCoursePicker {
                self.subCourseTF.text = self.subCrses?[row].COURSENAME
                
            }
           
       }

    @IBAction func submitAct(_ sender: UIButton) {
        if self.prgrmTF.text?.count == 0 {
            self.prgrmErr.isHidden = false
            
        }else if self.examTF.text?.count == 0 {
            self.examErr.isHidden = false
            
        }else if self.courseTF.text?.count == 0 {
            self.courseErr.isHidden = false
            
        }else if self.subCourseTF.text?.count == 0 {
            self.subCourseErr.isHidden = false
            
        }else if self.prgrmTF.text?.count ?? 0>0 && self.examTF.text?.count ?? 0>0 && self.courseTF.text?.count ?? 0>0 && self.subCourseTF.text?.count ?? 0>0 {
            
            self.prgrmErr.isHidden = true
            self.examErr.isHidden = true
            self.courseErr.isHidden = true
            self.subCourseErr.isHidden = true
            
        let defaults = UserDefaults.standard
            defaults.set("\(self.prgrmTF.text ?? " ")/\(self.examTF.text ?? " ")/\(self.courseTF.text ?? " ")/\(self.subCourseTF.text ?? " ")", forKey: "rsltLink")
            
        let vc:resultDtlVC = self.storyboard?.instantiateViewController(withIdentifier: "resultDtlVC") as! resultDtlVC
            self.navigationController?.isNavigationBarHidden = false
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @IBAction func homeAct(_ sender: UIBarButtonItem) {
        let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func resign(){
        self.prgrmTF.resignFirstResponder()
        self.examTF.resignFirstResponder()
        self.courseTF.resignFirstResponder()
        self.subCourseTF.resignFirstResponder()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
