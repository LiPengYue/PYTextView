# PYTextView

[![CI Status](https://img.shields.io/travis/LiPengYue/PYTextView.svg?style=flat)](https://travis-ci.org/LiPengYue/PYTextView)
[![Version](https://img.shields.io/cocoapods/v/PYTextView.svg?style=flat)](https://cocoapods.org/pods/PYTextView)
[![License](https://img.shields.io/cocoapods/l/PYTextView.svg?style=flat)](https://cocoapods.org/pods/PYTextView)
[![Platform](https://img.shields.io/cocoapods/p/PYTextView.svg?style=flat)](https://cocoapods.org/pods/PYTextView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

PYTextView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PYTextView'
```

## Author

LiPengYue, 15076299703@163.com

## License

# 属性：

```
/// 向下滑动，关闭编辑
open var isDownScrollEndEdit: Bool = false

/// 下拉多少时候需要关闭编辑
open var pullDownMarginEndEdit: CGFloat = 10

/// 可以输入的最大字数 如果小于 0那么不再制约输入字数
open var maxNumberOfWords = -1
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
```
# 方法 
```
/// 设置底部剩余输入字数的 描述
///
/// - surplusCount: 剩余字数
/// - maxNumberOfWords: 总数

open func setBottomDescreptionFunc(_ setBottomDescreptionCallBack:((_ surplusCount: NSInteger, _ maxNumberOfWords: NSInteger)->(NSAttributedString))?) {
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
```
