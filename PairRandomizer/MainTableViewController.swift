//
//  MainTableViewController.swift
//  PairRandomizer
//
//  Created by Joe Lucero on 9/1/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
   
   var prettyColors: [UIColor] = []
   
   // MARK: - IBActions
   @IBAction func addItem(_ sender: UIBarButtonItem) {
      let addItemController = UIAlertController(title: "Add New Item",
                                                  message: nil,
                                                  preferredStyle: .alert)
      
      var textFieldForAddItemController = UITextField()
      
      addItemController.addTextField { (textField) in
         textField.placeholder = "New Item"
         textFieldForAddItemController = textField
      }
      
      let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
         guard let text = textFieldForAddItemController.text,
            !text.isEmpty else { return }
         
         let newItem = text
         ItemController.shared.add(newItem: newItem)
         self.tableView.reloadData()
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      
      addItemController.addAction(cancelAction)
      addItemController.addAction(addAction)
      
      self.present(addItemController, animated: true, completion: nil)
   }
   
   @IBAction func randomizeButtonPressed() {
      ItemController.shared.randomizeItems()
      tableView.reloadData()
   }
}

// Data Source Methods
extension MainTableViewController {
   override func numberOfSections(in tableView: UITableView) -> Int {
      return ItemController.shared.items.count % 2 == 0 ? (ItemController.shared.items.count/2) : (ItemController.shared.items.count/2) + 1
   }
   
   override func tableView(_ tableView: UITableView,
                           numberOfRowsInSection section: Int) -> Int {
      if ItemController.shared.items.count % 2 == 0 {
         return 2
      } else {
         if section == (tableView.numberOfSections - 1) {
            return 1
         } else {
            return 2
         }
      }
   }
   
   override func tableView(_ tableView: UITableView,
                           cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      alterColorArray()
      
      let item = ItemController.shared.items[indexForItemAt(indexPath: indexPath)]
      let cell = tableView.dequeueReusableCell(withIdentifier: "CellForItem", for: indexPath)
      cell.textLabel?.text = item
      cell.backgroundColor = prettyColors[indexPath.section]
      return cell
   }
   
   override func tableView(_ tableView: UITableView,
                           titleForHeaderInSection section: Int) -> String? {
      return "Group #\(section + 1)"
   }
   
   override func tableView(_ tableView: UITableView,
                  willDisplayHeaderView view: UIView,
                  forSection section: Int) {
      
      guard let view = view as? UITableViewHeaderFooterView else { return }
      view.contentView.backgroundColor = prettyColors[section]
      view.textLabel?.textColor = UIColor.white
   }

}

// Table View Delegate Methods
extension MainTableViewController {
   override func tableView(_ tableView: UITableView,
                  commit editingStyle: UITableViewCellEditingStyle,
                  forRowAt indexPath: IndexPath) {
      let item = ItemController.shared.items[indexForItemAt(indexPath: indexPath)]
      ItemController.shared.delete(item: item)
      tableView.reloadData()
   }
}

// Helper Functions
extension MainTableViewController {
   func indexForItemAt(indexPath: IndexPath) -> Int {
      return (indexPath.section * 2) + (indexPath.row)
   }
   
   func alterColorArray() {
      while prettyColors.count < tableView.numberOfSections{
         let number1 = Double(arc4random_uniform(255))/255.0
         let number2 = Double(arc4random_uniform(255))/255.0
         let number3 = Double(arc4random_uniform(255))/255.0
         
         if number1 + number2 + number3 > 2 { continue }
            
         else {
         prettyColors.append(UIColor(
            red: CGFloat(number1),
            green: CGFloat(number2),
            blue: CGFloat(number3),
            alpha: 1.0
         ))
         }
      }
      
      if prettyColors.count > tableView.numberOfSections{
         prettyColors.removeLast()
      }
   }
}
