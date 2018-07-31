//
//  ViewController.swift
//  PYTextView
//
//  Created by LiPengYue on 07/30/2018.
//  Copyright (c) 2018 LiPengYue. All rights reserved.
//

import UIKit
import PYTextView
class ViewController: UIViewController {
    private lazy var textView: PYTextView = {
        let textView = PYTextView.init(frame: .zero)
        textView.placeholderFont = UIFont.systemFont(ofSize: 17)
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.isDownScrollEndEdit = true 
        textView.placeholder = "请写出您对本产品的意见或看法（120字以内）"
        textView.textContainerInset = UIEdgeInsets.init(
            top: 17,
            left: 17,
            bottom: 0,
            right: 17
        )
        
        textView.placeholderLabelEdg = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        textView.setBottomDescreptionFunc({ (index, maxIndex) -> (NSAttributedString) in
            let countStr = "\(index)"
            
            let str = "还可以输入个字"
            
            let attributedstr: NSMutableAttributedString = NSMutableAttributedString.init(string: str)
            attributedstr.addAttribute(
                NSAttributedStringKey.foregroundColor,
                value: UIColor.gray,
                range:
                NSRange.init(location: 0, length: attributedstr.length)
            )
            
            
            let attributedStr_count: NSMutableAttributedString = NSMutableAttributedString.init(string: countStr)
            
            let range = NSRange.init(location: 0, length: countStr.count)
            attributedStr_count.addAttribute(
                NSAttributedStringKey.foregroundColor,
                value: UIColor.red,
                range: range)
            
            attributedstr.insert(attributedStr_count, at: 5)
            
            return attributedstr
        })
        textView.maxWords = 1200
        textView.backgroundColor = UIColor.white
        return textView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        
        textView.frame = CGRect.init(x: 10, y: 80, width: view.frame.width-20, height: view.frame.height-500)
        view.backgroundColor = UIColor.gray
        textView.changedTextFucn { (textView, str) in
            print(str)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
