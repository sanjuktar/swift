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
        static var prefered: NameType = .nickname
        
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
        case version
        case id
        case names
        case location
        case care
        case image
    }
    
    static var manager :Manager? 
    var version: String
    var id: UniqueId
    var names: NameList
    var location: UniqueId
    var care: CareInstructions
    var image: UIImage?
    var name: String {
        var str: String? = names[NameType.prefered]
        if (NameType.prefered.isValid(str)) {
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
        return (image == nil ? nil : image!.jpegData(compressionQuality: 0.5))
    }
    var description: String {
        return name
    }
    var preferedNameType: NameType {
        return NameType.prefered
    }
    var copy: Plant? {
        var p = Plant(names, location: location, image: image, care: care, preferedNameType: preferedNameType)
        p.id = id
        return p
    }
    
    required init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        id = try container.decode(String.self, forKey: .id)
        names = try container.decode([NameType:String].self, forKey: .names)
        location = try container.decode(UniqueId.self, forKey: .location)
        if Plant.manager?.get(location) == nil {
            location = Defaults.location
        }
        care = try container.decode(CareInstructions.self, forKey: .care)
        let data = try container.decode(Data?.self, forKey: .image)
        image = Plant.image(from: data)
    }
    
    init(_ names: NameList = [:], location: UniqueId = Defaults.location,
         image: UIImage? = nil, care: CareInstructions = CareInstructions(),
         preferedNameType: NameType = .nickname) {
        version = Defaults.version
        id = (Plant.manager?.newId())!
        self.names = names
        self.location = location
        self.image = image
        self.care = care
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(id, forKey: .id)
        try container.encode(names, forKey: .names)
        try container.encode(location, forKey: .location)
        try container.encode(imageData, forKey: .image)
        try container.encode(care, forKey: .care)
    }
    
    func persist() throws {
        try Plant.manager?.add(self)
    }
    
    func unpersist() throws {
        try Plant.manager?.remove(self)
    }
    
    private static func image(from data: Data?) -> UIImage? {
        return data == nil ? nil : UIImage(data: data!)
    }
}
