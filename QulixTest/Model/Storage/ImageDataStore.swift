//
//  ImageDataStore.swift
//  QulixTest
//
//  Created by Alex on 9.12.23.
//

import Foundation

class ImageDataStore {
    private (set) var items = [ImageData]() {
        didSet {
            //storedProductsChanged()
        }
    }
    
    //let storedProductsChanged: () -> Void
    
    init(items: [ImageData] = [ImageData]()
         //, storedProductsChanged: @escaping () -> Void
    ) {
        self.items = items
        //self.storedProductsChanged = storedProductsChanged
    }
    
    func add(_ images: [ImageData]) {
        items.append(contentsOf: images)
    }
    
    func removeAll() {
        items.removeAll()
    }
}
