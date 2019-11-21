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

    override func viewDidLoad() {
        super.viewDidLoad()
        output = MessageWindow(self)
        log = AppDelegate.current?.log
        collection?.delegate = self
        collection?.dataSource = self
        collection?.reloadData()
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
    
    func nItemsInSection(_ section: Int) -> Int {
        fatalError("Needs override!!!!!!!")
    }
    
    func cell(at indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Needs override!!!!!!!")
    }
    
    func itemSelected(_ indexPath: IndexPath) {
        fatalError("Needs override!!!!!!!")
    }
}
