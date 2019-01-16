//
//  Plant.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

typealias NameList = [Plant.NameType:String]

class Plant: IdedObj {
    enum NameType: String, Codable {
        case common
        case scientific
        case nickname
        
        static var cases: [NameType] = [.nickname, .common, .scientific]
        
        func isValid(_ name: String?) -> Bool {
            switch self {
            case .scientific:
                guard name != nil && !(name?.isEmpty)! else {return false}
                let strings = name!.split(separator: " ", omittingEmptySubsequences: false)
                return strings.count == 2 &&
                    String(strings[0]).isAlphaNoDiacritics &&
                    String(strings[1]).isAlphaNoDiacritics
            default:
                return name != nil && !name!.isEmpty
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case names
        case location
        case preferedNameType
        case care
        case image
    }
    
    static var manager :Manager? {
        return AppDelegate.current?.plants 
    }
    var id: UniqueId
    var names: NameList
    var location: Location
    var preferedNameType = Plant.manager?.preferedNameType
    var care: CareInstructions
    var image: UIImage?
    var name: String {
        var str: String? = names[preferedNameType!]
        if (preferedNameType?.isValid(str))! {
            return str!
        }
        for type in Plant.NameType.cases {
            str = names[type]
            if type.isValid(str) {
                return str!
            }
        }
        return ""
    }
    var imageData: Data? {
        return (image == nil ? nil : UIImageJPEGRepresentation(image!, 0.5))
    }
    
    required init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        names = try container.decode([NameType:String].self, forKey: .names)
        location = try container.decode(Location.self, forKey: .location)
        preferedNameType = try container.decode(Plant.NameType.self, forKey: .preferedNameType)
        care = try container.decode(CareInstructions.self, forKey: .care)
        let data = try container.decode(Data?.self, forKey: .image)
        image = Plant.image(from: data)
    }
    
    init(_ names: NameList,  location: Location = Location.unknownLocation, image: UIImage? = nil, care: CareInstructions = CareInstructions(), preferedNameType: NameType = .nickname) {
        id = (Plant.manager?.newId())!
        self.names = names
        self.location = location
        self.image = image
        self.care = care
        self.preferedNameType = preferedNameType
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(names, forKey: .names)
        try container.encode(location, forKey: .location)
        try container.encode(preferedNameType, forKey: .preferedNameType)
        try container.encode(care, forKey: .care)
        try container.encode(imageData, forKey: .image)
    }
    
    func persist() throws {
        try Documents.instance?.store(self, as: id)
        try Plant.manager?.add(self)
    }
    
    func unpersist() throws {
        try Documents.instance?.remove(id)
        try Plant.manager?.remove(self)
    }
    
    private static func image(from data: Data?) -> UIImage? {
        return data == nil ? nil : UIImage(data: data!)
    }
}
