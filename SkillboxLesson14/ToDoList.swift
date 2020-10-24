//
//  ToDoList.swift
//  SkillboxLesson14
//
//  Created by Сергей Шопин on 24.10.2020.
//

import Foundation
import RealmSwift

@objcMembers class ToDoList: Object {
    dynamic var name: String = ""
    dynamic var isComplited : Bool = false
}

