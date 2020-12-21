//
//  codSlpVC.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 21/08/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import SpreadsheetView


struct cdSlp: Codable {
    let SUBJECTNAME: String?
    let SUBCOURSE: String?
    let ENTERED_COUNT: intmax_t?
    let NOT_ENTERED: intmax_t?
    let ENTERED_PERCENTAGE: Double?
    
    private enum CodingKeys: String, CodingKey {
        case SUBJECTNAME
        case SUBCOURSE
        case ENTERED_COUNT
        case NOT_ENTERED
        case ENTERED_PERCENTAGE
    }
}


class codSlpVC: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {

    
    let details = [   "Entered_Count", "NotEntered_Count",  "Entered_percentage %"]
    
    var cdslps : [cdSlp]?
    
    let dayColors = [UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1),
    UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
    UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
    UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1),
    UIColor(red: 0.400, green: 0.584, blue: 0.141, alpha: 1),
    UIColor(red: 0.835, green: 0.655, blue: 0.051, alpha: 1),
    UIColor(red: 0.153, green: 0.569, blue: 0.835, alpha: 1)]
    
    @IBOutlet weak var crseLbl: UILabel!
    @IBOutlet weak var cdSlpSheet: SpreadsheetView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated:true);
        
        let defaults = UserDefaults.standard
            self.crseLbl.text = "\(defaults.value(forKey: "crseSelct") ?? "Chemistry")"
            let pgrm = "\(defaults.value(forKey: "pgrmSelct") ?? "PG")"
            let sem = "\(defaults.value(forKey: "exmSelct") ?? "I SEM")"
            let crse = "\(defaults.value(forKey: "crseSelct") ?? "Chemistry")"
            print("selct:\(pgrm)--\(sem)");
            
            guard let gitUrll = URL(string: codeSlpAPI + "\(pgrm )/\(sem )/\(crse)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else { loadingView.hide()
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
                self.cdslps = try decoder.decode([cdSlp].self, from: data)
                            
                print("gitData:\(self.cdslps)")
                                
                DispatchQueue.main.sync {
                    
                if  self.cdslps == nil {
                    
                    loadingView.hide()
                    //SKActivityIndicator.dismiss()
                    let alert = UIAlertController(title: "Message", message: "No Data Found..", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                                        
                }else {
                    loadingView.hide()
                //SKActivityIndicator.dismiss()
                    self.cdSlpSheet.reloadData()
                }
                    
                }
                                
            } catch let err {
                loadingView.hide()
                //SKActivityIndicator.dismiss()
                print("Err", err)
                
                }
            }.resume()
            
            self.cdSlpSheet.layer.borderWidth = 1
            self.cdSlpSheet.layer.masksToBounds = true
            
            self.cdSlpSheet.dataSource = self
            self.cdSlpSheet.delegate = self

            //self.cdSlpSheet.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

            self.cdSlpSheet.intercellSpacing = CGSize(width: 4, height: 1)
            self.cdSlpSheet.gridStyle = .none

            self.cdSlpSheet.register(DateCell.self, forCellWithReuseIdentifier: String(describing: DateCell.self))
            self.cdSlpSheet.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
            self.cdSlpSheet.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
            self.cdSlpSheet.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
            self.cdSlpSheet.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
        }
        
        
        // MARK: DataSource

        func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
            if self.cdslps != nil {
                return 4
            }
                return 0
            
        }

        func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
            if self.cdslps != nil {
                return (self.cdslps?.count ?? 0)+1
            }
                
            return 0
        }

        func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
           if self.cdslps != nil {
                if case 0 = column {
                    return 155
                } else {
                    return 170
                }
            }
            return 0
            
        }

        func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
            
            if self.cdslps != nil {
                if case 0 = row {
                    return 32
                }  else {
                    return 60
                }
            }
            return 0
            
        }

        func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
          if self.cdslps != nil {
              return 1
          }
                return 0
            
        }

        func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
            if self.cdslps != nil {
                return 1
            }
                return 0
            
        }
        
        func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
            if case (1...4, 0) = (indexPath.column, indexPath.row) {
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
                
            }else if case (0, 1...(self.cdslps?.count ?? 0)) = (indexPath.column, indexPath.row) {
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
                
                cell.label.text = "\(self.cdslps?[indexPath.row-1].SUBJECTNAME ?? " ")"
                cell.label.textColor = dayColors[indexPath.column]
                cell.label.textAlignment = .center
                cell.label.numberOfLines = 10
                cell.label.backgroundColor = .groupTableViewBackground
                return cell
                
            }else if case (1, 1...(self.cdslps?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                
                
                cell.label.text = "\(self.cdslps?[indexPath.row-1].ENTERED_COUNT ?? 0)"
                let color = dayColors[indexPath.column]
                cell.label.textColor = color
                cell.label.textAlignment = .center
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
                
                return cell
                
            }else if case (2, 1...(self.cdslps?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                
                
                cell.label.text = "\(self.cdslps?[indexPath.row-1].NOT_ENTERED ?? 0)"
                let color = dayColors[indexPath.column]
                cell.label.textColor = color
                cell.label.textAlignment = .center
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
                
                return cell
                
            }else if case (3, 1...(self.cdslps?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                
                
                cell.label.text =  "\(self.cdslps?[indexPath.row-1].ENTERED_PERCENTAGE ?? 0)%"
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
            
            if case (0, 1...(self.cdslps?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                let defaults = UserDefaults.standard
                defaults.setValue("\(self.cdslps?[indexPath.row-1].SUBJECTNAME ?? " ")", forKey: "subjctSelct")
                
                let vc:codSlp2VC = self.storyboard?.instantiateViewController(withIdentifier: "codSlp2VC") as! codSlp2VC
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
