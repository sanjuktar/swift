//
//  Task.swift
//  TaskApp
//
//  Created by Sanjukta Roy on 6/25/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit


class Task : Equatable {
    
    enum Priority : String, Enum {
        typealias T = String
        
        case alert = "alert"
        case high = "high"
        case medium = "medium"
        case low = "low"
        
        static var defaut :Priority = .medium
        static var cases :[Priority] = [.alert, .high, .medium, .low]
        var value :T {return rawValue}
    }
    
    enum Status :String, Enum {
        typealias T = String
        
        case new = "new"
        case seen = "seen"
        case inProgress = "in progress"
        case done = "done"
        case forLater = "for later"
        case quit = "quit"
        
        static var defaut :Status = .new
        static var cases :[Status] = [.new, .seen, .inProgress, .done, .forLater, .quit]
        var value :String {return rawValue}
    }
    
    enum Frequency :String, Enum {
        typealias T = String
        
        case once = "once"
        case hourly = "hourly"
        case daily = "daily"
        case monthly = "monthly"
        case annually = "annually"
        case window = "time window"
        
        static var defaut :Frequency = .once
        static var cases :[Frequency] = [.once, .hourly, .daily, .monthly, .annually]
        var value :String {return rawValue}
    }
    
    var name :String
    var priority :Priority = Priority.defaut
    var status :Status = Status.defaut
    var frequency :Frequency = Frequency.defaut
    var when :Time = Anytime()
    var description :String = ""
    
    init(_ name :String, priority :Priority = .medium, status :Status = .new, frequency :Task.Frequency = .once, when :Time = Constants.anytime, description :String = "") {
        self.name = name
        self.priority = priority
        self.status = status
        self.frequency = frequency
        self.when = when
        self.description = description
    }
    
    static func ==(_ lhs: Task, _ rhs: Task) -> Bool {
        return lhs.name == rhs.name &&
            lhs.priority == rhs.priority &&
            lhs.status == rhs.status &&
            lhs.frequency == rhs.frequency &&
            //lhs.when.equals(rhs.when) &&
            lhs.description == rhs.description
    }
    
    func copy() -> Task {
     return Task(name, priority: priority, status: status, frequency: frequency, when: when, description: description)
     }
}
