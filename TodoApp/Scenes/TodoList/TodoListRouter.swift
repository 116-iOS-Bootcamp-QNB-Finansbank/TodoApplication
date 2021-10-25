//
//  TodoListRouter.swift
//  TodoApp
//
//  Created by alican on 23.10.2021.
//

import UIKit

final class TodoListRouter : TodoListRouterProtocol{

     unowned let view: UIViewController
     
     init(view: UIViewController) {
         self.view = view
     }

    func navigate(to route: TodoListRoute) {
        switch route {
        case .detail(let todo):
            
            let detailView = TodoDetailBuilder.make(with: todo)
            view.show(detailView, sender: nil)
        }
    }
}
