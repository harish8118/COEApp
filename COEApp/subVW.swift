//
//  subVW.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 23/07/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import RSLoadingView


struct exmns: Codable {
    let PROGRAMNAME: String?
    let EXAMINATION: String?
    let PERCENTAGE: Double?
    
    private enum CodingKeys: String, CodingKey {
        case PROGRAMNAME
        case EXAMINATION
        case PERCENTAGE
    }
}


class subVW: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var exmTbl: UITableView!
    @IBOutlet weak var prgrmLbl: UILabel!
    
    var exmnaIds : [exmns]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        self.prgrmLbl.text = "\(defaults.value(forKey: "pgrmSelct") ?? "I SEM")"
        
        let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
                
        let pgrm = defaults.value(forKey: "pgrmSelct")
        guard let gitUrl = URL(string: exmnsAPI + "\(pgrm ?? "PG")".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else { return }
        print("url:\(gitUrl)")
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
            self.exmnaIds = try decoder.decode([exmns].self, from: data)
                        
            print("gitData:\(self.exmnaIds)")
                            
            DispatchQueue.main.sync {
                
            if  self.exmnaIds == nil {
                
                loadingView.hide()
                //SKActivityIndicator.dismiss()
                let alert = UIAlertController(title: "Message", message: "No Data Found..", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                                    
            }else {
                loadingView.hide()
            //SKActivityIndicator.dismiss()
                self.exmTbl.reloadData()
                
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
        if self.exmnaIds != nil {
            return self.exmnaIds?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rtrn : dashCell = tableView.dequeueReusableCell(withIdentifier: "subCourse") as! dashCell
        
        
        rtrn.txtLbl.text = "  \(self.exmnaIds?[indexPath.row].EXAMINATION ?? "ug")"
        rtrn.percLbl.text = "\(self.exmnaIds?[indexPath.row].PERCENTAGE ?? 85)%"
        

        rtrn.txtLbl.layer.cornerRadius = 8.0
        rtrn.txtLbl.layer.masksToBounds = true
        rtrn.txtLbl.layer.borderWidth = 1.0
        rtrn.txtLbl.layer.borderColor = UIColor.black.cgColor
        
        
        
        return  rtrn
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let defaults = UserDefaults.standard
        defaults.setValue("\(self.exmnaIds?[indexPath.row].EXAMINATION ?? "I SEM")", forKey: "exmSelct")
        
        let vc:detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as! detailVC
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
            return 60
        
        
    }

    @IBAction func homeAct(_ sender: UIBarButtonItem) {
        let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
