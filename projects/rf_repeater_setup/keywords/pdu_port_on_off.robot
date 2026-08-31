*** Settings ***
Library     SeleniumLibrary
Resource    ../variables/variables.robot

*** Keywords ***
Login PDU
    Open Browser    url=${PDU_URL}    browser=${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    id:userName
    Input Text    id:userName    ${PDU_USER}
    Input Password    id:password    ${PDU_PWD}
    Click Element    id:btn1
    Wait Until Page Contains Element    id:HPSpan
    Sleep    1s

Logout PDU
    Click Element    id:userInfo
    Click Element    id:logout
    Wait Until Page Contains Element    id:userName
    Close Browser

Turn On PDU Port
    [Arguments]    ${PORT}
    ${PORT_STATUS}=    Get Text    id:sockSta${PORT}
    Log    ${PORT_STATUS}
    IF    "ON" not in "${PORT_STATUS}"
        Click Element    id:sockSta${PORT}
        Sleep    1s
        ${PORT_STATUS}=    Get Text    id:sockSta${PORT}
        Log    ${PORT_STATUS}
        Should Contain    ${PORT_STATUS}    ON
    END

Turn Off PDU Port
    [Arguments]    ${PORT}
    ${PORT_STATUS}=    Get Text    id:sockSta${PORT}
    Log    ${PORT_STATUS}
    IF    "OFF" not in "${PORT_STATUS}"
        Click Element    id:sockSta${PORT}
        Sleep    1s
        ${PORT_STATUS}=    Get Text    id:sockSta${PORT}
        Log    ${PORT_STATUS}
        Should Contain    ${PORT_STATUS}    OFF
    END
    
    
