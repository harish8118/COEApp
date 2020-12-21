//
//  intrnlVC.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 21/08/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import SpreadsheetView


struct intrnl: Codable {
    let COLLCODE: intmax_t?
    let TOTAL_COUNT: intmax_t?
    let ENTERED_COUNT: intmax_t?
    let NOTENTERED_COUNT: intmax_t?
    let ENTERED_PERC: Double?
    
    private enum CodingKeys: String, CodingKey {
        case COLLCODE
        case TOTAL_COUNT
        case ENTERED_COUNT
        case NOTENTERED_COUNT
        case ENTERED_PERC
    }
}

class intrnlVC: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {

    @IBOutlet weak var crseLbl: UILabel!
    @IBOutlet weak var intrnlSheet: SpreadsheetView!
    
    
    let details = [   "TOTAL_COUNT", "Entered_Count", "NotEntered_Count",  "Entered_percentage %"]
    
    var intrnls : [intrnl]?
    
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
                self.crseLbl.text = "\(defaults.value(forKey: "crseSelct") ?? "Chemistry")"
                let pgrm = "\(defaults.value(forKey: "pgrmSelct") ?? "PG")"
                let sem = "\(defaults.value(forKey: "exmSelct") ?? "I SEM")"
                let crse = "\(defaults.value(forKey: "crseSelct") ?? "Chemistry")"
                print("selct:\(pgrm)--\(sem)");
                
                guard let gitUrll = URL(string: intrnlAPI + "\(pgrm )/\(sem )/\(crse)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else { loadingView.hide()
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
                    self.intrnls = try decoder.decode([intrnl].self, from: data)
                                
                    print("gitData:\(self.intrnls)")
                                    
                    DispatchQueue.main.sync {
                        
                    if  self.intrnls == nil {
                        
                        loadingView.hide()
                        //SKActivityIndicator.dismiss()
                        let alert = UIAlertController(title: "Message", message: "No Data Found..", preferredStyle: UIAlertController.Style.actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)

                                            
                    }else {
                        loadingView.hide()
                    //SKActivityIndicator.dismiss()
                        self.intrnlSheet.reloadData()
                    }
                        
                    }
                                    
                } catch let err {
                    loadingView.hide()
                    //SKActivityIndicator.dismiss()
                    print("Err", err)
                    
                    }
                }.resume()
                
                self.intrnlSheet.layer.borderWidth = 1
                self.intrnlSheet.layer.masksToBounds = true
                
                self.intrnlSheet.dataSource = self
                self.intrnlSheet.delegate = self

                //self.intrnlSheet.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

                self.intrnlSheet.intercellSpacing = CGSize(width: 4, height: 1)
                self.intrnlSheet.gridStyle = .none

                self.intrnlSheet.register(DateCell.self, forCellWithReuseIdentifier: String(describing: DateCell.self))
                self.intrnlSheet.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
                self.intrnlSheet.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
                self.intrnlSheet.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
                self.intrnlSheet.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
            }
            
            
            // MARK: DataSource

            func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
                if self.intrnls != nil {
                    return 5
                }
                    return 0
                
            }

            func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
                if self.intrnls != nil {
                    return (self.intrnls?.count ?? 0)+1
                }
                    
                return 0
            }

            func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
               if self.intrnls != nil {
                    if case 0 = column {
                        return 155
                    } else {
                        return 170
                    }
                }
                return 0
                
            }

            func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
                
                if self.intrnls != nil {
                    if case 0 = row {
                        return 32
                    }  else {
                        return 60
                    }
                }
                return 0
                
            }

            func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
              if self.intrnls != nil {
                  return 1
              }
                    return 0
                
            }

            func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
                if self.intrnls != nil {
                    return 1
                }
                    return 0
                
            }
            
            func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
                if case (1...5, 0) = (indexPath.column, indexPath.row) {
                    let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTitleCell.self), for: indexPath) as! DayTitleCell
                    cell.label.text = details[indexPath.column - 1]
                    cell.label.textColor = dayColors[indexPath.column]
                    return cell
                    
                }else if case (0, 0) = (indexPath.column, indexPath.row) {
                    let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeTitleCell.self), for: indexPath) as! TimeTitleCell
                    cell.label.text = "COLLCODE"
                    cell.label.textAlignment = .center
                    cell.label.backgroundColor = .groupTableViewBackground
                    return cell
                    
                }else if case (0, 1...(self.intrnls?.count ?? 0)) = (indexPath.column, indexPath.row) {
                    let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
                    
                    cell.label.text = "\(self.intrnls?[indexPath.row-1].COLLCODE ?? 0)"
                    cell.label.textColor = dayColors[indexPath.column]
                    cell.label.textAlignment = .center
                    cell.label.backgroundColor = .groupTableViewBackground
                    return cell
                    
                }else if case (1, 1...(self.intrnls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                    
                    let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                    
                    
                    cell.label.text = "\(self.intrnls?[indexPath.row-1].TOTAL_COUNT ?? 0)"
                    let color = dayColors[indexPath.column]
                    cell.label.textColor = color
                    cell.label.textAlignment = .center
                    cell.color = color.withAlphaComponent(0.2)
                    cell.borders.top = .solid(width: 2, color: color)
                    cell.borders.bottom = .solid(width: 2, color: color)
                    
                    return cell
                    
                }else if case (2, 1...(self.intrnls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                    
                    let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                    
                    
                    cell.label.text = "\(self.intrnls?[indexPath.row-1].ENTERED_COUNT ?? 0)"
                    let color = dayColors[indexPath.column]
                    cell.label.textColor = color
                    cell.label.textAlignment = .center
                    cell.color = color.withAlphaComponent(0.2)
                    cell.borders.top = .solid(width: 2, color: color)
                    cell.borders.bottom = .solid(width: 2, color: color)
                    
                    return cell
                    
                }else if case (3, 1...(self.intrnls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                    
                    let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                    
                    
                    cell.label.text =  "\(self.intrnls?[indexPath.row-1].NOTENTERED_COUNT ?? 0)"
                    let color = dayColors[indexPath.column]
                    cell.label.textColor = color
                    cell.label.textAlignment = .center
                    cell.label.numberOfLines = 10;
                    cell.color = color.withAlphaComponent(0.2)
                    cell.borders.top = .solid(width: 2, color: color)
                    cell.borders.bottom = .solid(width: 2, color: color)
                    
                    return cell
                    
                }else if case (4, 1...(self.intrnls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                    
                    let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                    
                    
                    cell.label.text =  "\(self.intrnls?[indexPath.row-1].ENTERED_PERC ?? 0)%"
                    let color = dayColors[indexPath.column]
                    cell.label.textColor = color
                    cell.label.textAlignment = .center
                    cell.label.numberOfLines = 10;
                    cell.color = color.withAlphaComponent(0.2)
                    cell.borders.top = .solid(width: 2, color: color)
                    cell.borders.bottom = .solid(width: 2, color: color)
                    
                    return cell
                    
                }
                
                return nil
            }
            
            func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
                
                if case (0, 1...(self.intrnls?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                    let defaults = UserDefaults.standard
                    defaults.setValue("\(self.intrnls?[indexPath.row-1].COLLCODE ?? 0)", forKey: "clgSelct")
                    
                    let vc:intrnl2VC = self.storyboard?.instantiateViewController(withIdentifier: "intrnl2VC") as! intrnl2VC
                    self.navigationController?.isNavigationBarHidden = false
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
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
