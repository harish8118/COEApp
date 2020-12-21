//
//  loginVC.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 23/07/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import RSLoadingView

class loginVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var backVW: UIView!
    @IBOutlet weak var useridTF: UITextField!
    @IBOutlet weak var pswrdTF: UITextField!
    @IBOutlet weak var useridErr: UILabel!
    @IBOutlet weak var pswrdErr: UILabel!
    @IBOutlet weak var submitBttn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backVW.layer.cornerRadius = 15.0
        self.backVW.layer.shadowRadius  = 1.5
        self.backVW.layer.shadowColor = UIColor.init(red: 67.0/255.0, green: 67.0/255.0, blue: 67.0/255.0, alpha: 1.0).cgColor
           
        self.backVW.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        self.backVW.layer.shadowOpacity = 0.9
        self.backVW.layer.masksToBounds = true;
        
        self.useridTF.layer.cornerRadius = 7.0
        self.useridTF.layer.borderWidth = 1.0
        self.useridTF.layer.masksToBounds = true;
        
        self.pswrdTF.layer.cornerRadius = 7.0
        self.pswrdTF.layer.borderWidth = 1.0
        self.pswrdTF.layer.masksToBounds = true;
        
        self.submitBttn.layer.cornerRadius = 7.0
        self.submitBttn.layer.masksToBounds = true;
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.useridTF.inputAccessoryView = toolBar5
        self.pswrdTF.inputAccessoryView = toolBar5
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let acceptedInput:NSCharacterSet = NSCharacterSet.init(charactersIn: "0123456789")

          if textField==self.useridTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.useridTF.text?.count ?? 0<6) || string == "" {
                
                return true
            }else{
                return false
            }
        }

        
        return true
    }

    @IBAction func submitAct(_ sender: UIButton) {
        if self.useridTF.text?.count==0 {
            self.useridErr.isHidden = false
            
        }else if self.pswrdTF.text?.count==0 {
            self.pswrdErr.isHidden = false
            
        }else if self.useridTF.text?.count ?? 0>0 && self.pswrdTF.text?.count ?? 0>0 {
            self.useridErr.isHidden = true
            self.pswrdErr.isHidden = true
            
            let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
            loadingView.shouldTapToDismiss = false
            loadingView.show(on: view)
            
            let defaults = UserDefaults.standard
            guard let gitUrl = URL(string: loginAPI +  "\(self.useridTF.text!)/\(self.pswrdTF.text!)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else { return }
                        
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                            , error) in
                            
            guard let data = data else { return }
            do {
                                
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: JSONSerialization.ReadingOptions.allowFragments) as! intmax_t
                print("res:\(jsonResponse)")
                
                DispatchQueue.main.sync {
                    
                if jsonResponse == 1 {
                    loadingView.hide()
                    //SKActivityIndicator.dismiss()

                    defaults.setValue("1", forKey: "Status")
                    let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
                    self.navigationController?.isNavigationBarHidden = false
                    self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                    self.navigationController?.pushViewController(vc, animated: true)
                    // handle json...
                    
                }else {
                    loadingView.hide()
                    //SKActivityIndicator.dismiss()
                    let alert = UIAlertController(title: "Failed", message: "Something went wrong.Try again.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
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
        self.useridTF.resignFirstResponder()
        self.pswrdTF.resignFirstResponder()
    }

}
