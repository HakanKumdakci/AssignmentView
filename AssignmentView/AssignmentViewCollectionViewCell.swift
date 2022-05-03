//
//  AssignmentViewCollectionViewCell.swift
//  AssignmentView
//
//  Created by Hakan Kumdakçı on 1.05.2022.
//

import UIKit
import TinyConstraints
import SDWebImage

class AssignmentViewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AssignmentViewCollectionViewCell"
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var progressView: CircleProgress = {
        let progressView = CircleProgress()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        //contentView.addSubview(view)
        contentView.addSubview(imageView)
        imageView.addSubview(progressView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.centerXToSuperview()
        imageView.bottomToSuperview()
        imageView.topToSuperview()
        imageView.width(self.contentView.frame.height)
        
        progressView.centerXToSuperview()
        progressView.centerYToSuperview()
        progressView.width(54)
        progressView.height(54)
        
    }
    
    public func configure(with urlString: String){
        
        guard let url = URL(string: urlString) else {return }
        
        progressView.startLoading()
        progressView.isHidden = false
        
        var options:SDWebImageOptions = [.progressiveLoad]
        
        if UserDefaults.standard.bool(forKey: "DownloadPriority"){
            if urlString.split(separator: "-")[1] == "5mb.png" || urlString.split(separator: "-")[1] == "3mb.png"{
                options = [.progressiveLoad, .lowPriority, .scaleDownLargeImages]
            }else{
                options = [.progressiveLoad, .highPriority]
            }
        }
        
        let start = CFAbsoluteTimeGetCurrent()
        imageView.sd_setImage(with: url, placeholderImage: nil, options: options) { _, _, _ in
            DispatchQueue.main.async {
                self.progressView.progress = self.imageView.sd_imageProgress.fractionCompleted
            }
        } completed: { _, error, _, _ in
            if error != nil {
                self.progressView.isHidden = false
                return
            }
            DispatchQueue.main.async {
                let diff = CFAbsoluteTimeGetCurrent() - start
                let m = Double(round(100000 * diff) / 100000)
                print("Took \(m) seconds")
                self.progressView.isHidden = true
            }
            //TODO: payload belirle
            NetworkingService.shared.sendLog(payLoad: [:])
            
            
        }
    }
}



