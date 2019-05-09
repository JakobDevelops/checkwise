//
//  AddTodoViewController.swift
//  checkwise
//
//  Created by Jakob Wiemer on 08.05.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
 
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        textView.becomeFirstResponder() //Anweisung, dass die TextView direkt ausgewählt ist beim öffnen der Aktivität

        // Do any additional setup after loading the view.
    }
    
    //Methode um den Bottom Constraint anzupassen, sobald das Keyboard sich öffnet
    @objc func keyboardWillShow(with notification: Notification){
       
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {return}
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 7
        
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
        textView.resignFirstResponder()
        //wenn cancel gedrückt wird, wird das Keyboard instant geschlossen
    }
    
    @IBAction func done(_ sender: UIButton) {
        
        //check if something is in the text view
        guard let title = textView.text, !title.isEmpty else {
            return
        }
        let item = Items(context: managedContext)
        item.title = title
        item.priority = Int16(segmentedControl.selectedSegmentIndex)
        item.date = Date()
        
        do {
            try managedContext.save()
            dismiss(animated: true)
            textView.resignFirstResponder()
        } catch {
            print("Error saving item \(error)")
        }
        
    }

}

extension AddTodoViewController: UITextViewDelegate{
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneButton.isHidden{
            textView.text.removeAll() //sobald remove gedrückt wird, wird der gesamte Text entfernt
            textView.textColor = .gray //textfarbe stat orange jetzt auf grau
            
            doneButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
