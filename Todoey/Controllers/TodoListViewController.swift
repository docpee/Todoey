//
//  ViewController.swift
//  Todoey
//
//  Created by Alessandro on 17/05/18.
//  Copyright © 2018 Centro Fotocomposizione. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	var items: [Item] = [Item]()
//	let defaults = UserDefaults.standard
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

	override func viewDidLoad() {
		super.viewDidLoad()
		
		print(dataFilePath!)
		
		var newItem = Item()
		newItem.title = "Find Mike"
		newItem.done = true
		items.append(newItem)
		
		var newItem2 = Item()
		newItem2.title = "Buy Eggs"
		items.append(newItem2)
		
		var newItem3 = Item()
		newItem3.title = "Destroy Demogorgone"
		items.append(newItem3)
		
//		if let itemsArray = defaults.array(forKey: "TodoListArray") as? [String] {
//			items = itemsArray
//		}
		
	}

	//MARK - Table View DataSource Methods
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
		print("cellForRowAtindexPath Called")
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
		
		cell.textLabel?.text = items[indexPath.row].title
		
		if items[indexPath.row].done == true {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		
		return cell
	}
	
	//MARK - Table View Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if items[indexPath.row].done == false {
			items[indexPath.row].done = true
		} else {
			items[indexPath.row].done = false
		}
		
//		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//			tableView.cellForRow(at: indexPath)?.accessoryType = .none
//		} else {
//			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//		}
		
		saveItem()
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	//MARK - Add Button
	@IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Aggiungi Articolo", message: "", preferredStyle: .alert)
		
		alert.addTextField { (alertTextFiled) in
			alertTextFiled.placeholder = "Inserisci Articolo"
			textField = alertTextFiled
		}
		
		let action = UIAlertAction(title: "Aggiungi", style: .default) { (action) in
			var newItem = Item()
			
			newItem.title = textField.text!
			
			self.items.append(newItem)
			
			self.saveItem()
			
//			self.defaults.set(self.items, forKey: "TodoListArray")
			
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	func saveItem() {
		let encoder = PropertyListEncoder()
		
		do {
			let data = try encoder.encode(self.items)
			try data.write(to: self.dataFilePath!)
		} catch {
			print(error)
		}
		
		tableView.reloadData()
	}
	
}

