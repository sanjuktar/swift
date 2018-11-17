//
//  Plant.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class Plant: Codable, Hashable {
    enum NameType: String, Codable {
        case common = "Common Name"
        case scientific = "Scientific Name"
        case nickname = "Nickname"
        
        static var cases: [NameType] = [.nickname, .common, .scientific]

        func validName(_ name: String?) -> Bool {
            return name != nil && !name!.isEmpty
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case names
        case imageData
    }
    
    var id: String
    var names: [NameType:String]
    var image: UIImage?
    var name: String {
        let type = (PlantsManager.current?.preferedNameType)!
        var str: String? = names[type]
        if type.validName(str) {
            return str!
        }
        for type in Plant.NameType.cases {
            str = names[type]
            if type.validName(str) {
                return str!
            }
        }
        return ""
    }
    var hashValue: Int {
        return id.hashValue
    }    
    var imageData: Data? {
        return (image == nil ? nil : UIImageJPEGRepresentation(image!, 0.5))
    }
    
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        return lhs.id == rhs.id &&
               lhs.names == rhs.names &&
               lhs.imageData == rhs.imageData
    }
    
    required init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        names = try container.decode([NameType:String].self, forKey: .names)
        let data = try container.decode(Data?.self, forKey: .imageData)
        image = image(from: data)
    }
    
    init(_ names: [NameType:String], image: UIImage? = nil) {
        id = PlantsManager.newId()
        self.names = names
        self.image = image
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(names, forKey: .names)
        try container.encode(imageData, forKey: .imageData)
    }
    
    private func image(from data: Data?) -> UIImage? {
        return data == nil ? nil : UIImage(data: data!)
    }
}
