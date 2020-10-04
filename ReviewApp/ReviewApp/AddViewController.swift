//
//  AddViewController.swift
//  ReviewApp
//
//  Created by Y on 2020/10/03.
//

import UIKit

protocol EditDelegate{
    func addTaskButtonTapped(_ detail: String)
}

class AddViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    
    var delegate: EditDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func done(_ sender: Any) {
        if delegate != nil {
            delegate?.addTaskButtonTapped(inputTextField.text!)
        }
        dismiss(animated: true, completion: nil)
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