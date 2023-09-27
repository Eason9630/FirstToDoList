//
//  ViewController.swift
//  FirstToDoList
//
//  Created by 林祔利 on 2023/8/30.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    // 存放待辦事項的陣列
    var items = [String]()

    // 創建一個 TableView
    private let table: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 從 UserDefaults 中讀取已保存的待辦事項
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        // 設置標題為 "待辦事項清單"
        title = "To Do List"
        // 將 TableView 添加到畫面中
        view.addSubview(table)
        
        // 設置 TableView 的數據源為當前 ViewController
        table.dataSource = self
        
        // 添加右上角的 "+ 按鈕"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(didTapApp))
        
    }
    
    // 當 "+ 按鈕" 被點擊時執行的函數
    @objc private func didTapApp() {
        let alert = UIAlertController(title: "New Item", message: "Enter new to do list item", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Enter item..."
        }
        alert.addAction(UIAlertAction(title: "Cencel", style: .cancel,handler: nil))
        alert.addAction(UIAlertAction(title: "Done ", style: .default, handler: { (_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty{
                    
                    // Enter new to do list item
                    // 將新的待辦事項保存到 UserDefaults 中
                    DispatchQueue.main.async {
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(text)
                        UserDefaults.standard.set(currentItems, forKey: "items")
                        // 更新當前的待辦事項列表
                        self.items.append(text)
                        self.table.reloadData()
                    }
                }
            }
        }))
        // 顯示彈出式視窗
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 設置 TableView 的尺寸為整個畫面
        table.frame = view.bounds
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // 設置 cell 的文本為待辦事項列表中的對應項目
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }

}

