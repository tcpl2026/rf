# SeleniumLibrary: keywords

## locating elements

### use id

case执行后浏览器自动关闭，可能是Selenium或Selenium Web drivers的行为

https://forum.robotframework.org/t/robot-framework-browser-automatically-shuts-down/5068/6

```
*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${url}           https://www.baidu.com/
${browser}       Chrome

*** Test Cases ***
access baidu
    Open Browser        url=${url}        browser=${browser}
    Input Text          id:kw             robotframework
```

## use xpath

```
*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${url}           https://www.baidu.com/
${browser}       Chrome

*** Test Cases ***
access baidu
    Open Browser        url=${url}                      browser=${browser}
    Input Text          xpath://*[@id="kw"]             robotframework
```
    

## Implicit XPath strategy

```
If the locator starts with // or multiple opening parenthesis in front of the //, 
the locator is considered to be an XPath expression. 
In other words, using //div is equivalent to using explicit xpath://div and ((//div)) is equivalent to using explicit xpath:((//div))
```

### Examples

```
Click Link    //a[contains(@href, ".csv")]
Click Link    //a[contains(@href, "Queries")]
Click Link    //a[contains(text(), "generated il")]
Click Link    //a[contains(text(), "Open file")]
```

```
https://stackoverflow.com/questions/45324287/how-do-i-use-click-element-function-with-robot-framework-when-the-element-does-n

I recommend to be a bit more flexible. 
The good approach if you find the balance between define flexible and unique. 
Otherwise the smallest site change will breake your test.

Following example should match on the previous example:

Match on any link that contain LOGIN text
Click Element       //a[contains(text(),'LOGIN')]

Match on any element that contain LOGIN text
Click Element       //*[contains(text(),'LOGIN')]

Match on any element where the class attribute equal with "transparentBtn loginLink ng-scope"
Click Element       //a[@class="transparentBtn loginLink ng-scope"]

You can check multiple attributes at the same time
Click Element       //a[@class='transparentBtn loginLink ng-scope' and @ng-click='commonService.gigyaRaasLogin()']

You can use contains() to check if string part of the class attribute
Click Element       //a[contains(@class,'loginLink')]
```
