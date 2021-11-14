//
//  TodoDetailViewController.swift
//  TodoApp
//
//  Created by alican on 24.10.2021.
//

import UIKit

class TodoDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todoDetailSearchBar: UISearchBar!
    @IBOutlet weak var addTodoDetailButton: UIButton!
    
    private var todoDetailList: [TodoDetailPresentation] = []
    var textField = UITextField()
    
    var viewModel : TodoDetailListViewModelProtocol!{
        didSet{
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
        setTheme()
    }
            
    override func viewWillAppear(_ animated: Bool) {
        setSearchBar()
        viewModel.load()
        tableView.reloadData()
        UINavigationController().setNavigationController(nav: navigationController!)
    }
}

extension TodoDetailViewController : TodoDetailListViewModelDelegate{
    func handleViewModelOutput(_ output: TodoDetailListViewModelOutput) {
        switch output {
        case .updateTitle(let title):
            self.title = title
        case .setLoading(let isLoading):
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        case .showTodoDetailList(let todoDetailList):
            self.todoDetailList = todoDetailList
            tableView.reloadData()
        }
    }
    
    func navigate(to route: TodoDetailListViewRoute) {
        switch route {
        case .detail(let viewModel):
            let viewController = TodoExplanationBuilder.make(with: viewModel)
            show(viewController,sender: nil)
        }
    }
}

extension TodoDetailViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReservedStrings.TodoDetailCell.asString) as! TodoDetailCell
        let todoDetail = todoDetailList[indexPath.row]
        cell.detailLbl.text = todoDetail.explanation
        cell.detailTitleLbl.text = todoDetail.detailTitle
        cell.isCompletedLbl.image = todoDetail.isCompleted ? CustomImage.checkmark : CustomImage.xmark
        cell.dateLbl.text = DateFormatter().convertDateToString(date: todoDetail.date)
        cell.avatarLbl.image = CustomImage.circle
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoDetailList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
  extension TodoDetailViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectedTodoDetail(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: LocalizableStrings.delete.description.localized()) { (contextualAction, view, boolValue) in
            self.viewModel.deleteTodoDetail(index: indexPath.row)
            self.todoDetailList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            //tableView.reloadData()
            boolValue(true)
           }
        deleteAction.backgroundColor = .systemPink
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])

        return swipeActions
    }

    @IBAction func addDetailButtonClicked(_ sender: UIButton) {
        viewModel.addTodoDetail()
    }
}

extension TodoDetailViewController : UISearchBarDelegate{
    func setSearchBar() {
        if #available(iOS 13.0, *) {
            todoDetailSearchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: LocalizableStrings.searchbarPlaceHolder.description.localized(), attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        } else {
            if let searchField = todoDetailSearchBar.value(forKey: ReservedStrings.searchField.asString) as? UITextField {
                searchField.attributedPlaceholder = NSAttributedString(string: LocalizableStrings.searchbarPlaceHolder.description.localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            }
        }
    }
}

extension TodoDetailViewController{
     func setTheme() {
        tableView.theme.backgroundColor = themed { $0.tableViewBackgroundColor }
        tableView.theme.tintColor = themed { $0.tableViewTintColor }
        todoDetailSearchBar.theme.backgroundColor = themed { $0.searchBarBackgroundColor }
        todoDetailSearchBar.theme.barTintColor = themed { $0.searchBarBarTintColor }
        todoDetailSearchBar.theme.tintColor = themed { $0.searchBarTintColor }
        addTodoDetailButton.theme.backgroundColor = themed { $0.addButtonBackgroundColor }
        addTodoDetailButton.theme.tintColor = themed { $0.addButtonTintColor }
    }
}
