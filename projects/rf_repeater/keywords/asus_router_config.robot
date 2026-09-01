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

Set Bandwidth
    [Documentation]    1:20MHz, 2:40MHz, 3:80MHz
    [Arguments]    ${bw}
    ${currentbandwidth}=    Get Selected List Label    name:wl_bw
    IF    '${bw}' == '20m'
        IF    '${currentbandwidth}' != '20MHz'
            Select From List By Value    name:wl_bw    1
        END
    ELSE IF    '${bw}' == '40m'
        IF    '${currentbandwidth}' != '40MHz'
            Select From List By Value    name:wl_bw    2
        END
    ELSE IF    '${bw}' == '80m'
        IF    '${currentbandwidth}' != '80MHz'
            Select From List By Value    name:wl_bw    3
        END
    END

Set Channel
    [Documentation]    2g: 1-13 5g:36-161, 20M:36, 40M:36l, 80M:36/80
    [Arguments]    ${channel}
    ${currentchannel}=    Get Selected List Value    name:wl_channel
    IF    '${currentchannel}' != '${channel}'
        Select From List By Value    name:wl_channel    ${channel}
    END

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

Enable WiFi6 Mode
    [Arguments]    ${band}
    Set Band    ${band}

    TRY
        ${wireless_mode}=    Get Selected List Label    name:wl_nmode_x
        Log    ${wireless_mode}
        IF    '${wireless_mode}' != 'Auto'
            Select From List By Value    name:wl_nmode_x    0
        END
    EXCEPT
        Select From List By Value    name:wl_nmode_x    0
    END

    ${wifi6_switch}=    Get Selected List Label    name:wl_11ax
    Log    ${wifi6_switch}
    IF    '${wifi6_switch}' != 'Enable'
        Select From List By Value    name:wl_11ax    1
    END

    Apply Settings

    ${wireless_mode}=    Get Selected List Label    name:wl_nmode_x
    ${wifi6_switch}=    Get Selected List Label    name:wl_11ax
    Log Many    ${wireless_mode}    ${wifi6_switch}
    Should Be Equal    ${wireless_mode}    Auto
    Should Be Equal    ${wifi6_switch}    Enable

asus router enable wifi6
    login asus router
    goto wireless general page

    enable wifi6 mode                             2g
    enable wifi6 mode                             5g

    logout asus router
    

asus router enable wifi5
    login asus router
    goto wireless general page

    set band to 5g

    TRY
                                                  ${wireless_mode}=            Get Selected List Label        name:wl_nmode_x
                                                  Log                          ${wireless_mode}
                                                  IF                           '${wireless_mode}' != 'Auto'
                                                                               Select From List By Value      name:wl_nmode_x                0
                                                  END
    EXCEPT
                                                  select From List By Value    name:wl_nmode_x                0
    END

    ${wifi6_switch}=                              Get Selected List Label      name:wl_11ax
    Log                                           ${wifi6_switch}
    IF                                            '${wifi6_switch}' == 'Enable'
                                                  Select From List By Value                     name:wl_11ax                   0
    END

    apply settings

    ${wireless_mode}=                             Get Selected List Label        name:wl_nmode_x
    ${wifi6_switch}=                              Get Selected List Label        name:wl_11ax
    Log Many                                      ${wireless_mode}               ${wifi6_switch}
    Should Be Equal                               ${wireless_mode}               Auto
    Should Be Equal                               ${wifi6_switch}                Disable

    logout asus router

asus router enable wifi4
    asus router enable ssh server
    Sleep                                         5s

    Open Connection                               ${ap_ip}
    Login                                         ${ap_user}                      ${ap_password}
    Execute Command                               nvram set wl0_nmode_x=1
    Execute Command                               nvram set wl1_nmode_x=1
    Execute Command                               nvram commit
    Execute Command                               service restart_wireless

    Close Connection

enable legacy mode
    [Arguments]                                   ${band}
    set band                                      ${band}

    TRY
                                                  ${wireless_mode}=                             Get Selected List Label        name:wl_nmode_x
                                                  Log                                           ${wireless_mode}
                                                  IF                                            '${wireless_mode}' != 'Legacy'
                                                                                                Select From List By Value      name:wl_nmode_x    2
                                                  END
    EXCEPT
                                                  Select From List By Value                     name:wl_nmode_x                2
    END

    apply settings

    ${wireless_mode}=                             Get Selected List Label        name:wl_nmode_x
    Log                                           ${wireless_mode}
    Should Be Equal                               ${wireless_mode}               Legacy

asus router enable legacy
    login asus router
    goto wireless general page

    enable legacy mode    2g
    enable legacy mode    5g

    logout asus router
    

asus router enable ssh server
    login asus router

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
                                                  
    apply settings

    logout asus router

security mode open
    [Arguments]                                   ${band}
    set band                                      ${band}

    ${currentauthmode}                            Get Selected List Label        name:wl_auth_mode_x
    IF                                            '${currentauthmode}' != 'Open System'
                                                  Select From List By value      name:wl_auth_mode_x    open
    END

    apply settings

asus router open
    login asus router
    goto wireless general page

    security mode open                            2g
    security mode open                            5g

    logout asus router

security mode tkip
    [Arguments]                                   ${band}
    set band                                      ${band}
    
    ${currentauthmode}                            Get Selected List Label                       name:wl_auth_mode_x
    Log                                           ${currentauthmode}
    IF                                            '${currentauthmode}' != 'WPA/WPA2-Personal'
                                                  Select From List By value                     name:wl_auth_mode_x    pskpsk2
    END
     
    ${currentcrypto}                              Get Selected List Label                       name:wl_crypto
    Log                                           ${currentcrypto}
    IF                                            '${currentcrypto}' != 'TKIP+AES'
                                                  Select From List By value                     name:wl_crypto    tkip+aes
    END

    Input Text                                    name:wl_wpa_psk                               ${passphrase}

    apply settings

asus router tkip
    login asus router
    goto wireless general page

    security mode tkip    2g
    security mode tkip    5g

    logout asus router

security mode ccmp
    [Arguments]                                   ${band}
    set band                                      ${band}
    
    ${currentauthmode}                            Get Selected List Label                       name:wl_auth_mode_x
    Log                                           ${currentauthmode}
    IF                                            '${currentauthmode}' != 'WPA2-Personal'
                                                  Select From List By value                     name:wl_auth_mode_x    psk2
    END
     
    ${currentcrypto}                              Get Selected List Label                       name:wl_crypto
    Log                                           ${currentcrypto}
    IF                                            '${currentcrypto}' != 'AES'
                                                  Select From List By value                     name:wl_crypto    aes
    END

    Input Text                                    name:wl_wpa_psk                               ${passphrase}

    apply settings

asus router ccmp
    login asus router
    goto wireless general page

    security mode ccmp    2g
    security mode ccmp    5g

    logout asus router

