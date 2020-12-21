//
//  pract2VC.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 20/08/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import SpreadsheetView


struct pract2: Codable {
    let SUBJECTNAME: String?
    let Collcode: intmax_t?
    let TotalCount: intmax_t?
    let ENTERED_COUNT: intmax_t?
    let NotEntered_Count: intmax_t?
    let ENTERED_PERCENTAGE: Double?
    
    private enum CodingKeys: String, CodingKey {
        case SUBJECTNAME
        case Collcode
        case TotalCount
        case ENTERED_COUNT
        case NotEntered_Count
        case ENTERED_PERCENTAGE
    }
}


class pract2VC: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    
    let details = [  "TotalCount", "NotEntered_Count", "Entered_Count", "Entered_percentage %"]
    
    var practs : [pract2]?
    
    let dayColors = [UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1),
    UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
    UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
    UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1),
    UIColor(red: 0.400, green: 0.584, blue: 0.141, alpha: 1),
    UIColor(red: 0.835, green: 0.655, blue: 0.051, alpha: 1),
    UIColor(red: 0.153, green: 0.569, blue: 0.835, alpha: 1)]
    
    @IBOutlet weak var crseLbl: UILabel!
    @IBOutlet weak var pract2Sheet: SpreadsheetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated:true);
        
        let defaults = UserDefaults.standard
            self.crseLbl.text = "\(defaults.value(forKey: "clgSelct") ?? 0)"
            let pgrm = "\(defaults.value(forKey: "pgrmSelct") ?? "PG")"
            let sem = "\(defaults.value(forKey: "exmSelct") ?? "I SEM")"
            let crse = "\(defaults.value(forKey: "crseSelct") ?? "Chemistry")"
            let clg = "\(defaults.value(forKey: "clgSelct") ?? 0)"
            print("selct:\(pgrm)--\(sem)");
            
            guard let gitUrll = URL(string: pract2API + "\(pgrm )/\(sem )/\(crse)/\(clg)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else { loadingView.hide()
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
                self.practs = try decoder.decode([pract2].self, from: data)
                            
                print("gitData:\(self.practs)")
                                
                DispatchQueue.main.sync {
                    
                if  self.practs == nil {
                    
                    loadingView.hide()
                    //SKActivityIndicator.dismiss()
                    let alert = UIAlertController(title: "Message", message: "No Data Found..", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                                        
                }else {
                    loadingView.hide()
                //SKActivityIndicator.dismiss()
                    self.pract2Sheet.reloadData()
                }
                    
                }
                                
            } catch let err {
                loadingView.hide()
                //SKActivityIndicator.dismiss()
                print("Err", err)
                
                }
            }.resume()
            
            self.pract2Sheet.layer.borderWidth = 1
            self.pract2Sheet.layer.masksToBounds = true
            
            self.pract2Sheet.dataSource = self
            self.pract2Sheet.delegate = self

            //self.pract2Sheet.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

            self.pract2Sheet.intercellSpacing = CGSize(width: 4, height: 1)
            self.pract2Sheet.gridStyle = .none

            self.pract2Sheet.register(DateCell.self, forCellWithReuseIdentifier: String(describing: DateCell.self))
            self.pract2Sheet.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
            self.pract2Sheet.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
            self.pract2Sheet.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
            self.pract2Sheet.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
        }
        
        
        // MARK: DataSource

        func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
            if self.practs != nil {
                return 5
            }
                return 0
            
        }

        func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
            if self.practs != nil {
                return (self.practs?.count ?? 0)+1
            }
                
            return 0
        }

        func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
           if self.practs != nil {
                if case 0 = column {
                    return 155
                } else {
                    return 170
                }
            }
            return 0
            
        }

        func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
            
            if self.practs != nil {
                if case 0 = row {
                    return 32
                }  else {
                    return 60
                }
            }
            return 0
            
        }

        func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
          if self.practs != nil {
              return 1
          }
                return 0
            
        }

        func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
            if self.practs != nil {
                return 1
            }
                return 0
            
        }
        
        func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
            if case (1...6, 0) = (indexPath.column, indexPath.row) {
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTitleCell.self), for: indexPath) as! DayTitleCell
                cell.label.text = details[indexPath.column - 1]
                cell.label.textColor = dayColors[indexPath.column]
                return cell
                
            }else if case (0, 0) = (indexPath.column, indexPath.row) {
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeTitleCell.self), for: indexPath) as! TimeTitleCell
                cell.label.text = "SUBJECTNAME"
                cell.label.textAlignment = .center
                cell.label.backgroundColor = .groupTableViewBackground
                return cell
                
            }else if case (0, 1...(self.practs?.count ?? 0)) = (indexPath.column, indexPath.row) {
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
                
                cell.label.text = "\(self.practs?[indexPath.row-1].SUBJECTNAME ?? " ")"
                cell.label.textColor = dayColors[indexPath.column]
                cell.label.numberOfLines = 10
                cell.label.textAlignment = .center
                cell.label.backgroundColor = .groupTableViewBackground
                return cell
                
            }else if case (1, 1...(self.practs?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                
                
                cell.label.text = "\(self.practs?[indexPath.row-1].TotalCount ?? 0)"
                let color = dayColors[indexPath.column]
                cell.label.textColor = color
                cell.label.textAlignment = .center
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
                
                return cell
                
            }else if case (2, 1...(self.practs?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                
                
                cell.label.text = "\(self.practs?[indexPath.row-1].NotEntered_Count ?? 0)"
                let color = dayColors[indexPath.column]
                cell.label.textColor = color
                cell.label.textAlignment = .center
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
                
                return cell
                
            }else if case (3, 1...(self.practs?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                
                
                cell.label.text =  "\(self.practs?[indexPath.row-1].ENTERED_COUNT ?? 0)"
                let color = dayColors[indexPath.column]
                cell.label.textColor = color
                cell.label.textAlignment = .center
                cell.label.numberOfLines = 10;
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
                
                return cell
                
            }else if case (4, 1...(self.practs?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                
                
                cell.label.text =  "\(self.practs?[indexPath.row-1].ENTERED_PERCENTAGE ?? 0)%"
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
        
    @IBAction func backAct(_ sender: UIButton) {
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
