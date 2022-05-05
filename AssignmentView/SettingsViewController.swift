//
//  SettingsViewController.swift
//  AssignmentView
//
//  Created by Hakan Kumdakçı on 2.05.2022.
//

import UIKit
import SDWebImage


class SettingsViewController: UIViewController {
    
    var options: [String: String] = ["Download big images in low priority": "downloadPriority",
                                     "Clean cache after terminate app": "terminateCache",
                                     "Clean cache after app moves to background": "backgroundCache",
                                     "Allow to use cache": "regularCache",
                                     "Load images faster": "thumbnailImage"]
    
    
    lazy var clearCacheButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setTitle("Clear Cache", for: .normal)
        btn.tintColor = .systemBlue
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(clearCache), for: .touchUpInside)
        return btn
    }()
    
    lazy var tableView: UITableView! = {
        var table = UITableView(frame: .zero)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "Settings"
        
        view.addSubview(clearCacheButton)
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
            
        tableView.topToSuperview(offset: 16, usingSafeArea: true)
        tableView.leadingToSuperview()
        tableView.trailingToSuperview()
        tableView.height(240)
        tableView.sizeToFit()
        
        clearCacheButton.topToBottom(of: tableView)
        clearCacheButton.leadingToSuperview()
        clearCacheButton.trailingToSuperview()
        clearCacheButton.height(48)
    }
    
    @objc func clearCache(){
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
    
}

extension SettingsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        let title = Array(options.keys).sorted()[indexPath.row]
        guard let key = options[title] else {return cell }
        cell.configure(title: title, key: key)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
}

extension SettingsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}


