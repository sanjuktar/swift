//
//  TaskListTableViewController.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 6/25/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class TaskListTableViewController : UITableViewController {
    
    @IBAction func unwindToTaskList(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "saveTaskAndUnwindToTaskList":
            let vc = segue.source as! EditTaskViewController
            vc.commitChanges()
            switch (vc.attr?.mode as! EditTaskViewController.Mode) {
            case .add:
                addNewTask(vc.task)
            case EditTaskViewController.Mode.edit:
                updateSelectedTask(with: vc.task)
            }
        case "delTaskInEditModeAndUnwindToTaskList":
            deleteSelectedTask()
        case "delTaskInViewModeAndUnwindToTaskList":
            deleteSelectedTask()
        default:
            break
        }
    }
    
    var taskList :Tasklist?
    var tasklistMO :TasklistMO?
    static var persistentContainer = PersistentContainer(name: "TaskApp")
    var persistentContainer :PersistentContainer {
        return Task
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTaskList()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? taskList!.list.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task =  taskList?.get(at:indexPath.row)
        let cell : TaskTableCell = tableView.dequeueReusableCell(withIdentifier: "taskTableCell", for: indexPath) as! TaskTableCell
        cell.reset(withTask: task!)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "taskListToAddTaskSegue":
            let vc = segue.destination as! EditTaskViewController
            vc.attr = EditTaskViewController.Attributes(
                task: Task(""),
                mode: .add)
        case "taskListToTaskDetailsSegue":
            let vc = segue.destination as! TaskViewController
            vc.editAttr = EditTaskViewController.Attributes(
                task: task(atIndexPath: tableView.indexPathForSelectedRow!).copy(),
                mode: .edit)
        default: break
        }
    }
    
    func loadTaskList() {
        taskList = Tasklist("default", withNames: ["eat", "drink", "be merry"])
        let tasklistMO = TasklistMO(context: persistentContainer.viewContext)
        tasklistMO.copy(from :taskList!)        
    }
    
    func task(atIndexPath indexPath :IndexPath) -> Task {
        return (taskList?.get(at: indexPath.row))!
    }
    
    func updateSelectedTask(with newTask :Task) {
        var selected = tableView.indexPathForSelectedRow
        taskList?.set(at: (selected?.row)!, task: newTask)
        (tableView.cellForRow(at: selected!) as? TaskTableCell)?.reset(withTask: task(atIndexPath: selected!))
    }
    
    func addNewTask(_ newTask :Task) {
        taskList?.add(newTask)
        tableView.insertRows(at: [IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)], with: .automatic)
    }
    
    func deleteSelectedTask() {
        taskList?.remove(at: (tableView.indexPathForSelectedRow?.row)!)
        tableView.deleteRows(at: [tableView.indexPathForSelectedRow!], with: .automatic)
    }
}
