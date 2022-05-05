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
    
    var mb: String = ""
    var imageSize: Double = 0
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var logLabel: UILabel! = {
        var lbl = UILabel(frame: .zero)
        lbl.text = ""
        lbl.font = UIFont(name: "Avenir-Heavy", size: 12)
        lbl.textAlignment = .center
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    lazy var progressView: CircleProgress = {
        let progressView = CircleProgress()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.addSubview(progressView)
        contentView.addSubview(logLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        logLabel.height(16)
        logLabel.leadingToSuperview()
        logLabel.trailingToSuperview()
        logLabel.bottomToSuperview(offset: -8)
        
        imageView.bottomToTop(of: logLabel, offset: -8)
        imageView.topToSuperview()
        imageView.leadingToSuperview()
        imageView.trailingToSuperview()
        
        progressView.centerXToSuperview()
        progressView.centerYToSuperview()
        progressView.width(54)
        progressView.height(54)
    }
    
    func setUpThumbnailSize(width: CGFloat, height: CGFloat) -> CGSize{
        let maxSize = 4096.0
        let scale = UIScreen.main.scale
        let widthModified = UserDefaults.standard.bool(forKey: "thumbnailImage") ? width : maxSize
        let heightModified = UserDefaults.standard.bool(forKey: "thumbnailImage") ? height : maxSize
        if !(UserDefaults.standard.bool(forKey: "thumbnailImage")){
            imageView.contentMode = .scaleAspectFill
        }
        return CGSize(width: widthModified * scale, height: heightModified * scale)
    }
    
    func setUpOptions(urlString: String) -> SDWebImageOptions{
        if UserDefaults.standard.bool(forKey: "DownloadPriority"){
            if urlString.split(separator: "-")[1] == "5mb.png" || urlString.split(separator: "-")[1] == "3mb.png"{
                return [.progressiveLoad,.lowPriority, .scaleDownLargeImages]
            }else{
                return [.progressiveLoad ,.highPriority]
            }
        }else{
            return [.progressiveLoad]
        }
    }
    
    public func configure(with urlString: String, width: CGFloat, height: CGFloat){
        
        guard let url = URL(string: urlString) else {return }
        
        imageView.sd_cancelCurrentImageLoad()
        
        if imageView.image != nil{
            return
        }
        
        progressView.startLoading()
        progressView.isHidden = false
                
        SDImageCoderHelper.defaultScaleDownLimitBytes = UInt(Int(width) * Int(height) * 4)

        let thumbnailSize = setUpThumbnailSize(width: width, height: height)
        
        let options:SDWebImageOptions = setUpOptions(urlString: urlString)
        let isCacheEnabled = UserDefaults.standard.bool(forKey: "regularCache")
        let start = CFAbsoluteTimeGetCurrent()
        imageView.sd_setImage(with: url, placeholderImage: nil, options: options, context: [.imageThumbnailPixelSize: thumbnailSize, .originalStoreCacheType: isCacheEnabled ? SDImageCacheType.all.rawValue : SDImageCacheType.memory.rawValue]) { _, _, _ in
            DispatchQueue.main.async {
                self.progressView.progress = self.imageView.sd_imageProgress.fractionCompleted
            }
        } completed: { image, error, _, _ in
            guard let image = image,
                  let data = image.pngData() else{return }
            if error != nil {
                self.progressView.isHidden = false
                return
            }
            var interval: Double = 0.0
            
            let diff = CFAbsoluteTimeGetCurrent() - start
            interval = Double(round(10000 * diff) / 10000)
            print("Took \(interval) seconds")
            self.progressView.isHidden = true
            
            let imgData = NSData(data: data)
            self.imageSize = (Double(imgData.count) / 1024.0)
            
            NetworkingService.shared.sendLog(payLoad: ["loadTime":interval]) { response in
                print(response.json.loadTime)
                DispatchQueue.main.async {
                    self.logLabel.text = "\(response.json.loadTime) "
                    let text = NSMutableAttributedString()
                    text.append(NSAttributedString(string: "\(response.json.loadTime) ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]));
                    text.append(NSAttributedString(string: "\(String(format: "%.f", self.imageSize))KB", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "D80000", alpha: 1.0), NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 12.0)!] ))
                    self.logLabel.attributedText = text
                }
            }
        }
    }
}



