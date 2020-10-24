//
//  ToDoListModel.swift
//  SkillboxLesson14
//
//  Created by Сергей Шопин on 24.10.2020.
//

import Foundation
import RealmSwift

let realm = try! Realm()
var toDoLists : Results<ToDoList>?

func addItem(nameItem: String) {
    try! realm.write {
        realm.add(ToDoList(value:["name":nameItem]))
    }
}

func removeItem(item toDoList: ToDoList) {
    try! realm.write {
        realm.delete(toDoList)
    }
}

func changeState(at index: Int) -> Bool {
    if let state = toDoLists?[index].isComplited {
        try! realm.write {
            toDoLists![index].isComplited = !state
        }
        return !state
    }
    return false
}

func loadData() {
    toDoLists = realm.objects(ToDoList.self)
}



