//
//  FirstViewController.swift
//  SkillboxLesson14
//
//  Created by Сергей Шопин on 07.10.2020.
//

import UIKit


class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       // nameTextField.text = Persistance.shared.
        surnameTextField.text =  Persistance.shared.userSurname
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var surnameTextField: UITextField!
    
    @IBAction func editingName(_ sender: UITextField) {
    }
    
    @IBAction func editingSurname(_ sender: UITextField) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
