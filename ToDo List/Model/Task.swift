//
//  Task.swift
//  ToDo List
//
//  Created by Mohamed osama on 21/07/2021.
//

import Foundation


enum Paiority: Int{
    case high
    case medium
    case low
}

struct Task{
    let title: String
    let paiority: Paiority
}
