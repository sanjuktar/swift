//
//  Plant.Names.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 12/9/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import Foundation

extension Plant {
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

    struct NameList: Codable {
        var version: String = Defaults.version
        var nickname: String
        var common: String
        var scientific: String
        var use: String {
            if NameType.nickname.isValid(nickname) {
                return nickname
            }
            if NameType.common.isValid(common) {
                return common
            }
            if NameType.scientific.isValid(scientific) {
                return scientific
            }
            return ""
        }
    
        init(nickName: String = "", common: String = "", scientific: String = "") {
            self.nickname = nickName
            self.common = common
            self.scientific = scientific
        }
    
        func validate() -> Bool {
            return Plant.NameType.nickname.isValid(nickname) ||
                Plant.NameType.common.isValid(common) ||
                Plant.NameType.scientific.isValid(scientific)
        }
    }
}
