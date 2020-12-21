//
//  dashVC.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 23/07/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import RSLoadingView



struct pgrmms: Codable {
    let PROGRAMNAME: String?
    let PERCENTAGE: Double?
    
    private enum CodingKeys: String, CodingKey {
        case PROGRAMNAME
        case PERCENTAGE
    }
}

class dashVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var dashTbl: UITableView!
    
    var pgrmids : [pgrmms]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated:true);
        
        let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
                

        guard let gitUrl = URL(string: pgrmAPI ) else { return }
                    
        URLSession.shared.dataTask(with: gitUrl) { (data, response
                        , error) in
        
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
            self.pgrmids = try decoder.decode([pgrmms].self, from: data)
                        
            print("gitData:\(self.pgrmids)")
                            
            DispatchQueue.main.sync {
                
            if  self.pgrmids == nil {
                
                loadingView.hide()
                //SKActivityIndicator.dismiss()
                let alert = UIAlertController(title: "Message", message: "No Data Found..", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                                    
            }else {
                loadingView.hide()
            //SKActivityIndicator.dismiss()
                self.dashTbl.reloadData()
                
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
        
        if self.pgrmids != nil {
            return self.pgrmids?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rtrn : dashCell = tableView.dequeueReusableCell(withIdentifier: "course") as! dashCell
        
        
        rtrn.txtLbl.text = "  \(self.pgrmids?[indexPath.row].PROGRAMNAME ?? "ug")"
        rtrn.percLbl.text = "\(self.pgrmids?[indexPath.row].PERCENTAGE ?? 85)%"

        rtrn.txtLbl.layer.cornerRadius = 8.0
        rtrn.txtLbl.layer.masksToBounds = true
        rtrn.txtLbl.layer.borderWidth = 1.0
        rtrn.txtLbl.layer.borderColor = UIColor.black.cgColor
        
        
        
        return  rtrn
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let defaults = UserDefaults.standard
        defaults.setValue("\(self.pgrmids?[indexPath.row].PROGRAMNAME ?? "ug")", forKey: "pgrmSelct")
        
        
        let vc:subVW = self.storyboard?.instantiateViewController(withIdentifier: "subVW") as! subVW
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func menuAct(_ sender: UIBarButtonItem) {
        let vc:menuVC = self.storyboard?.instantiateViewController(withIdentifier: "menuVC") as! menuVC
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    
    
}
