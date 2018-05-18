//
//  ViewController.swift
//  Todoey
//
//  Created by Alessandro on 17/05/18.
//  Copyright © 2018 Centro Fotocomposizione. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	let arr = ["One", "Two", "Three"]

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arr.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
		
		cell.textLabel?.text = arr[indexPath.row]
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		} else {
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}

