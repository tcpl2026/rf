*** Settings ***
Resource    ../variables/variables.robot

*** Keywords ***
Config ASUS AP
    [Documentation]    2GHz 20m channel: 1-13 
    ...                5GHz 20m channel: 36-161
    ...                5GHz 40M channel: 36l 40u 44l 48u 149l 153u 157l 161u
    ...                5GHz 80M channel: 36/80 40/80 44/80 48/80 149/80 153/80 157/80 161/80
    [Arguments]    ${band}    ${ssid}    ${bw}    ${channel}    ${wifi_mode}=ax    ${security_mode}=${EMPTY}    ${key}=${EMPTY}

    IF    '${band}' == '2g'
        ${interface}=    Set Variable    wl0
    ELSE IF    '${band}' == '5g'
        ${interface}=    Set Variable    wl1
    END

    Open Connection    ${AP_IP}
    Login    ${AP_USER}    ${AP_PWD}

    # SSID
    ${current}=    Execute Command    nvram get ${interface}_ssid
    IF    '${current}' != '${ssid}'
        Execute Command    nvram set ${interface}_ssid=${ssid}
    END

    # Bandwidth
    IF    '${bw}' == '20m40m' or '${bw}' == '20m40m80m'
        ${wl_bw}=    Set Variable    0
    ELSE IF    '${bw}' == '20m'
        ${wl_bw}=    Set Variable    1
    ELSE IF    '${bw}' == '40m'
        ${wl_bw}=    Set Variable    2
    ELSE IF    '${bw}' == '80m'
        ${wl_bw}=    Set Variable    3
    END
    ${current}=    Execute Command    nvram get ${interface}_bw
    IF    '${current}' != '${wl_bw}'
        Execute Command    nvram set ${interface}_bw=${wl_bw}
    END

    # Channel
    ${current}=    Execute Command    nvram get ${interface}_chanspec
    IF    '${current}' != '${channel}'
        Execute Command    nvram set ${interface}_chanspec=${channel}
    END

    # WiFi Mode
    IF    '${wifi_mode}' == 'ax'
        ${current}=    Execute Command    nvram get ${interface}_nmode_x
        IF    '${current}' != '0'
            Execute Command    nvram set ${interface}_nmode_x=0
        END
        ${current}=    Execute Command    nvram get ${interface}_11ax
        IF    '${current}' != '1'
            Execute Command    nvram set ${interface}_11ax=1
        END
    ELSE IF    '${wifi_mode}' == 'ac'
        ${current}=    Execute Command    nvram get ${interface}_nmode_x
        IF    '${current}' != '0'
            Execute Command    nvram set ${interface}_nmode_x=0
        END
        ${current}=    Execute Command    nvram get ${interface}_11ax
        IF    '${current}' != '0'
            Execute Command    nvram set ${interface}_11ax=0
        END
    ELSE IF    '${wifi_mode}' == 'n'
        ${current}=    Execute Command    nvram get ${interface}_nmode_x
        IF    '${current}' != '1'
            Execute Command    nvram set ${interface}_nmode_x=1
        END
        ${current}=    Execute Command    nvram get ${interface}_11ax
        IF    '${current}' != '0'
            Execute Command    nvram set ${interface}_11ax=0
        END
    END

    # Security Mode
    IF    '${security_mode}' == 'open'
        ${current}=    Execute Command    nvram get ${interface}_auth_mode_x
        IF    '${current}' != 'open'
            Execute Command    nvram set ${interface}_auth_mode_x=open
        END
    ELSE IF    '${security_mode}' == 'psk2'
        ${current}=    Execute Command    nvram get ${interface}_auth_mode_x
        IF    '${current}' != 'psk2'
            Execute Command    nvram set ${interface}_auth_mode_x=psk2
        END
        IF    $key
            ${current}=    Execute Command    nvram get ${interface}_wpa_psk
            IF    '${current}' != $key
                Execute Command    nvram set ${interface}_wpa_psk=${key}
            END
        END
     END

    Execute Command    nvram commit
    Execute Command    service restart_wireless

    ${current_ssid}=    Execute Command    nvram get ${interface}_ssid
    ${current_bandwidth}=    Execute Command    nvram get ${interface}_bw
    ${current_channel}=    Execute Command    nvram get ${interface}_chanspec
    ${current_nmode}=    Execute Command    nvram get ${interface}_nmode_x
    ${current_11ax}=    Execute Command    nvram get ${interface}_11ax
    ${current_security}=    Execute Command    nvram get ${interface}_auth_mode_x

    Should Be Equal As Strings    ${current_ssid}    ${ssid}
    Should Be Equal As Strings    ${current_channel}    ${channel}

    Log To Console    SSID: ${current_ssid}
    Log To Console    Bandwidth: ${current_bandwidth}
    Log To Console    Channel: ${current_channel}
    Log To Console    nmode: ${current_nmode}
    Log To Console    11ax: ${current_11ax}
    Log To Console    security: ${current_security}

    Close Connection
