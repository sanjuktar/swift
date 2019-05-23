//
//  DiskStorage.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/7/18.
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
    
    func store<T: Storable>(_ object: T, as filename: String) throws {
        guard let url = directoryUrl?.appendingPathComponent(filename, isDirectory: false) else {
            throw GenericError("Unable to determine url for \(filename)")
        }
        do {
            let data = try DiskStorage.encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            throw GenericError("Unable to encode aand store \(object): \(error.localizedDescription)")
        }
    }
    
    func retrieve<T: Storable>(_ fileName: String, as type: T.Type) throws -> T {
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
                throw GenericError("Unable to decode \(fileName): \(error.localizedDescription)")
            }
        } else {
            throw GenericError("No data at \(url.path)!")
        }
    }
    
    func clear() throws {
        var contents: [URL]
        do {
            contents = try FileManager.default.contentsOfDirectory(at: directoryUrl!, includingPropertiesForKeys: nil, options: [])
        } catch {
            throw GenericError("Unable to determine contents of storage so cannot clear contents: \(error.localizedDescription)")
        }
        for fileUrl in contents {
            do {
                try FileManager.default.removeItem(at: fileUrl)
            } catch {
                throw GenericError("Aborting clear() because unable to remove item \(fileUrl): \(error.localizedDescription)")
            }
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
                throw GenericError("Unable to remove \(url): \(error.localizedDescription)")
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

