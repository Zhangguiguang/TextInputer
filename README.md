# TextInputer

这个库统一扩展了系统自带的 `UITextView` 和 `UITextField`，提供了两个类`GGTextView` 和 `GGTextField`, 扩展了如下的功能

> 继承关系  
> class GGTextView: UIView  
> class GGTextField: UITextField

- `padding`: 可设置文本与边界的内边距
- `lengthLimit`: 可限制文本输入长度
- `regexString`: 可用正则表达式，限制文本输入内容
- `borderNormalColor`: 普通状态的边框颜色
- `borderFocusedColor`: 高亮状态的边框颜色
- `placeholderLabel`: 文本占位符



### English
`TextInputer` extends the built-in `UITextView` and `UITextField`. Provides two classes `GGTextView` and `GGTextField`, extending the following functions

> Inheritance  
> class GGTextView: UIView  
> class GGTextField: UITextField

- `padding`: the padding of text and borders
- `lengthLimit`: limit the length of text input
- `regexString`: use regular expressions to limit text input
- `borderNormalColor`: border color in normal state
- `borderFocusedColor`: border color of the highlighted state
- `placeholderLabel`: text placeholder



### Installation

#### Swift Package Manager
* File > Swift Packages > Add Package Dependency
* Add `https://github.com/Zhangguiguang/TextInputer.git`
* Select "Up to Next Major" with "1.0.0"



### Usage

```swift
import TextInputer

let inputer = GGTextView()
or
let inputer = GGTextField()

inputer.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
inputer.borderNormalColor = .gray
inputer.borderFocusedColor = .orange
inputer.lengthLimit = 100
inputer.regexString = "^(0x)?[a-fA-F0-9]{0,100}$" // is hex number
inputer.placeholderLabel?.text = "Create good memories today, so that you can have a good past"

```
