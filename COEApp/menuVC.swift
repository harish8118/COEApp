//
//  menuVC.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 24/07/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class menuVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let menuDetails = [ "📋 Results", "🧾 Memos", "🔗 Result Link", "📊 Statistics", "📚 Stationary"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rtrn : dashCell = tableView.dequeueReusableCell(withIdentifier: "menus") as! dashCell
        print("\(self.menuDetails[indexPath.row])")
        
        rtrn.txtLbl.text = menuDetails[indexPath.row]
        

//        rtrn.txtLbl.layer.cornerRadius = 8.0
//        rtrn.txtLbl.layer.masksToBounds = true
//        rtrn.txtLbl.layer.borderWidth = 1.0
//        rtrn.txtLbl.layer.borderColor = UIColor.black.cgColor
        
        
        
        return  rtrn
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        

        if indexPath.row == 0 {
            let vc:rsltVC = self.storyboard?.instantiateViewController(withIdentifier: "rsltVC") as! rsltVC
            self.navigationController?.isNavigationBarHidden = false
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 1 {
            let vc:memoVC = self.storyboard?.instantiateViewController(withIdentifier: "memoVC") as! memoVC
            self.navigationController?.isNavigationBarHidden = false
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 2 {
            let vc:rsltPgrmVC = self.storyboard?.instantiateViewController(withIdentifier: "rsltPgrmVC") as! rsltPgrmVC
            self.navigationController?.isNavigationBarHidden = false
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    

}
