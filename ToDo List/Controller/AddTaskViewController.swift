//
//  AddTaskViewController.swift
//  ToDo List
//
//  Created by Mohamed osama on 21/07/2021.
//

import Foundation
import UIKit
import RxSwift

class AddTaskViewController: UIViewController{
    
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    private var publishSubject = PublishSubject<Task>()
    var saveTask: Observable<Task>{
        return publishSubject.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func save(){
        guard let title = titleTextField.text ,  let paiority = Paiority(rawValue: segmentedControll.selectedSegmentIndex) else {return}
        let task = Task(title: title, paiority: paiority)
        publishSubject.onNext(task)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
