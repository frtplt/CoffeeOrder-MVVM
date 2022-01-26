//
//  AddOrderTableViewController.swift
//  Coffee
//
//  Created by Firat on 24.01.2022.
//

import Foundation
import UIKit

protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController)
}

class AddOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var delegate: AddCoffeeOrderDelegate?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    private var vm = AddCoffeeOrderViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    private var coffeeSizeSegmentedController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
        
    }
    
    private func setupUI(){
        
        self.coffeeSizeSegmentedController = UISegmentedControl(items: self.vm.sizes)
        self.coffeeSizeSegmentedController.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(coffeeSizeSegmentedController)
        coffeeSizeSegmentedController.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 30).isActive = true
        coffeeSizeSegmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.types.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCoffeeOrderCell", for: indexPath)
        
        cell.textLabel?.text = self.vm.types[indexPath.row]
        return cell
        
    }
    @IBAction func close() {
        
        if let delegate = self.delegate {
            delegate.addCoffeeOrderViewControllerDidClose(controller: self)
        }
        
        
    }
    
    
    
    @IBAction func saveButtonPressed(){
        
        let name = self.nameTextField.text
        let email = self.emailTextField.text
        
        let selectedSize = self.coffeeSizeSegmentedController.titleForSegment(at: self.coffeeSizeSegmentedController.selectedSegmentIndex)
        
        guard let indexpath = self.tableView.indexPathForSelectedRow else {
            fatalError("Error with selecting index")
        }
        
        let selectedType = self.vm.types[indexpath.row]
        
        self.vm.name = name
        self.vm.email = email
        self.vm.selectedSize = selectedSize
        self.vm.selectedType = selectedType
        
        WebService().load(resource: Order.create(vm: self.vm)) { result in
            
            switch result {
            case .success(let order):
                
                if let order = order, let delegate = self.delegate {
                    
                    DispatchQueue.main.async {
                        delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                    }
                    
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
}
