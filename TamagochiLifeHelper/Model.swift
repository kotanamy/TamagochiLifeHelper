//
//  Model.swift
//  TamagochiLifeHelper
//
//  Created by Ярослав Котов on 27.03.2022.
//

import Foundation
import UserNotifications
import UIKit

// Массив словарей
var ToDoItems: [[String: Any]] {
    set {
        UserDefaults.standard.set(newValue, forKey: "ToDoDataKey")
        UserDefaults.standard.synchronize()
    }
    get {
        if let array = UserDefaults.standard.array(forKey: "ToDoDataKey") as? [[String: Any]] {
            return array
        } else {
            return []
        }
    }
}

func addItem(nameItem: String, isCompleted: Bool = false){
    ToDoItems.append(["Name": nameItem, "isCompleted": isCompleted])
    setBadge()
}

func removeItem(at index: Int){
    ToDoItems.remove(at: index)
    setBadge()
}

func moveItem(fromIndex: Int, toIndex: Int){
    let from = ToDoItems[fromIndex]
    ToDoItems.remove(at: fromIndex)
    ToDoItems.insert(from, at: toIndex)
}

func changeState(at item: Int) -> Bool {
    ToDoItems[item]["isCompleted"] = !(ToDoItems[item]["isCompleted"] as! Bool)
    
    setBadge()
    
    return ToDoItems[item]["isCompleted"] as! Bool
}

func requestForNotification(){
    UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { isEnabled, error in
        if isEnabled {
            print("Согласие получено")
        } else {
            print("Согласие НЕ получено")
        }
    }
}

func setBadge(){
    var totalBadgeNumber = 0
    for item in ToDoItems {
        if (item["isCompleted"] as? Bool == false) {
            totalBadgeNumber = totalBadgeNumber + 1
        }
    }
    
    UIApplication.shared.applicationIconBadgeNumber = totalBadgeNumber
}
