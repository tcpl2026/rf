# asus router的操作

## seleniumlibrary: 处理applying

```
Wait Until Page Does Not Contain              \% Applying Settings                                   timeout=30

Wait Until Element Is Not Visible             xpath://span[contains(text(),'Applying Settings')]     timeout=30
```

```
设置应用后点击applying，有时出现百分号进度，有时候仅出现一个Applying Settings
例如10% Applying Settings或者Applying Settings

如果只出现百分之多少Applying Settings，那么这么处理是可以的:
Wait Until Page Does Not Contain              \% Applying Settings            timeout=30

先出现Applying Settings，又跳到百分之比的Applying Settings，用下面的方法处理。
这个页面有个div tag也包含了字符Applying Settings，xpath限制span tag
Click Button                                   id:applyButton
Sleep                                          0.5s
Wait Until Element Is Not Visible              xpath://span[contains(text(),'Applying Settings')]    timeout=30

使用这个关键字应该也可以，还没试
Wait Until Page Does Not Contain Element       xpath://span[contains(text(),'Applying Settings')]    timeout=30
```

## seleniumlibrary: Wait Until Element Is Not Visible 和 Wait Until Page Does Not Contain Element的区别

```
Wait Until Element Is Not Visible
Visibility check，元素还可能在页面中，只是不可见了
deals with whether an element is still on the screen or not, regardless of whether it's present in the DOM.

Wait Until Page Does Not Contain Element
Existence check is more about whether the element is present in the DOM at all.
```
