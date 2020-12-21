//
//  rsltPgrmVC.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 25/08/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

struct prgrms: Codable {
    let PROGRAMNAME: String?
    
    private enum CodingKeys: String, CodingKey {
        case PROGRAMNAME
    }
}

struct links: Codable {
    let LINK_DESCRIPTION: String?
    
    private enum CodingKeys: String, CodingKey {
        case LINK_DESCRIPTION
    }
}


class rsltPgrmVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var prgrmTF: UITextField!
    @IBOutlet weak var linkTbl: UITableView!
    
    var prgrmPicker : UIPickerView!
    var prgrm : [prgrms]?
    var link : [links]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated:true);
        
        self.prgrmTF.layer.cornerRadius = 6.0
        self.prgrmTF.layer.masksToBounds = true
        self.prgrmTF.layer.borderWidth = 1.0
        self.prgrmTF.layer.borderColor = UIColor.black.cgColor
        
        self.prgrmPicker = UIPickerView.init()
        self.prgrmPicker.showsSelectionIndicator = true
        self.prgrmPicker.delegate = self
        self.prgrmPicker.dataSource = self
        self.prgrmTF.inputView = self.prgrmPicker
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "SELECT", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.prgrmTF.inputAccessoryView = toolBar5
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadingView.show(on: view)
        
        guard let gitUrll = URL(string: linkPrgrmAPI ) else { loadingView.hide()
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
            self.prgrm = try decoder.decode([prgrms].self, from: data)
                        
            print("gitData:\(self.prgrm)")
                            
            DispatchQueue.main.sync {
                
            if  self.prgrm == nil {
                
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.link != nil {
            return self.link?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rtrn : dashCell = tableView.dequeueReusableCell(withIdentifier: "links") as! dashCell
        
        
        rtrn.txtLbl.text = "  🎓 \(self.link?[indexPath.row].LINK_DESCRIPTION ?? "ug")"
        

        rtrn.txtLbl.layer.cornerRadius = 8.0
        rtrn.txtLbl.layer.masksToBounds = true
        rtrn.txtLbl.layer.borderWidth = 1.0
        rtrn.txtLbl.layer.borderColor = UIColor.black.cgColor
        
        
        
        return  rtrn
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
        }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == self.prgrmPicker {
                return self.prgrm?.count ?? 0
                
            }
        
           return 0
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
            if (pickerView==self.prgrmPicker) {
                return self.prgrm?[row].PROGRAMNAME
               
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
                pickerLabel?.text = self.prgrm?[row].PROGRAMNAME
               
            }
           
           return pickerLabel!
           
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
           
            if pickerView == self.prgrmPicker {
               self.prgrmTF.text = self.prgrm?[row].PROGRAMNAME
                
                loadingView.show(on: view)
                
                guard let gitUrll = URL(string: rsltAPI + (self.prgrm?[row].PROGRAMNAME ?? " ") .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else { loadingView.hide()
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
                    self.link = try decoder.decode([links].self, from: data)
                                
                    print("gitData:\(self.link)")
                                    
                    DispatchQueue.main.sync {
                        
                    if  self.link == nil {
                        
                        loadingView.hide()
                        //SKActivityIndicator.dismiss()
                        let alert = UIAlertController(title: "Message", message: "No Data Found..", preferredStyle: UIAlertController.Style.actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)

                                            
                    }else {
                        loadingView.hide()
                    //SKActivityIndicator.dismiss()
                        self.linkTbl.reloadData()
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
                    
    @objc func resign(){
        self.prgrmTF.resignFirstResponder()
        
    }
                
    @IBAction func homeAct(_ sender: UIBarButtonItem) {
        let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
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
