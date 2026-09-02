*** Settings ***
Resources    ../variables/variables.robot

*** Keywords ***
Login ASUS AP
    Open Browser    url=${AP_URL}    browser=${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    id:login_username
    Input Text    id:login_username    ${AP_USER}
    Input Password    name:login_passwd     ${AP_PWD}
    TRY
        Click Element    class:button
    EXCEPT
        Click Element    xpath://*[@id="button"]
    EXCEPT
        Log    Login ASUS AP failed
    END

    Wait Until Page Contains Element    id:NM_connect_title

    Set Language To English

Set Language To English
    ${language}    Get Text    id:selected_lang
    Log    ${language}
    IF    '${language}' != 'English'
        Mouse Over    id:selected_lang
        Sleep    1s
        Click Element    xpath: //*[contains(text(), "English")]
        Sleep    3s
    END

Logout ASUS AP
    Click Element                         xpath: //*[contains(text(), "Logout")]
    Close Browser 

Go To Wireless General Page
    Click Element                                 id:Advanced_Wireless_Content_menu
    Wait Until Page Contains Element              name:wl_unit

Go To Wireless Professional Page
    Go To Wireless General Page
    Click Element                                 id:Advanced_WAdvanced_Content_tab
    Wait Until Page Contains Element              name:wl_unit

Set Band
    [Documentation]    0:2g, 1:5g
    [Arguments]    ${band}                         
    ${currentband}=    Get Selected List Label    name:wl_unit
    IF    '${band}' == '2g'
        IF    '${currentband}' != '2.4 GHz'
            Select From List By Value    name:wl_unit    0
            Reload Page
            Wait Until Page Contains Element    name:wl_unit
        END
    ELSE IF    '${band}' == '5g'
        IF    '${currentband}' != '5 GHz'
            Select From List By Value    name:wl_unit    1
            Reload Page
            Wait Until Page Contains Element    name:wl_unit
        END
    END

Set SSID
    [Arguments]    ${ssid}
    Input Text    id:wl_ssid    ${ssid}

Apply Settings
    Click Button    xpath://input[@value="Apply"]
    TRY
        Handle Alert    action=ACCEPT    timeout=0.5 s
    EXCEPT
        Log    No alert box
    END
    TRY
        Handle Alert    action=ACCEPT    timeout=0.5 s
    EXCEPT
        Log    No alert box
    END
    Sleep    0.5s
    Wait Until Element Is Not Visible    xpath://span[contains(text(),'Applying Settings')]    timeout=30
    Sleep    3s

