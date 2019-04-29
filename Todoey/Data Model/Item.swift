//
//  Item.swift
//  Todoey
//
//  Created by Cooper Bossert on 4/23/19.
//  Copyright © 2019 Cooper Bossert. All rights reserved.
//

import Foundation

//Codable: conforms to encodable and decodable
class Item: Codable {
    var title : String = ""
    var done : Bool = false
}
