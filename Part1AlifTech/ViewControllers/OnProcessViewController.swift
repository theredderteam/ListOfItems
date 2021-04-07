//
//  OnProcessViewController.swift
//  Part1AlifTech
//
//  Created by REDDER on 4/5/21.
//  Copyright © 2021 REDDER. All rights reserved.
//

import UIKit

class OnProcessTableViewCell: UITableViewCell {
   
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var StatusItem: UILabel!
    @IBOutlet weak var TimeItem: UILabel!
}



@available(iOS 13.0, *)

class OnProcessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     
     @IBOutlet weak var tableView: UITableView!
     
     private var process = [OnProcess]()
      private var modals = [ListItem]()
   

     
     
     override func viewDidLoad() {
         super.viewDidLoad()
         title = "В процессе"
         getOnProcessItems()
        getAllItems()
     
         tableView.delegate = self
             tableView.dataSource = self
             tableView.frame = view.bounds
         // Do any additional setup after loading the view.
     }
    
    @IBAction func AddNewItems(_ sender: Any) {
          
         let alert = UIAlertController(title: "Новая задача", message: "Добавьте новую задачу", preferredStyle: .alert)
                 
                 alert.addTextField(configurationHandler: nil)
                 //alert.addTextField(configurationHandler: nil)
          

                 
                 alert.addAction(UIAlertAction(title: "Добавить", style: .cancel, handler: { _ in
                     guard let field = alert.textFields?.first,
                  
                         let text = field.text,
                      !text.isEmpty else
                     { return }
                     
                    self.createItem(name: text)
                     
                 }))
                 
                 present(alert, animated:true)
      }
    
    
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
           return process.count
         }
         
         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "OnProcessTableViewCell", for: indexPath) as! OnProcessTableViewCell
          
          let model = process[indexPath.row]
          cell.ItemName?.text = model.name
          cell.TimeItem?.text = (model.date?.timeAgoDisplay())
            cell.StatusItem.text = model.status
           return cell
           
         }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = process[indexPath.row]
        

        
        let sheet = UIAlertController(title: "Редактировать или удалить", message: nil, preferredStyle: .actionSheet)
            
                     //alert.addTextField(configurationHandler: nil)
       
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Редактировать", message: "Редактировать задачу", preferredStyle: .alert)
                     alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
           

                       
                       alert.addAction(UIAlertAction(title: "Сохранить", style: .cancel, handler: { [weak self]_ in
                           guard let field = alert.textFields?.first,
                        
                               let nameNew = field.text,
                            !nameNew.isEmpty else
                           { return }
                           
                        self?.updateItemProcess(item: item, newName: nameNew )
                       }))
                       
            self.present(alert, animated:true)
            
            
            
            
        }))
        
        sheet.addAction(UIAlertAction(title: "Удалить", style: .default, handler: { [weak self]_ in
            self?.deleteItemProcess(item: item)
          
           
        }))
                     present(sheet, animated:true)
    }
    
    
    
    
    
    func createItem(name: String)
       {
           let newItem = ListItem(context: context)
           newItem.name = name
           newItem.date = Date()
           newItem.status = "В процессе"
        
        let OnProcessItem = OnProcess(context: context)
                  OnProcessItem.name = name
                  OnProcessItem.date = Date()
                  OnProcessItem.status = "В процессе"
        
           do
           {
               try context.save()
               getOnProcessItems()
               getAllItems()
           }
           catch
           {
               // error
           }
              
       }
    
    func getOnProcessItems()
     {
         
         do {
            process = try context.fetch(OnProcess.fetchRequest())
             DispatchQueue.main.async {
                 self.tableView.reloadData()
             }
         }
         catch
         {
             //error
         }
         
     }
    
    func getAllItems()
       {
           
           do {
              modals = try context.fetch(ListItem.fetchRequest())
               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
           }
           catch
           {
               //error
           }
           
       }
    
    func deleteItemProcess(item:OnProcess)
     {
         context.delete(item)
         
         do{
             try context.save()
             getAllItems()
             
         }
         catch
         {
             
         }
     }
     
       
     
     func updateItemProcess(item:OnProcess, newName: String)
        {
         item.name = newName
            do{
                       try context.save()
            
             getOnProcessItems()

                   }
                   catch
                   {
                       
                   }
        }

}

