//
//  GoViewController.swift
//  hi
//
//  Created by Margarita Yaganova on 08.05.2023.
//

import UIKit


class GoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var groupSize: UITextField!
    @IBOutlet weak var infectionFactor: UITextField!
    @IBOutlet weak var time: UITextField!
    
    @IBOutlet weak var sumbittionButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    
    let userDef = UserDefaults.standard
    
    var n1: String?
    var m1: String?
    var t1: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sumbittionButton.layer.cornerRadius = 25
        
        setupAddTargetIsNotEmptyTextFields()
        
        randomButton.layer.cornerRadius = 25
        
        sumbittionButton.isHidden = false
        sumbittionButton.setTitle("Запустить моделирование", for: .normal)
        sumbittionButton.layer.cornerRadius = 25
        sumbittionButton.alpha = 0.3
        sumbittionButton.backgroundColor = .systemGreen
        sumbittionButton.setTitleColor(.white, for: .normal)
        
        groupSize.delegate = self
        infectionFactor.delegate = self
        time.delegate = self
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard segue.identifier == "showSecond" else { return }
        guard segue.destination is ViewController else { return }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == groupSize {
            n1 = textField.text
        } else if textField == infectionFactor {
            m1 = textField.text
        } else if textField == time {
            t1 = textField.text
        }
    }

    @IBAction func name_act(_ sender: Any) {
        let text = groupSize.text ?? ""
        if text.isValidNumbers() {
            groupSize.textColor = UIColor.black
            groupSize.layer.borderColor = UIColor.lightGray.cgColor
            groupSize.layer.borderWidth = 1.0
        } else {
            self.sumbittionButton.isEnabled = false
            groupSize.layer.borderColor = UIColor.systemRed.cgColor
            groupSize.layer.borderWidth = 1.0
            sumbittionButton.layer.cornerRadius = 25
            sumbittionButton.alpha = 0.3
            sumbittionButton.backgroundColor = .systemGreen
            sumbittionButton.setTitleColor(.white, for: .normal)
        }
    }
    
    
    @IBAction func director_act(_ sender: Any) {
        let text = infectionFactor.text ?? ""
        if text.isValidNumbers() {
            infectionFactor.textColor = UIColor.black
            infectionFactor.layer.borderColor = UIColor.systemGray.cgColor
            infectionFactor.layer.borderWidth = 1.0
        } else {
            self.sumbittionButton.isEnabled = false
            infectionFactor.layer.borderColor = UIColor.systemRed.cgColor
            infectionFactor.layer.borderWidth = 1.0
            sumbittionButton.layer.cornerRadius = 25
            sumbittionButton.alpha = 0.3
            sumbittionButton.backgroundColor = .systemGreen
            sumbittionButton.setTitleColor(.white, for: .normal)
        }
    }
    
    
    @IBAction func year_act(_ sender: Any) {
        let text = time.text ?? ""
        if text.isValidNumbers() {
            time.textColor = UIColor.black
            time.layer.borderColor = UIColor.systemGray.cgColor
            time.layer.borderWidth = 1.0
        } else {
            self.sumbittionButton.isEnabled = false
            time.layer.borderColor = UIColor.systemRed.cgColor
            time.layer.borderWidth = 1.0
            sumbittionButton.layer.cornerRadius = 25
            sumbittionButton.alpha = 0.3
            sumbittionButton.backgroundColor = .systemGreen
            sumbittionButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc func setupAddTargetIsNotEmptyTextFields() {
        sumbittionButton.isHidden = true
        groupSize.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
        infectionFactor.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
        time.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
       }
    
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        var allFieldsValid = true // Initialize the Boolean variable
        
        if groupSize.text == nil || groupSize.text == "" || !groupSize.text!.isValidNumbers() {
            groupSize.layer.borderColor = UIColor.systemRed.cgColor
            groupSize.layer.borderWidth = 1.0
            groupSize.textColor = UIColor.red
            allFieldsValid = false // Set the Boolean to false
        } else {
            groupSize.layer.borderColor = UIColor.lightGray.cgColor
            groupSize.layer.borderWidth = 1.0
            groupSize.textColor = UIColor.black
        }
        
        if infectionFactor.text == nil || infectionFactor.text == "" || !infectionFactor.text!.isValidNumbers() {
            infectionFactor.layer.borderColor = UIColor.systemRed.cgColor
            infectionFactor.layer.borderWidth = 1.0
            infectionFactor.textColor = UIColor.red
            allFieldsValid = false // Set the Boolean to false
        } else {
            infectionFactor.layer.borderColor = UIColor.systemGray.cgColor
            infectionFactor.layer.borderWidth = 1.0
            infectionFactor.textColor = UIColor.black
        }
        
        if time.text == nil || time.text == "" || !time.text!.isValidNumbers() {
            time.layer.borderColor = UIColor.systemRed.cgColor
            time.layer.borderWidth = 1.0
            time.textColor = UIColor.red
            allFieldsValid = false // Set the Boolean to false
        } else {
            time.layer.borderColor = UIColor.systemGray.cgColor
            time.layer.borderWidth = 1.0
            time.textColor = UIColor.black
        }
        
        // Enable or disable the submission button based on the Boolean variable
        if allFieldsValid {
            self.sumbittionButton.isEnabled = true
            self.sumbittionButton.isHidden = false
            sumbittionButton.setTitle("Запустить моделирование", for: .normal)
            sumbittionButton.layer.cornerRadius = 25
            sumbittionButton.alpha = 1
            sumbittionButton.backgroundColor = .systemGreen
            sumbittionButton.setTitleColor(.white, for: .normal)
        } else {
            self.sumbittionButton.isEnabled = false
            self.sumbittionButton.isHidden = false
            sumbittionButton.setTitle("Запустить моделирование", for: .normal)
            sumbittionButton.layer.cornerRadius = 25
            sumbittionButton.alpha = 0.3
            sumbittionButton.backgroundColor = .systemGreen
            sumbittionButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func randomData(_ sender: Any) {
        groupSize.text = String(Int.random(in: 0..<100))
        infectionFactor.text = String(Int.random(in: 0..<100))
        time.text = String(Int.random(in: 0..<100))
        let text1 = groupSize.text ?? ""
        if text1.isValidNumbers() {
            groupSize.textColor = UIColor.black
            groupSize.layer.borderColor = UIColor.lightGray.cgColor
            groupSize.layer.borderWidth = 1.0
            n1 = groupSize.text
        } else {
            groupSize.layer.borderColor = UIColor.systemRed.cgColor
            groupSize.layer.borderWidth = 1.0
            self.sumbittionButton.isEnabled = false
        }
        let text2 = infectionFactor.text ?? ""
        if text2.isValidNumbers() {
            infectionFactor.textColor = UIColor.black
            infectionFactor.layer.borderColor = UIColor.lightGray.cgColor
            infectionFactor.layer.borderWidth = 1.0
            m1 = infectionFactor.text
        } else {
            infectionFactor.layer.borderColor = UIColor.systemRed.cgColor
            infectionFactor.layer.borderWidth = 1.0
            self.sumbittionButton.isEnabled = false
        }
        let text3 = infectionFactor.text ?? ""
        if text3.isValidNumbers() {
            time.textColor = UIColor.black
            time.layer.borderColor = UIColor.lightGray.cgColor
            time.layer.borderWidth = 1.0
            t1 = time.text
        } else {
            time.layer.borderColor = UIColor.systemRed.cgColor
            time.layer.borderWidth = 1.0
        }
        
        randomButton.isHidden = false
        randomButton.setTitle("Случайные данные", for: .normal)
        randomButton.layer.cornerRadius = 25
        randomButton.alpha = 0.3
        sumbittionButton.backgroundColor = .systemGreen
        sumbittionButton.alpha = 1
        
    }
        
        
    @IBAction func saveButton(_ sender: Any) {
        userDef.setValue(groupSize.text, forKey: "t1")
        userDef.setValue(infectionFactor.text, forKey: "t2")
        userDef.setValue(time.text, forKey: "t3")
        
        sumbittionButton.isHidden = false
        sumbittionButton.setTitle("Запустить моделирование", for: .normal)
        sumbittionButton.layer.cornerRadius = 25
        sumbittionButton.alpha = 0.3
        sumbittionButton.backgroundColor = .systemGreen
        sumbittionButton.setTitleColor(.white, for: .normal)
    }
}

extension String {
    
    func isValidNumbers() -> Bool {
        let inputRegEx = "^[1-9][0-9]*$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with:self)
    }
}


