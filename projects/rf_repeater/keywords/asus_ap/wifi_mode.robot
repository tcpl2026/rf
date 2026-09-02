*** Settings ***
Resources    common.robot

*** Keywords ***
Enable WiFi6 Mode
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

Enable WiFi5 Mode
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

Enable Legacy Mode
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
    
