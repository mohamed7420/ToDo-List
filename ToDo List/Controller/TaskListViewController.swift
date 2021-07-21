//
//  TaskListViewController.swift
//  ToDo List
//
//  Created by Mohamed osama on 16/07/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class TaskListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var paioritySegementedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private var disposeBag = DisposeBag()
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = self.filteredTasks[indexPath.row].title
        cell.textLabel?.text = title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navVC = segue.destination as? UINavigationController , let addVC = navVC.viewControllers.first as? AddTaskViewController else {return}
        addVC.saveTask.subscribe(onNext: { [unowned self] task in
            print(task)
            let paiority = Paiority(rawValue: self.paioritySegementedControl.selectedSegmentIndex - 1)
            var tasks = self.tasks.value
            tasks.append(task)
            self.tasks.accept(tasks)
            self.filterTasks(by: paiority)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func selectedPaiorityControll(sender: UISegmentedControl){
        let paiority = Paiority(rawValue: sender.selectedSegmentIndex - 1)
        self.filterTasks(by: paiority)
    }
    
    private func filterTasks(by paiority: Paiority?){
        if paiority == nil{
            self.filteredTasks = tasks.value.reversed()
            self.updateTableView()
        }else{
            self.tasks.map { tasks in
                tasks.filter{
                    return $0.paiority == paiority!
                }
            }.subscribe(onNext:{ [weak self] tasks in
                self?.filteredTasks = tasks.reversed()
                self?.updateTableView()
            }).disposed(by: disposeBag)
        }
        
    }
    
    private func updateTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
}
