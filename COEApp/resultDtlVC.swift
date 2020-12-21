//
//  resultDtlVC.swift
//  COEApp
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 27/08/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import SpreadsheetView


struct reslt: Codable {
    let YEARNAME: String?
    let COURSE: String?
    let COURSENAME: String?
    let PROCESSED: String?
    let DECLARED: String?
    
    private enum CodingKeys: String, CodingKey {
        case YEARNAME
        case COURSE
        case COURSENAME
        case PROCESSED
        case DECLARED
    }
}

class resultDtlVC: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {

    @IBOutlet weak var rsltSheet: SpreadsheetView!
    
    let details = [ "COURSE", "COURSENAME", "PROCESSED",  "DECLARED "]
    
    var rslts : [reslt]?
    
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
            
            let link = "\(defaults.value(forKey: "rsltLink") ?? "PG")"
            print("link:\(link)")
            
            
            guard let gitUrll = URL(string:rsltsAPI + "\(link)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) else { loadingView.hide()
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
                self.rslts = try decoder.decode([reslt].self, from: data)
                            
                print("gitData:\(self.rslts)")
                                
                DispatchQueue.main.sync {
                    
                if  self.rslts == nil {
                    
                    loadingView.hide()
                    //SKActivityIndicator.dismiss()
                    let alert = UIAlertController(title: "Message", message: "No Data Found..", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                                        
                }else {
                    loadingView.hide()
                //SKActivityIndicator.dismiss()
                    self.rsltSheet.reloadData()
                }
                    
                }
                                
            } catch let err {
                loadingView.hide()
                //SKActivityIndicator.dismiss()
                print("Err", err)
                
                }
            }.resume()
            
            self.rsltSheet.layer.borderWidth = 1
            self.rsltSheet.layer.masksToBounds = true
            
            self.rsltSheet.dataSource = self
            self.rsltSheet.delegate = self

            //self.rsltSheet.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

            self.rsltSheet.intercellSpacing = CGSize(width: 4, height: 1)
            self.rsltSheet.gridStyle = .none

            self.rsltSheet.register(DateCell.self, forCellWithReuseIdentifier: String(describing: DateCell.self))
            self.rsltSheet.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
            self.rsltSheet.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
            self.rsltSheet.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
            self.rsltSheet.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
        }
        
        
        // MARK: DataSource

        func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
            if self.rslts != nil {
                return 5
            }
                return 0
            
        }

        func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
            if self.rslts != nil {
                return (self.rslts?.count ?? 0)+1
            }
                
            return 0
        }

        func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
           if self.rslts != nil {
                if case 0 = column {
                    return 155
                } else {
                    return 170
                }
            }
            return 0
            
        }

        func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
            
            if self.rslts != nil {
                if case 0 = row {
                    return 32
                }  else {
                    return 60
                }
            }
            return 0
            
        }

        func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
          if self.rslts != nil {
              return 1
          }
                return 0
            
        }

        func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
            if self.rslts != nil {
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
                cell.label.text = "YEARNAME"
                cell.label.textAlignment = .center
                cell.label.backgroundColor = .groupTableViewBackground
                return cell
                
            }else if case (0, 1...(self.rslts?.count ?? 0)) = (indexPath.column, indexPath.row) {
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
                
                cell.label.text = "\(self.rslts?[indexPath.row-1].YEARNAME ?? " ")"
                cell.label.textColor = dayColors[indexPath.column]
                cell.label.textAlignment = .center
                cell.label.numberOfLines = 10
                cell.label.backgroundColor = .groupTableViewBackground
                return cell
                
            }else if case (1, 1...(self.rslts?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                
                
                cell.label.text = "\(self.rslts?[indexPath.row-1].COURSE ?? " ")"
                let color = dayColors[indexPath.column]
                cell.label.textColor = color
                cell.label.textAlignment = .center
                cell.label.numberOfLines = 10
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
                
                return cell
                
            }else if case (2, 1...(self.rslts?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                
                
                cell.label.text = "\(self.rslts?[indexPath.row-1].COURSENAME ?? " ")"
                let color = dayColors[indexPath.column]
                cell.label.textColor = color
                cell.label.textAlignment = .center
                cell.label.numberOfLines = 10
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
                
                return cell
                
            }else if case (3, 1...(self.rslts?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                
                
                cell.label.text =  "\(self.rslts?[indexPath.row-1].PROCESSED ?? " ")"
                let color = dayColors[indexPath.column]
                cell.label.textColor = color
                cell.label.textAlignment = .center
                cell.label.numberOfLines = 10;
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
                
                return cell
                
            }else if case (4, 1...(self.rslts?.count ?? 0)+1) = (indexPath.column, indexPath.row) {
                
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
                
                
                cell.label.text =  "\(self.rslts?[indexPath.row-1].DECLARED ?? " ")"
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
