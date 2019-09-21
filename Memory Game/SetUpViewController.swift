//
//  SetUpViewController.swift
//  Memory Game
//
//  Created by Nancy Wu on 2019-09-21.
//  Copyright © 2019 Nancy Wu. All rights reserved.
//

import Foundation
import UIKit

class SetUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var textField: UITextField!
    let pickerValues = ["2","3","4","5","6","7","8"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(pickerValues[row])
        return pickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        textField.text = pickerValues[row]
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.delegate = self
        
        textField.inputView = pickerView
        
        textField.text = pickerValues[0]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a variable that you want to send
        var numberOfItems = Int(textField.text ?? "2")
    
        let vc = segue.destination as! ViewController
        vc.numberOfItemsToMatch = numberOfItems ?? 2
        }
}
