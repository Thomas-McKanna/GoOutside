//
//  SettingsViewController.swift
//  GoOutside
//
//  Created by Thomas McKanna on 2/4/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var idealTempLabel: UILabel!
    @IBOutlet weak var idealTempSlider: UISlider!
    @IBOutlet weak var precipPrefPickerView: UIPickerView!
    var temporaryIdealTemp: Double = IDEAL_TEMP
    
    @IBAction func idealTempChanged(_ sender: UISlider) {
        idealTempLabel.text = String(Int(sender.value)) + DEGREE_SYMBOL
        determineColor(ForInt: Int(sender.value))
        temporaryIdealTemp = Double(sender.value)
    }
    
    let precipOptions = ["I don't mind", "I'd rather not", "I'm allergic to water"]
    
    func determineColor(ForInt n: Int) {
        let blue = ((90.0 - Float(n)) * 6.375)/255.0
        let red = ((Float(n) - 50.0) * 6.375)/255.0
        
        idealTempLabel.textColor = UIColor(colorLiteralRed: red, green: 0.0, blue: blue, alpha: 1.0)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        userDefaults.set(Double(temporaryIdealTemp), forKey: "idealTemp")
        
        userDefaults.set(setPrecipPenalty(precipPrefPickerView.selectedRow(inComponent: 0)), forKey: "precipPref")
        
        // set global variables
        IDEAL_TEMP = temporaryIdealTemp
    }
    
    func setPrecipPenalty(_ n: Int) -> Double {
        switch n {
        case 0: PRECIP_PENALTY = 40.0; return 40.0
        case 1: PRECIP_PENALTY = 70.0; return 70.0
        case 2: PRECIP_PENALTY = 100.0; return 100.0
        default: PRECIP_PENALTY = 70.0; return 70.0
        }
    }
    
    func getIndexFrom(Temperature t: Int) -> Int {
        switch t {
            case 40: return 0
            case 70: return 1
            case 100: return 2
            default: return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        precipPrefPickerView.delegate = self
        precipPrefPickerView.dataSource = self
        
        let idealTemp = userDefaults.integer(forKey: "idealTemp")
        if idealTemp != 0 {
            idealTempLabel.text = String(idealTemp) + DEGREE_SYMBOL
            determineColor(ForInt: idealTemp)
            idealTempSlider.value = Float(idealTemp)
        } else {
            idealTempLabel.text = "70" + DEGREE_SYMBOL
            determineColor(ForInt: 70)
        }
        
        let precipPref = userDefaults.integer(forKey: "precipPref")
        if precipPref != 0 {
            precipPrefPickerView.selectRow(getIndexFrom(Temperature: precipPref), inComponent: 0, animated: true)
        } else {
            precipPrefPickerView.selectRow(1, inComponent: 0, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return precipOptions[row]
    }
}
