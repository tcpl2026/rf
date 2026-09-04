*** Settings ***
Resource    ../variables/variables.robot

*** Keywords ***
Reset ASUS AP
    Click Element                                 id:Advanced_OperationMode_Content_menu
    Wait Until Page Contains Element              id:Advanced_SettingBackup_Content_tab
    Click Element                                 id:Advanced_SettingBackup_Content_tab
    Wait Until Page Contains Element              id:restoreInit
    Select Checkbox                               id:restoreInit
    Click Element                                 name:action1
    Sleep                                         1s
    Handle Alert 	                          action=ACCEPT
    Wait Until Page Contains Element              id:welcomeTitle                               timeout=120

Setup ASUS AP
    Page Should Contain Element                   id:welcomeTitle
    set language to english

    Click Element                                 id:welcome_button
    Sleep                                         0.5s
    Click Element                                 id:desktop_manual_applyBtn
    Sleep                                         0.5s
    # for rt-ax88u
    TRY
                                                  Click Element                                 xpath: //*[contains(text(), "WAN Port")] 
                                                  Sleep                                         0.5s
    EXCEPT
                                                  Log    continue setting
    END
    Click Element                                 xpath: //*[contains(text(), "Automatic IP")]
    Sleep                                         0.5s
    Click Element                                 xpath: //*[contains(text(), "Separate 2.4 GHz and 5 GHz")]
    Sleep                                         1s
    Input Text                                    id:wireless_ssid_0           ${AP_2G_SSID}
    Input Password                                id:wireless_key_0            ${AP_PSK_KEY}
    Input Text                                    id:wireless_ssid_1           ${AP_5G_SSID}
    Input Password                                id:wireless_key_1            ${AP_PSK_KEY}
    Sleep                                         1s
    Click Element                                 //*[@class='desktop_applyBtn btn_wireless_apply']
    Sleep                                         1s
    Input Text                                    id:http_username             ${AP_USER}
    Input Password                                id:http_passwd               ${AP_PWD}
    Input Password                                id:http_passwd_confirm       ${AP_PWD}
    Click Element                                 //*[@class='desktop_applyBtn btn_login_apply']      
    Sleep                                         1s
    TRY
                                                  Handle Alert 	                          action=ACCEPT
    EXCEPT
                                                  Log    Continue setup
    END

    Wait Until Page Contains Element              id:NM_connect_title          timeout=60

ASUS AP Enable SSH Server
    Login ASUS AP

    Click Element                                 id:Advanced_OperationMode_Content_menu
    Wait Until Page Contains Element              id:Advanced_System_Content_tab
    Click Element                                 id:Advanced_System_Content_tab
    Wait Until Page Contains Element              id:sshd_enable_tr
    ${ssh_allowed}                                Get Selected List Label         name:sshd_enable
    Log                                           ${ssh_allowed}
    IF                                            '${ssh_allowed}' != 'LAN only'
                                                  Select From List By value       name:sshd_enable    2
                                                  Sleep                           1s
    END
    ${ssh_port}                                   Get Value                       id:sshd_port
    Log                                           ${ssh_port}
    IF                                            '${ssh_port}' != '22'
                                                  Input Text                      id:sshd_port    22
    END
                                                  
    Apply Settings

    Logout ASUS AP

Reset And Setup ASUS AP
    Open Browser    url=${AP_URL}    browser=${BROWSER}
    Maximize Browser Window
    Sleep    1s
    TRY
        ${count}=    Get Element Count    id:login_username
        IF    ${count} > 0
            Log    ASUS AP is not in factory default state, reset it firstly.
            Close Browser
            Login ASUS AP
            Reset ASUS AP
        END
    EXCEPT
        Log    ASUS AP is already in factory default state, start to setup.
    END

    Setup ASUS AP
    
    Logout ASUS AP

    ASUS AP Enable SSH Server

Login ASUS AP
    Open Browser    url=${AP_URL}    browser=${BROWSER}
    Maximize Browser Window
    Sleep    1s
    Wait Until Page Contains Element    id:login_username
    Input Text    id:login_username    ${AP_USER}
    Input Password    name:login_passwd     ${AP_PWD}
    TRY
        Click Element    class:button
    EXCEPT
        Log    click button failed, try another element
        TRY
            Click Element    xpath://*[@id="button"]
        EXCEPT
            Log    click button failed
        END
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

