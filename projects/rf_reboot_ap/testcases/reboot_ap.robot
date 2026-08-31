*** Settings ***
Library    SeleniumLibrary

Resource    ../variables/variables.robot

*** Test Cases ***
Reboot AP Repeatly
    FOR    ${i}    IN RANGE    10000
        TRY
            Log To Console    \nThis is the ${i} time reboot
            Reboot XiaomiR4
            Reboot XiaomiAX6000
            Reboot R300
            Reboot XDR1860
        EXCEPT
            Log To Console    ignore error, continue trying
            Close All Browsers
        END
        Sleep    120s
    END

*** Keywords ***
Reboot XiaomiR4
    Open Browser    ${XiaomiR4_LOGIN_URL}    Chrome
    Wait Until Page Contains Element    id:password
    Maximize Browser Window
    Input Password    id:password    ${XiaomiR4_LOGIN_PASSWORD}
    Press Keys    id:password    ENTER
    Sleep    5s
    Wait Until Page Contains Element    id:sysmenu
    Click Element    id:sysmenu
    Click Element    id:toReboot
    Click Button     id:rebootAction
    Click Element    xpath://*[@class='btn btn-primary']
    Sleep    5s
    Close Browser
    
Reboot XiaomiAX6000
    Open Browser    ${XiaomiAX6000_LOGIN_URL}    Chrome
    Wait Until Page Contains Element    id:password
    Maximize Browser Window
    Input Password    id:password    ${XiaomiAX6000_LOGIN_PASSWORD}
    Press Keys    id:password    ENTER
    Sleep    5s
    Wait Until Page Contains Element    id:sysmenu
    Click Element    id:sysmenu
    Click Element    id:toReboot
    Click Button     id:rebootAction
    Click Element    xpath://*[@class='btn btn-primary']
    Sleep    5s
    Close Browser
    
Reboot R300
    Open Browser    ${R300_LOGIN_URL}    Chrome
    #Wait Until Page Contains Element    id:psd
    Maximize Browser Window
    #Input Password    id:psd    ${R300_LOGIN_PASSWORD}
    #Click Button    id:login
    #Sleep    5s
    Wait Until Page Contains Element    id:reboot2_img
    Click Element    id:reboot2_img
    Sleep    1s
    Click Element    xpath=//*[@onclick='tijiao();']
    Sleep    5s
    Close Browser

Reboot XDR1860
    Open Browser    ${XDR1860_LOGIN_URL}    Chrome
    Wait Until Page Contains Element    id:lgPwd
    Maximize Browser Window
    Input Password    id:lgPwd    ${XDR1860_LOGIN_PASSWORD}
    Click Button    id:loginSub
    Sleep    5s
    Wait Until Page Contains Element    id:routerSetMbtn
    Click Element    id:routerSetMbtn
    Wait Until Page Contains Element    id:reBootSet_rsMenu
    Scroll Element Into View    id:reBootSet_rsMenu
    Click Element    id:reBootSet_rsMenu
    Wait Until Page Contains Element    id:rebootAll
    Click Element    id:rebootAll
    Wait Until Page Contains Element    id:hsConf
    Click Element    xpath://*[@class='subBtn ok']
    Sleep    5s
    Close Browser
