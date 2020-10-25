//
//  CoreDataModel.swift
//  SkillboxLesson14
//
//  Created by Сергей Шопин on 25.10.2020.
//

import Foundation
import CoreData
import UIKit

var toDoItemsCoreData : [NSManagedObject] = []

func changeStateCoreData(at index: Int) -> Bool {
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
    guard let state = toDoItemsCoreData[index].value(forKey: "isComplited") as? Bool else {return false}

    toDoItemsCoreData[index].setValue(!state, forKey: "isComplited")
    appDelegate.saveContext()
    return !state
}

func addItemCoreData(nameItem: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "ToDoItemCore", in: managedContext)!
    let item = NSManagedObject(entity: entity, insertInto: managedContext)
    item.setValue(nameItem, forKey: "name")
    item.setValue(false, forKey: "isComplited")
    appDelegate.saveContext()
    toDoItemsCoreData.append(item)
}

func removeItemCoreData(at index: Int) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    managedContext.delete(toDoItemsCoreData[index])
    appDelegate.saveContext()
    toDoItemsCoreData.remove(at: index)
}

func loadCoreData() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDoItemCore")
    do {
        toDoItemsCoreData = try managedContext.fetch(fetchRequest)
    } catch let err as NSError {
        print("Error to fetch", err)
    }
}

