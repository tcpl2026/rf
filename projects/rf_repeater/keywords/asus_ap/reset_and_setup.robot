*** Settings ***
Resources    ../../variables/variables.robot
Resources    common.robot

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
    IF                                            '${ap_model}' == 'rt-ax88u'
                                                  Click Element                                 xpath: //*[contains(text(), "WAN Port")]
    Sleep                                         0.5s
    END
    Click Element                                 xpath: //*[contains(text(), "Automatic IP")]
    Sleep                                         0.5s
    Click Element                                 xpath: //*[contains(text(), "Separate 2.4 GHz and 5 GHz")]
    Sleep                                         1s
    Input Text                                    id:wireless_ssid_0           ${ssid_2g}
    Input Password                                id:wireless_key_0            ${passphrase}
    Input Text                                    id:wireless_ssid_1           ${ssid_5g}
    Input Password                                id:wireless_key_1            ${passphrase}
    Sleep                                         1s
    Click Element                                 //*[@class='desktop_applyBtn btn_wireless_apply']
    Sleep                                         1s
    Input Text                                    id:http_username             ${ap_user}
    Input Password                                id:http_passwd               ${ap_password}
    Input Password                                id:http_passwd_confirm       ${ap_password}
    Click Element                                 //*[@class='desktop_applyBtn btn_login_apply']      
    Sleep                                         1s
    Handle Alert 	                          action=ACCEPT

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
        ${output}=    Page Should Contain Element    id:login_username
        Log    ${output}
        IF    '${output}' == 'None'
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

