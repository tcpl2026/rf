*** Settings ***
Resources    ../variables/variables.robot
Resources    asus_router_config.robot

*** Keywords ***
Reset ASUS Router
    Click Element                                 id:Advanced_OperationMode_Content_menu
    Wait Until Page Contains Element              id:Advanced_SettingBackup_Content_tab
    Click Element                                 id:Advanced_SettingBackup_Content_tab
    Wait Until Page Contains Element              id:restoreInit
    Select Checkbox                               id:restoreInit
    Click Element                                 name:action1
    Sleep                                         1s
    Handle Alert 	                          action=ACCEPT
    Wait Until Page Contains Element              id:welcomeTitle                               timeout=120

Setup ASUS Router
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

set 2g 20m ch1 5g 80m ch36
    goto wireless general page
    set band to 2g
    set bandwidth                                 20m
    set channel                                   1
    
    apply settings
    
    set band to 5g
    Unselect Checkbox                             id:enable_160mhz
    set channel                                   36/80

    apply settings

Reset And Setup ASUS Router
    Open Browser    url=${AP_URL}    browser=${BROWSER}
    Maximize Browser Window
    Sleep    1s
    TRY
        ${output}=    Page Should Contain Element    id:login_username
        Log    ${output}
        IF    '${output}' == 'None'
            Log    ASUS AP is not in factory default state, reset it firstly.
            Close Browser
            login asus router
            reset asus router
        END
    EXCEPT
        LOG    ASUS AP is already in factory default state, start to setup.
    END

    setup asus router
    set 2g 20m ch1 5g 80m ch36
    
    logout asus router

    asus router enable ssh server

