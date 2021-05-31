//
//  DaDaPickerView.swift
//  Cocoapods_DaDaSample
//
//  Created by DaDa on 2021/05/14.
//

import UIKit

class DaDaPickerView: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var viewController:ViewController!
    var pickerView:UIPickerView!
    var pickerData: [String]!
    var title:String = ""
    
    var callback:(_ value:String)->Void?
    
    
    init(controller viewController:ViewController, data pickerData:[String], callback: @escaping(_ value:String)->Void, title title:String ) {
        
        self.viewController = viewController
        self.pickerData = pickerData
        self.callback = callback
        self.title = title
        
        super.init()
        
        pickerView = UIPickerView(frame: CGRect(x: 10, y: 50, width: 250, height: 150))
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerData[row])"
    }
    
    func append(length:Int) -> String{
        var buff:String = ""
        
        for _ in 0 ..< length {
            buff += "\n"
        }
        return buff
    }
    
    func show(){
        let alertController = UIAlertController(title:self.title,message: append(length: 9), preferredStyle: .alert)
        alertController.view.addSubview(pickerView)
        alertController.addAction(UIAlertAction(title:"OK", style: .default, handler: { _ in
            let pickerValue = self.pickerData[self.pickerView.selectedRow(inComponent: 0)]
                self.callback(pickerValue)
             
        }))
        alertController.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        
        if(viewController != nil){
            viewController.present(alertController, animated: true)
        }
        
    }
}
