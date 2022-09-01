//
//  ViewController.swift
//  EnergyConsumptionCalculator
//
//  Created by M.Ali on 20/08/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: readings
    var current_reading: Int? = 590
    var previous_reading: Int? = 120
    var consumption: Int? = 0
    
    // MARK: Slab boundries.
    var slab_1: Int? = 100
    var slab_2: Int? = 500
    //    var slab_3: Int? = 900
    //    greate than 500 will cost 10/unit
    
    
    // MARK: Prices of each slab.
    var slab_price_1: Int? = 5
    var slab_price_2: Int? = 8
    var slab_price_3: Int? = 10
    
    // MARK: Payable Bill
    var bill: Int? = 0
    
    @IBOutlet weak var reading1_tf: UILabel!
    
    @IBOutlet weak var reading2_tf: UILabel!
    @IBOutlet weak var reading3_tf: UILabel!
    
    // MARK: Views
    @IBOutlet weak var consumerNo_tf: UITextField!
    @IBOutlet weak var currentReading_tf: UITextField!
    @IBOutlet weak var consumption_tf: UILabel!
    
    // MARK: get reference of NSManagedObject to interact with coredata
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ConsumptionCalculate()
    }
    
    @IBAction func save_btn(_ sender: Any) {
        
    }
    
    @IBAction func submit_btn(_ sender: Any) {
        
        if(self.consumerNo_tf.text?.isEmpty)!{
            self.consumerNo_tf.errorShowSuperView(message: "Required")
        }
        else if(self.currentReading_tf.text?.isEmpty)!{
            self.currentReading_tf.errorShowSuperView(message: "Required")
        }
        else{
            let value: Int = Int(self.consumerNo_tf.text!)!
//            getUserRecord(id: value)
            
            self.getUserList(id: value)
        }        
    }
    
    func ConsumptionCalculate(){
        if(previous_reading != 0){
            consumption = current_reading! - previous_reading!
            current_reading! = consumption!
            CalculateBill()
        }else{
            CalculateBill()
        }
    }
    func CalculateBill(){
        if(current_reading! <= slab_1!){
            bill = current_reading! * slab_price_1!
        }else if(current_reading! <= slab_2!){
            bill = slab_price_2! * (current_reading!-100) + (100 * slab_price_1!)
        }else {
            bill = (slab_price_3! * (current_reading!-500)) + ((500-100) * slab_price_2!) +  (100 * slab_price_1!)
        }
        print("bill is \(bill ?? 0)" )
        
        consumption_tf!.text? = "Consump: \(bill ?? 0) $"
    }
    
    func getUserRecord( id: Int) -> ConsumerModel? {
        
       
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Consumer")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d" ,id)
        do {
           // if consumer available in core data
            let request = try self.context.fetch(fetchRequest)
            if let list = request as? [Consumer] , list.count > 0 {
                
                previous_reading = Int(list.first!.reading2)
                current_reading = Int(self.currentReading_tf.text!)
                
                if(list.first?.reading2 == 0){
                   previous_reading = Int(list.first!.reading2)
                   current_reading = Int(self.currentReading_tf.text!)
                    if(current_reading! <= previous_reading!){
                        self.currentReading_tf.errorShowSuperView(message: "invalid 8. must be > previous")
                        return nil
                    }
                    ConsumptionCalculate()
                   saveValue(reading: "reading2", cost: "cost2")
               }
                else if(list.first?.reading3 == 0){
                    previous_reading = Int(list.first!.reading3)
                    current_reading = Int(self.currentReading_tf.text!)
                    if(current_reading! <= previous_reading!){
                        self.currentReading_tf.errorShowSuperView(message: "invalid 8. must be > previous")
                        return nil
                    }
                    ConsumptionCalculate()
                    saveValue(reading: "reading3", cost: "cost3")
                 
                }
                else{
                    previous_reading = Int(list.first!.reading1)
                    current_reading = Int(self.currentReading_tf.text!)
                    if(current_reading! <= previous_reading!){
                        self.currentReading_tf.errorShowSuperView(message: "invalid 8. must be > previous")
                        return nil
                    }
                    ConsumptionCalculate()
                    saveValue(reading: "reading1", cost: "cost1")
                }
                return ConsumerModel(dbModel: list.first!)
            }else{
                
                print("Data Not Found")
             
            saveValue(reading: "reading1", cost: "cost1")
                ConsumptionCalculate()
                
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        return nil
    }
    
    
    func saveValue(reading: String, cost: String){
        let tableName = "Consumer"
        let managedContext = self.context // get Managed Context instance
        if let entity = NSEntityDescription.entity(forEntityName: tableName, in: managedContext) {
            //Create object of User Table Entity
            let obj = NSManagedObject(entity: entity, insertInto: managedContext)
            //Set data of user with there specific key
            obj.setValue(Int32(self.consumerNo_tf.text!)!, forKey: "id")
            
            let value: Int = Int(self.currentReading_tf.text!)!
                obj.setValue(Int16(exactly: value)!, forKey: reading)
                obj.setValue(Int16(exactly: consumption!)!, forKey: cost)
    
            do{
                try self.context.save()
            }catch{
                print("exception occured...!")
            }
        }
    }
    
    
    //Useless - if you want ot fetch the matched users list from coredata
    func getUserList(id: Int) -> [ConsumerModel]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Consumer")
//        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d" ,id)
        
        do {
       
            let request = try self.context.fetch(fetchRequest)
            if let list = request as? [Consumer] , list.count > 0 {
//                print("Data Found -\(list[list.count-1].reading1)")
                
                if(list.count < 2){
                    print("Data Found <2 - \(list[list.count-2].reading1)")
                    self.reading1_tf.text? = "Reading: \(list[list.count-1].reading1)  Cost \(list[list.count-1].cost1)"
                    
                }else if(list.count < 3){
                    print("Data Found <3 - \(list[list.count-3].reading1)")
                    
                    self.reading1_tf.text? = "Reading: \(list[list.count-1].reading1)  Cost \(list[list.count-1].cost1)"
                    self.reading2_tf.text? = "Reading: \(list[list.count-2].reading1)  Cost \(list[list.count-2].cost1)"
                }
                else {
                    print("Data Found else - \(list[list.count-1].reading1) --- \(list[list.count-2].reading1)")
                    
                    self.reading1_tf.text? = "Reading: \(list[list.count-1].reading1)  Cost \(list[list.count-1].cost1)"
                    self.reading2_tf.text? = "Reading: \(list[list.count-2].reading1)  Cost \(list[list.count-2].cost1)"
                    self.reading3_tf.text? = "Reading: \(list[list.count-3].reading1)  Cost \(list[list.count-3].cost1)"
                }
                
                current_reading = Int(self.currentReading_tf.text!)
                previous_reading = Int(list[list.count-1].reading1)
                ConsumptionCalculate()
                
                var con: Int = self.consumption! - Int(exactly: list[list.count-1].cost1)!
                saveValue(reading: "reading1", cost: "cost1")
                return ConsumerModel.convertIntoModel(dbModelList: list)
            }else {
                
                print("Data Not Found")
                
                current_reading = Int(self.currentReading_tf.text!)
                previous_reading = 0
                ConsumptionCalculate()
                saveValue(reading: "reading1", cost: "cost1")
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        return nil
    }
}


