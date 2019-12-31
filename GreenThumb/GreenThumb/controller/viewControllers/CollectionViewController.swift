//
//  CollectionViewController.swift
//  GreenThumb
//
//  Created by Sanjukta Roy on 11/20/19.
//  Copyright © 2019 Mana Roy Studio. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collection: CollectionView?
    var log: Log?
    var output: Output?
    var editMode: Bool = false
    var isEmpty: Bool {
        return false
    }
    var emptyMessage: String {
        return "No items"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        output = MessageWindow(self)
        setEditMode(false)
        collection?.delegate = self
        collection?.dataSource = self
        collection?.allowsMultipleSelection = false
        collection?.reloadData()
        if isEmpty {
            showEmptyMessage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemSelected(indexPath)
    }
    
    func editButtonPressed() {
        if !editMode {
            setEditMode(true)
            collection?.reloadData()
            return
        }
        setEditMode(false)
        guard let items = collection?.indexPathsForSelectedItems else {return}
        let _ = items.map{deleteObject(at: $0)}
        isEmpty ? showEmptyMessage() : (collection?.backgroundView = nil)
        collection?.reloadData()
    }
    
    func setEditMode(_ flag: Bool) {
        if flag {
            editButtonItem.title = "Done"
            collection?.allowsMultipleSelection = true
            editMode = true
        }
        else {
            editButtonItem.title = "Edit"
            collection?.allowsMultipleSelection = false
            editMode = false
        }
    }
    
    func insertItems(_ indxs: [IndexPath]?) {
        var indx: [IndexPath]
        if indxs != nil {
            indx = indxs!
            collection?.deleteItems(at: indx)
        }
        else {
            indx = [IndexPath(item: nItemsInSection(0), section: 0)]
        }
        collection?.insertItems(at: indx)
        collection?.backgroundView = nil
    }
    
    func showEmptyMessage() {
        let label = UILabel()
        label.text = emptyMessage
        label.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        label.textAlignment = .center
        collection?.backgroundView = label
    }
    
    func nItemsInSection(_ section: Int) -> Int {
        fatalError("Needs override!!!!!!!")
    }
    
    func cell(at indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Needs override!!!!!!!")
    }
    
    func itemSelected(_ indexPath: IndexPath) {
        fatalError("Needs override!!!!!!!")
    }
    
    func deleteObject(at indexPath: IndexPath) {
        fatalError("Needs override!!!!!!!")
    }
}
