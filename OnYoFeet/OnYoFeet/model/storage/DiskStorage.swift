//
//  DiskStorage.swift
//  OnYoFeet
//
//  Created by Sanjukta Roy on 11/3/18.
//  Copyright © 2018 Mana Roy Studio. All rights reserved.
//

import Foundation
import UIKit

class Documents: DiskStorage {
    static var instance: Documents? {
        return (UIApplication.shared.delegate as! AppDelegate).docs
    }
    
    override var searchPathDirectory: FileManager.SearchPathDirectory? {
        return .documentDirectory
    }
}

class Cache: DiskStorage {
    static var instance: Cache? {
        return (UIApplication.shared.delegate as! AppDelegate).cache
    }
    
    override var searchPathDirectory: FileManager.SearchPathDirectory? {
        return .cachesDirectory
    }
}

class DiskStorage: Storage {
    static var encoder: JSONEncoder = JSONEncoder()
    static var decoder: JSONDecoder = JSONDecoder()
    var searchPathDirectory: FileManager.SearchPathDirectory? {
        get {
            return nil
        }
    }
    fileprivate var directoryUrl: URL? {
        return FileManager.default.urls(for: searchPathDirectory!, in: .userDomainMask).first
    }
    
    func store<T: CodableObj>(_ object: T, as filename: String? = nil) throws {
        let file = filename ?? object.id
        guard let url = directoryUrl?.appendingPathComponent(file, isDirectory: false) else {
            throw GenericError("Unable to determine url for \(object.id)")
        }
        do {
            let data = try DiskStorage.encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            throw error
        }
    }
    
    func retrieve<T: CodableObj>(_ fileName: String, as type: T.Type) throws -> T {
        guard let url = directoryUrl?.appendingPathComponent(fileName, isDirectory: false) else {
            throw GenericError("Unable to determine url for \(fileName)")
        }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            throw GenericError("File at path \(url.path) does not exist!")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let obj = try DiskStorage.decoder.decode(type, from: data)
                return obj
            } catch {
                throw error
            }
        } else {
            throw GenericError("No data at \(url.path)!")
        }
    }
    
    func clear() throws {
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: directoryUrl!, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            throw error
        }
    }
    
    func remove(_ fileName: String) throws {
        guard let url = directoryUrl?.appendingPathComponent(fileName, isDirectory: false) else {
            throw GenericError("Unable to determine url for \(fileName)")
        }
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func fileExists(_ fileName: String) -> Bool {
        if let url = directoryUrl?.appendingPathComponent(fileName, isDirectory: false) {
            return FileManager.default.fileExists(atPath: url.path)
        }
        return false
    }
}

