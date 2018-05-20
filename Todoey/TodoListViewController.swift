//
//  ViewController.swift
//  Todoey
//
//  Created by Alessandro on 17/05/18.
//  Copyright © 2018 Centro Fotocomposizione. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	var items: [String] = []
	let defaults = UserDefaults.standard

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let itemsArray = defaults.array(forKey: "TodoListArray") as? [String] {
			items = itemsArray
		}
	}

	//MARK - Table View DataSource Methods
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
		
		cell.textLabel?.text = items[indexPath.row]
		
		return cell
	}
	
	//MARK - Table View Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		} else {
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
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
			self.items.append(textField.text ?? "Nuovo Articolo")
			
			self.defaults.set(self.items, forKey: "TodoListArray")
			
			self.tableView.reloadData()
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
}

