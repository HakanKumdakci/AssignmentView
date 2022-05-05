

import UIKit

class SettingsTableViewCell: UITableViewCell {
        
    var indexPath: IndexPath?
    
    var key: String = ""
    
    static let identifier = "SettingsTableViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Avenir-Roman", size: 16)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    lazy var switchButton: UISwitch! = {
        let m = UISwitch()
        m.tintColor = UIColor.red
        m.onTintColor = UIColor.green
        m.addTarget(self, action: #selector(actionSwitch), for: .valueChanged)
        return m
    }()
    
    @objc func actionSwitch(){
        print(switchButton.isOn, key)
        UserDefaults.standard.set(switchButton.isOn, forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchButton)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switchButton.trailingToSuperview(offset: 32)
        switchButton.height(48)
        switchButton.width(48)
        switchButton.centerYToSuperview()
        
        titleLabel.leadingToSuperview(offset: 32)
        titleLabel.topToSuperview()
        titleLabel.bottomToSuperview()
        titleLabel.trailingToLeading(of: switchButton, offset: -8)
    }
    
    public func configure(title: String, key: String){
        self.key = key
        titleLabel.text = title
        switchButton.setOn(UserDefaults.standard.bool(forKey: key), animated: true)
    }
    
    
    
}

