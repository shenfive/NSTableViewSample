//
//  ViewController.swift
//  NSTableViewSample
//
//  Created by 申潤五 on 2021/12/27.
//

import Cocoa

class ViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource {

    @IBOutlet weak var importentCheckBox: NSButton!
    @IBOutlet weak var theTextField: NSTextField!
    @IBOutlet weak var toDoListTable: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    
    
    var toDoItems:[ToDoItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        deleteButton.isHidden = true
        toDoListTable.dataSource = self
        toDoListTable.delegate = self
        getToDoItem()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func getToDoItem(){
        //取得資料
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
      
        if let context = appDelegate?.persistentContainer.viewContext{
            do{
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
                toDoListTable.reloadData()
            }catch{
                
                return
            }
            
        }
        //更新NSTableView
    }
    
    
    @IBAction func clickAction(_ sender: NSButton) {
        if theTextField.stringValue != ""{
            let appDelegate = NSApplication.shared.delegate as? AppDelegate
          
            if let context = appDelegate?.persistentContainer.viewContext{
                let toDoItem = ToDoItem(context: context)
                toDoItem.name = theTextField.stringValue
                toDoItem.importent = (importentCheckBox.state.rawValue != 0) ? true : false
            }
            appDelegate?.saveAction(self)
            importentCheckBox.state = NSControl.StateValue.off
            theTextField.stringValue = ""
            
            getToDoItem()
        }
        
    }
    
    
    
    
    
    @IBAction func deleteAction(_ sender: Any) {
        let toDoItem = toDoItems[toDoListTable.selectedRow]
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext{
            context.delete(toDoItem)
            appDelegate?.saveAction(self)
            getToDoItem()
        }
    }
    
    
    
    //MARK:TableView Delegate and DataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        let toDoItem = toDoItems[row]

        switch tableColumn?.identifier{
        case NSUserInterfaceItemIdentifier(rawValue: "import"):
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "importCell"), owner: self) as? NSTableCellView
            cell?.textField?.stringValue = toDoItem.importent ? "！" : ""
            return cell
        case NSUserInterfaceItemIdentifier(rawValue: "name"):
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "toDoLabel"), owner: self) as? NSTableCellView
            cell?.textField?.stringValue = toDoItem.name ?? ""
        return cell
        default:
            return nil
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        print(toDoListTable.selectedRow)
        if toDoListTable.selectedRow >= 0{
            deleteButton.isHidden = false
        }else{
            deleteButton.isHidden = true
        }
    }
    

    
}

