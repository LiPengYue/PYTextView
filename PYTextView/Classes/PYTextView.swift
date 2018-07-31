//
//  LPYTextView.swift
//  FBSnapshotTestCase
//
//  Created by 李鹏跃 on 2018/7/30.
//

import UIKit

/// textView
open class PYTextView: UIView, UITextViewDelegate {
    
    /// 最大字符
    open var maxWords: NSInteger = -1
    
    /// 向下滑动，关闭编辑
    open var isDownScrollEndEdit: Bool = false
    /// 下拉多少时候需要关闭编辑
    open var pullDownMarginEndEdit: CGFloat = 10
    
    ///placeholder
    open var placeholder = "写几句评论吧..." {
        didSet{ placeholderLabel.text = placeholder } }
    open var placeholderColor: UIColor? { didSet { placeholderLabel.textColor = placeholderColor ?? c_0x333333() } }
    open var placeholderFont = UIFont.systemFont(ofSize: 14) { didSet { placeholderLabel.font = placeholderFont } }
    ///font
    open var font: UIFont = UIFont.systemFont(ofSize: 14) { didSet { textView.font = font } }
    ///text
    open var text: String {
        get{ return textView.text }
        set{ setText(text: newValue) }
    }
    open var textColor: UIColor? {
        didSet {
            textView.textColor = textColor ?? c_0x333333()
        }
    }
    ///剩余 数字书描述的 边距
    open var remainWordsLabelEdg: UIEdgeInsets = .zero { didSet { layoutRemainWords() } }
    
    /// placeholder 边距
    open var placeholderLabelEdg: UIEdgeInsets = UIEdgeInsets.init(
        top: 0,
        left: 8,
        bottom: 0,
        right: 0)
        { didSet { layoutPlaceholder() }}
    
    ///textView的边距
    open var textContainerInset: UIEdgeInsets = .zero { didSet { didSetTextContainerInset() } }
    
    ///设置底部的剩余输入字数描述 字符
    var setBottomDescreptionCallBack:((_ surplusCount: NSInteger, _ maxWords: NSInteger)->(NSAttributedString))?
    ///已经改变的时候调用
    var changedTextCallBack: ((_ textView: UITextView, _ text: String)->())?
    var txtRemarkDidEndEditingCallBack: ((_ textView: UITextView, _ text: String)->())?
    var reachTheMaximumNumberOfWords: ((_ textView: UITextView,_ maxNumber: NSInteger)->())?
    
    /// 设置底部剩余输入字数的 描述
    ///
    /// - surplusCount: 剩余字数
    /// - maxWords: 总数
    
    open func setBottomDescreptionFunc(_ setBottomDescreptionCallBack:((_ surplusCount: NSInteger, _ maxWords: NSInteger)->(NSAttributedString))?) {
        self.setBottomDescreptionCallBack = setBottomDescreptionCallBack
    }
    
    /// 已经改变text的时候
    ///
    /// - Parameter willChangeTextCallBack:
    /// - crrentText:  textView 没有拼接新字符
    /// - willText: textView 拼接新字符
    /// - text: 新输入的字符
    open func changedTextFucn (_ changedTextCallBack:((_ textView: UITextView, _ text: String)->())?) {
        self.changedTextCallBack = changedTextCallBack
    }
    
    
    /// 已经结束编辑的时候
    ///
    /// - Parameter willChangeTextCallBack:
    /// - crrentText:  textView 没有拼接新字符
    /// - willText: textView 拼接新字符
    /// - text: 新输入的字符
    open func didEndEditingFunc (_ changedTextCallBack:((_ textView: UITextView, _ text: String)->())?) {
        self.txtRemarkDidEndEditingCallBack = changedTextCallBack
    }
    
    /// 输入字数到达最大值的时候调用
    ///
    /// - Parameter block: 回调
    open func reachTheMaximumNumberOfWordsFunc(_ block:((_ textView: UITextView,_ maxNumber: NSInteger)->())?) {
        reachTheMaximumNumberOfWords = block
    }
    
    public override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 关于配置
    ///设置
    private func setup() {
        setupView()
        setupNotification()
    }
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keybordChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(txtRemarkEditChanged), name: NSNotification.Name.UITextViewTextDidChange, object: self.textView)
        NotificationCenter.default.addObserver(self, selector: #selector(txtRemarkDidEndEditing), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self.textView)
    }
    var placeholderLeft: NSLayoutConstraint?
    var placeholderRight: NSLayoutConstraint?
    var placeholderTop: NSLayoutConstraint?
    var placeholderBottom: NSLayoutConstraint?
    
    var remainWordsLeft: NSLayoutConstraint?
    var remainWordsRight: NSLayoutConstraint?
    var remainWordsTop: NSLayoutConstraint?
    var remainWordsBottom: NSLayoutConstraint?
    
    private func setupView() {
        addSubview(textView)
        addSubview(placeholderLabel)
        addSubview(remainWordsLabel)
        textView.edgsEqual(toItem: self, offset: 0)
        layoutPlaceholder()
        layoutRemainWords()
    }
    
    private func layoutPlaceholder() {
        if let placeholderLeft = placeholderLeft,
            let placeholderRight = placeholderRight,
            let placeholderBottom = placeholderBottom,
            let placeholderTop = placeholderTop{
            
            self.removeConstraint(placeholderLeft)
            self.removeConstraint(placeholderRight)
            self.removeConstraint(placeholderBottom)
            self.removeConstraint(placeholderTop)
        }
        
        let left =  textContainerInset.left + placeholderLabelEdg.left
        let right = -textContainerInset.right - placeholderLabelEdg.right
        let top = textContainerInset.top + placeholderLabelEdg.top
        let bottom = -textContainerInset.bottom - placeholderLabelEdg.bottom
        
        placeholderLeft = placeholderLabel.leftEqual(toItem: self, offset: left)
        placeholderRight = placeholderLabel.rightEqual(toItem: self, offset: right)
        
        placeholderTop = placeholderLabel.topEqual(toItem: self, offset: top)
        placeholderBottom = placeholderLabel.bottomLessThanOrEqual(toItem: self, offset: bottom)
        self.updateConstraints()
    }
    
    private func layoutRemainWords() {
        if let remainWordsLeft = remainWordsLeft,
            let remainWordsRight = remainWordsRight,
            let remainWordsBottom = remainWordsBottom,
            let remainWordsTop = remainWordsTop{
            
            self.removeConstraint(remainWordsLeft)
            self.removeConstraint(remainWordsRight)
            self.removeConstraint(remainWordsBottom)
            self.removeConstraint(remainWordsTop)
        }
        
        let left =  textContainerInset.left + remainWordsLabelEdg.left
        let right = -textContainerInset.right - remainWordsLabelEdg.right
        //        let top = textContainerInset.top + remainWordsLabelEdg.top
        let bottom = -textContainerInset.bottom - remainWordsLabelEdg.bottom
        
        remainWordsLeft = remainWordsLabel.leftLessThanOrEqual(toItem: self, offset: left)
        remainWordsRight = remainWordsLabel.rightEqual(toItem: self, offset: right)
        
        //        remainWordsTop = remainWordsLabel.topLessThanOrEqual(toItem: self, offset: top)
        remainWordsBottom = remainWordsLabel.bottomEqual(toItem: self, offset: bottom)
        self.updateConstraints()
    }
    private func didSetTextContainerInset() {
        textView.textContainerInset = textContainerInset
        layoutPlaceholder()
        layoutRemainWords()
    }
    
    private var isFirst: Bool = true
    override open func layoutSubviews() {
        if isFirst {
            var surplusCount = (maxWords - textView.text.count)
            surplusCount = surplusCount <= 0 ? 0 : surplusCount
            surplusCount = surplusCount >= maxWords ? maxWords : surplusCount
            remainWordsLabel.attributedText = setBottomDescreptionCallBack?(surplusCount,maxWords)
            textView.backgroundColor = self.backgroundColor
            isFirst = false
        }
    }
    //MARK: - Notification
    /// 已经改变的时候调用
    @objc private func txtRemarkEditChanged(notif: Notification) {
        guard let textView: UITextView = notif.object as? UITextView else { return }
        
        placeholderLabel.isHidden = textView.text.count > 0
        
        let length = textView.text.count
        let range = NSRange.init(location: length - 1, length: 1)
        textView.scrollRangeToVisible(range)
        
        if (maxWords >= 0
            && length > maxWords
            && (textView.markedTextRange == nil)) {
            
            textView.text = NSString(string: textView.text).substring(with: NSRange.init(location: 0, length: maxWords))
            remainWordsLabel.attributedText = setBottomDescreptionCallBack?(0,maxWords)
            textView.undoManager?.removeAllActions()
            
        } else if (textView.markedTextRange == nil) {
            var length = (maxWords - textView.text.count)
            length = length < 0 ? 0 : length
            remainWordsLabel.attributedText = setBottomDescreptionCallBack?( length,maxWords)
        }
        
        changedTextCallBack?(textView,textView.text)
    }
    @objc private func txtRemarkDidEndEditing(notif: Notification) {
        if let textView = notif.object as? UITextView {
            placeholderLabel.isHidden = textView.text.count > 0
            txtRemarkDidEndEditingCallBack?(textView,textView.text)
        }
    }
    @objc private func keybordChange(notification:Notification)  {
        
        let userinfo: NSDictionary = notification.userInfo! as NSDictionary
        
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        
        let keyboardRec = nsValue.cgRectValue
        let y = keyboardRec.origin.y
        //获取textview 在window的y + h
        let view = UIApplication.shared.keyWindow ?? self
        let pointToWindow = convert(textView.frame, to: view)
        let maxY = self.textView.frame.size.height + pointToWindow.origin.y
        var margin = maxY - y
        margin = margin <= 0 ? 0 : margin
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: margin, right: 0)
    }
    var panPointStart: CGPoint = .zero
    var panPoint: CGPoint = .zero
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let state = textView.panGestureRecognizer.state
            switch state {
                
            case .possible:fallthrough
            case .began:
                panPointStart = textView.contentOffset
            case .changed:fallthrough
            case .cancelled:fallthrough
            case .failed:fallthrough
            case .ended: break
            }
            
            if (textView.contentOffset.y - panPointStart.y) < -pullDownMarginEndEdit {
                
                self.endEditing(true)
            }
        }
        
        //        }
    }
    
    
    //MARK: - property
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        
        textView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        return textView
    }()
    ///懒加载 还可以输入 x 个字
    lazy var remainWordsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.attributedText = self.setBottomDescreptionCallBack?(maxWords,maxWords)
        label.textColor = UIColor.init(red: 51.0/225,
                                       green: 51.0/225,
                                       blue: 51.0/225,
                                       alpha: 1)
        label.textAlignment = .right
        return label
    }()
    ///懒加载 写几句评论吧...
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = self.placeholder
        label.textColor = UIColor(red: 204.0 / 255.0,
                                  green: 204.0 / 255.0,
                                  blue: 204.0 / 255.0,
                                  alpha: 1.0)
        label.textAlignment = .left
        return label
    }()
    
    private func setText(text: String) {
        textView.text = text
        placeholderLabel.isHidden = true
        var surplusCount = (maxWords - text.count)
        surplusCount = surplusCount <= 0 ? 0 : surplusCount
        surplusCount = surplusCount >= maxWords ? maxWords : surplusCount
        remainWordsLabel.attributedText = setBottomDescreptionCallBack?(surplusCount,maxWords)
        changedTextCallBack?(textView,text)
    }
    
    private func c_0x333333() -> UIColor {
        return UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        textView.removeObserver(self, forKeyPath: "contentOffset")
    }
}


private extension UIView {
    func leftEqual(toItem:UIView,offset: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint.init(
            item: self,
            attribute: .left,
            relatedBy: .equal,
            toItem: toItem,
            attribute: .left,
            multiplier: 1,
            constant: offset
        )
        toItem.addConstraint(left)
        return left
    }
    
    func rightEqual(toItem:UIView,offset: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let right = NSLayoutConstraint.init(
            item: self,
            attribute: .right,
            relatedBy: .equal,
            toItem: toItem,
            attribute: .right,
            multiplier: 1,
            constant: offset
        )
        toItem.addConstraint(right)
        return right
    }
    
    func topEqual(toItem:UIView,offset: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint.init(
            item: self,
            attribute: .top,
            relatedBy: .equal,
            toItem: toItem,
            attribute: .top,
            multiplier: 1,
            constant: offset
        )
        toItem.addConstraint(top)
        return top
    }
    func bottomEqual(toItem:UIView,offset: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let bottom = NSLayoutConstraint.init(
            item: self,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: toItem,
            attribute: .bottom,
            multiplier: 1,
            constant: offset
        )
        toItem.addConstraint(bottom)
        return bottom
    }
    func bottomLessThanOrEqual(toItem: UIView, offset: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let bottom = NSLayoutConstraint.init(
            item: self,
            attribute: .bottom,
            relatedBy: .lessThanOrEqual,
            toItem: toItem,
            attribute: .bottom,
            multiplier: 1,
            constant: offset
        )
        toItem.addConstraint(bottom)
        return bottom
    }
    
    func topLessThanOrEqual(toItem: UIView, offset: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint.init(
            item: self,
            attribute: .top,
            relatedBy: .lessThanOrEqual,
            toItem: toItem,
            attribute: .top,
            multiplier: 1,
            constant: offset
        )
        toItem.addConstraint(top)
        return top
    }
    
    func leftLessThanOrEqual(toItem: UIView, offset: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint.init(
            item: self,
            attribute: .left,
            relatedBy: .lessThanOrEqual,
            toItem: toItem,
            attribute: .left,
            multiplier: 1,
            constant: offset
        )
        toItem.addConstraint(left)
        return left
    }
    
    func edgsEqual(toItem: UIView, offset: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        let _ = leftEqual(toItem: toItem, offset: offset)
        let _ = rightEqual(toItem: toItem, offset: -offset)
        let _ = bottomEqual(toItem: toItem, offset: -offset)
        let _ = topEqual(toItem: toItem, offset: offset)
    }
}




