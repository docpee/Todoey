//
//  ViewController.swift
//  Todoey
//
//  Created by Alessandro on 17/05/18.
//  Copyright © 2018 Centro Fotocomposizione. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
	
	var items: [Item] = [Item]()
	
	var selectedCategory: Category? {
		// Qunado selectedCategory è stato settato con un valore...
		didSet {
			loadItems()
		}
	}
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	//MARK - Table View DataSource Methods
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
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
			let newItem = Item(context: self.context)
			
			newItem.title = textField.text!
			newItem.done = false
			newItem.parentCategory = self.selectedCategory
			
			self.items.append(newItem)
			
			self.saveItem()
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	func saveItem() {
		do {
			try context.save()
		} catch {
			print(error)
		}
		
		tableView.reloadData()
	}
	
	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
		
		let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
		
		if let additionalPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
		} else {
			request.predicate = categoryPredicate
		}
		
		do {
			items = try context.fetch(request)
		} catch {
			print("\(error)")
		}
		
		tableView.reloadData()
	}
	
}

extension TodoListViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		
		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
		
		request.predicate = predicate
		
		let sortDescript = NSSortDescriptor(key: "title", ascending: true)
		
		request.sortDescriptors = [sortDescript]
		
		loadItems(with: request, predicate: predicate)
	}
	
		func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
			if searchBar.text?.count == 0 {
				loadItems()
	
				DispatchQueue.main.async {
					searchBar.resignFirstResponder()
				}
	
			}
		}
}





