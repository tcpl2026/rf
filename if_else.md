# if else

## Run Keyword If

Robot Framework 4.0后有IF/ELSE语句了，Run Keyword If不需要使用了，直接用IF语句

这个例子是当asus路由器的语言不是英文时切到英文

```
*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${ap_model}       tuf-ax3000
${ap_url}         http://192.168.50.1
${ap_user}        admin
${ap_password}    12345678
${browser}        Chrome

*** Test Cases ***
switch asus router to english language
    login asus router
    logout asus router

*** Keywords ***
switch to english
    Mouse Over                             id:selected_lang
    Click Element                          xpath: //*[contains(text(), "English")]
    Sleep                                  5s

login asus router
    Open Browser                           url=${ap_url}                                browser=${browser}
    Maximize Browser Window
    Wait Until Page Contains Element       id:login_username
    Input Text                             id:login_username                            ${ap_user}
    Input Password                         name:login_passwd                            ${ap_password}
    IF                                     '${ap_model}' == 'rt-ax88u'
                                           Click Element                                class:button
    ELSE IF                                '${ap_model}' == 'tuf-ax3000'
                                           Click Element                                xpath://*[@id="button"]
    END
    Wait Until Page Contains Element       id:NM_connect_title

    ${language}                            Get Text                                     id:selected_lang
    Log                                    ${language}
    Run Keyword If                         '${language}' != 'English'                   switch to english

logout asus router
    Click Element                         xpath: //*[contains(text(), "Logout")]
    Close Browser
```

## IF

```
*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${ap_model}       tuf-ax3000
${ap_url}         http://192.168.50.1
${ap_user}        admin
${ap_password}    12345678
${browser}        Chrome

*** Test Cases ***
switch asus router to english language
    login asus router
    logout asus router

*** Keywords ***
switch asus router language to english
    Mouse Over                             id:selected_lang
    Click Element                          xpath: //*[contains(text(), "English")]
    Sleep                                  5s

login asus router
    Open Browser                           url=${ap_url}                                browser=${browser}
    Maximize Browser Window
    Wait Until Page Contains Element       id:login_username
    Input Text                             id:login_username                            ${ap_user}
    Input Password                         name:login_passwd                            ${ap_password}
    IF                                     '${ap_model}' == 'rt-ax88u'
                                           Click Element                                class:button
    ELSE IF                                '${ap_model}' == 'tuf-ax3000'
                                           Click Element                                xpath://*[@id="button"]
    END
    Wait Until Page Contains Element       id:NM_connect_title

    ${language}                            Get Text                                     id:selected_lang
    Log                                    ${language}
    IF                                     '${language}' != 'English'
                                           Mouse Over                                   id:selected_lang
                                           Click Element                                xpath: //*[contains(text(), "English")]
                                           Sleep                                        5s
    END
                       
logout asus router
    Click Element                         xpath: //*[contains(text(), "Logout")]
    Close Browser
```

## IF语句的条件表达式

```
支持常见的比较运算符（如 ==, !=, >, <, >=, <=）。

支持逻辑运算符（如 and, or, not）
```

