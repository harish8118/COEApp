//
//  award3VC.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 25/08/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import SpreadsheetView


struct award3: Codable {
    let code: intmax_t?
    
    private enum CodingKeys: String, CodingKey {
        case code
        
    }
}

class award3VC: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {

    @IBOutlet weak var sbjctLbl: UILabel!
    @IBOutlet weak var awrd3Sheet: SpreadsheetView!
    
    
    var awards : [award3]?
    
    let dayColors = [UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1),
    UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
    UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
    UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1),
    UIColor(red: 0.400, green: 0.584, blue: 0.141, alpha: 1),
    UIColor(red: 0.835, green: 0.655, blue: 0.051, alpha: 1),
    UIColor(red: 0.153, green: 0.569, blue: 0.835, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.navigationItem.setHidesBackButton(true, animated:true);
            
            let defaults = UserDefaults.standard
            self.sbjctLbl.text = "\(defaults.value(forKey: "subjctSelct") ?? "Chemistry")"
                let pgrm = "\(defaults.value(forKey: "pgrmSelct") ?? "PG")"
                let sem = "\(defaults.value(forKey: "exmSelct") ?? "I SEM")"
                let crse = "\(defaults.value(forKey: "crseSelct") ?? "Chemistry")"
                let sbj = "\(defaults.value(forKey: "subjctSelct") ?? "Chemistry")"
                let val = "\(defaults.value(forKey: "valSelct") ?? "Chemistry")"
                print("selct:\(pgrm)--\(sem)");
                
                guard let gitUrll = URL(string: award3API + "\(pgrm )/\(sem )/\(crse)/\(sbj)/\(val)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else { loadingView.hide()
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
                    self.awards = try decoder.decode([award3].self, from: data)
                                
                    print("gitData:\(self.awards)")
                                    
                    DispatchQueue.main.sync {
                        
                    if  self.awards == nil {
                        
                        loadingView.hide()
                        //SKActivityIndicator.dismiss()
                        let alert = UIAlertController(title: "Message", message: "No Data Found..", preferredStyle: UIAlertController.Style.actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)

                                            
                    }else {
                        loadingView.hide()
                    //SKActivityIndicator.dismiss()
                        self.awrd3Sheet.reloadData()
                    }
                        
                    }
                                    
                } catch let err {
                    loadingView.hide()
                    //SKActivityIndicator.dismiss()
                    print("Err", err)
                    
                    }
                }.resume()
                
                self.awrd3Sheet.layer.borderWidth = 1
                self.awrd3Sheet.layer.masksToBounds = true
                
                self.awrd3Sheet.dataSource = self
                self.awrd3Sheet.delegate = self

                //self.awrd3Sheet.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

                self.awrd3Sheet.intercellSpacing = CGSize(width: 4, height: 1)
                self.awrd3Sheet.gridStyle = .none

                self.awrd3Sheet.register(DateCell.self, forCellWithReuseIdentifier: String(describing: DateCell.self))
                self.awrd3Sheet.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
                self.awrd3Sheet.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
                self.awrd3Sheet.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
                self.awrd3Sheet.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
            }
            
            
            // MARK: DataSource

            func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
                if self.awards != nil {
                    return 1
                }
                    return 0
                
            }

            func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
                if self.awards != nil {
                    return (self.awards?.count ?? 0)+1
                }
                    
                return 0
            }

            func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
               if self.awards != nil {
                    if case 0 = column {
                        return 150
                    } else {
                        return 170
                    }
                }
                return 0
                
            }

            func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
                
                if self.awards != nil {
                    if case 0 = row {
                        return 32
                    }  else {
                        return 60
                    }
                }
                return 0
                
            }

            func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
              if self.awards != nil {
                  return 1
              }
                    return 0
                
            }

            func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
                if self.awards != nil {
                    return 1
                }
                    return 0
                
            }
            
            func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
                 if case (0, 0) = (indexPath.column, indexPath.row) {
                    let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeTitleCell.self), for: indexPath) as! TimeTitleCell
                    cell.label.text = "CODE"
                    cell.label.textAlignment = .center
                    cell.label.backgroundColor = .groupTableViewBackground
                    return cell
                    
                }else if case (0, 1...(self.awards?.count ?? 0)) = (indexPath.column, indexPath.row) {
                    let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
                    
                    cell.label.text = "\(self.awards?[indexPath.row-1].code ?? 0)"
                    cell.label.textColor = dayColors[indexPath.column]
                    cell.label.textAlignment = .center
                    cell.label.numberOfLines = 10
                    cell.label.backgroundColor = .groupTableViewBackground
                    return cell
                    
                }
                
                return nil
            }
            
        @IBAction func backAvt(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
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
