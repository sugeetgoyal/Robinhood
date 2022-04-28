//
//  ViewController.swift
//  CellVisibilityRecorder
//
//  Created by Sugeet Goyal on 22/04/22.
//

import UIKit

class CellModel {
    var recordedTime: Float = 0.0
    var isPaused: Bool = false
    var index: Int? = 0
}

class ViewController: UITableViewController {
    var cellModels = [CellModel]()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    
    func setUpData() {
        for i in 0..<50 {
            let model = CellModel()
            model.index = i
            cellModels.append(model)
        }
        
        start()
        
        self.tableView.setNeedsLayout()
        tableView.reloadData()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}

extension ViewController {
    func start() {
        timer = Timer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(self.timerTikTik), userInfo: nil, repeats: true)

        if timer != nil {
            RunLoop.current.add(timer!, forMode: .default)
        }
    }
        
    @objc func timerTikTik() {
        for indexPath in tableView.indexPathsForVisibleRows ?? [IndexPath]() {
            print(indexPath.row)
            
            if !cellModels[indexPath.row].isPaused {
                cellModels[indexPath.row].recordedTime += 0.1
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                }
            }
        }
   }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.tag = indexPath.row
        cell?.textLabel?.text = String(format: "%.1f", cellModels[indexPath.row].recordedTime)
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellModels[indexPath.row].isPaused = !cellModels[indexPath.row].isPaused
    }
}

