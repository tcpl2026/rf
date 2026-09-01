*** Settings ***
Resources    common.robot

*** Keywords ***
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
    
