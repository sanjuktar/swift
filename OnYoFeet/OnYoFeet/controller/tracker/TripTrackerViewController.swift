//
//  TripTrackerViewController.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 10/24/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import UIKit

class TripTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBAction func startStopButtonPressed(_ sender: Any) {
        toggleStartStop()
    }
    
    static var outputCategory = "Trip Tracker"
    var tracker: TripTracker?
    var trip: Trip?
    var target: TripTemplate?
    var output: Output?
    var log: Log?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        useStartButton()
        trip = Trip("Unnamed")
        output = MessageWindow(self)
        log = Log(TripTrackerViewController.outputCategory)
        tracker = TripTracker(trip!, output: output!, log: log!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TripDataItem.cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripTrackerTableCell")
        let item = TripDataItem.cases[indexPath.row]
        cell?.textLabel?.text = item.rawValue
        cell?.detailTextLabel?.text = item.dataFromTemplate ? item.data(from: target!) : item.data(from: trip!)
        return cell!
    }
}

extension TripTrackerViewController {
    func toggleStartStop() {
        if (trip?.inProgress)! {
            tracker?.start()
            useStopButton()
        }
        else {
            tracker?.stop()
            useStartButton()
        }
    }
    
    func useStartButton() {
        startStopButton.backgroundColor = UIColor(displayP3Red: 0, green: 0.9, blue: 0, alpha: 1)
        startStopButton.setTitle("START", for: .normal)
    }
    
    func useStopButton() {
        startStopButton.backgroundColor = UIColor(displayP3Red: 1, green: 0.3, blue: 0.3, alpha: 1)
        startStopButton.setTitle("STOP", for: .normal)
    }
    
    func updateTrackerView() {
        tableView.reloadData()
    }
}
