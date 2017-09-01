//
//  ItemController.swift
//  PairRandomizer
//
//  Created by Joe Lucero on 9/1/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import Foundation
typealias Item = String

class ItemController {
   static var shared = ItemController()

   var items: [Item] = []
   
   private init() {
      loadItems()
   }
   
   func add(newItem: Item) {
      items.append(newItem)
      randomizeItems()
      saveItems()
   }
   
   func delete(item: Item) {
      guard let index = items.index(of: item) else { return }
      items.remove(at: index)
      randomizeItems()
      saveItems()
   }

   func randomizeItems() {
      var newArray: [Item] = []
      for item in items {
         let randomNumber = Int(arc4random_uniform(UInt32(newArray.count)))
         newArray.insert(item, at: randomNumber)
      }
      items = newArray
   }
}

fileprivate extension ItemController {
   static let itemsKey = "ItemsKey"
   func loadItems() {
      guard let savedItems = UserDefaults.standard.array(forKey: ItemController.itemsKey) as? [Item] else { return }

      items = savedItems
   }
   
   func saveItems() {
      UserDefaults.standard.set(items, forKey: ItemController.itemsKey)
   }
}
