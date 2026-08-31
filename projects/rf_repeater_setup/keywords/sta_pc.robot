*** Settings ***
Library     SSHLibrary
Library     RequestsLibrary

Resource    ../variables/variables.robot

*** Keywords ***
Connect to Default SSID
    [Arguments]    ${BSSID}
    Open Connection    ${STA_PC_IP}
    Login    ${STA_PC_USER}    ${STA_PC_PWD}

    Execute Command    sudo killall -9 wpa_supplicant
    Execute Command    sudo ${STA_PC_WPAS} -i ${STA_PC_WIFI_INTERFACE} -C /var/run/wpa_supplicant -B


    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} remove_network all
    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} add_network
    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} set_network 0 ssid \\"${DEFAULT_SSID}\\"
    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} set_network 0 key_mgmt NONE
    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} set_network 0 bssid ${BSSID}
    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} enable_network 0

    FOR    ${item}    IN RANGE    10
        Sleep    3s
        ${OUTPUT}=    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} status
        IF    'wpa_state=COMPLETED' in '''${output}'''
             Log    Connected to repeater
             BREAK
        END
    END

    ${OUTPUT}=    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} status
    Should Contain    ${OUTPUT}    wpa_state=COMPLETED

    Execute Command    sudo dhclient -r ${STA_PC_WIFI_INTERFACE}
    Execute Command    sudo dhclient ${STA_PC_WIFI_INTERFACE}
    ${OUTPUT}=    Execute Command    ifconfig ${STA_PC_WIFI_INTERFACE}
    ${IP_LIST}=    Get Regexp Matches    ${OUTPUT}    (?<=inet )(?:\\d{1,3}\\.){3}\\d{1,3}
    Log    ${IP_LIST}
    Should Not Be Empty    ${IP_LIST}
    Execute Command    sudo ip neigh flush all

    Close Connection

Send HTTP Get to Repeater
    Open Connection    ${STA_PC_IP}
    Login    ${STA_PC_USER}    ${STA_PC_PWD}

    #Create Session    repeater    http://192.168.1.1
    #${URL}=    Set Variable    /save?sta_ssid=${ROOT_AP_SSID}&sta_pwd=${ROOT_AP_KEY}&ap_ssid=${REPEATER_SSID}&ap_pwd=${REPEATER_KEY}
    #${response}=    GET On Session    repeater    ${URL}
    #Status Should Be    200    ${response}
    #Log    response code: ${response.status_code}
    #Log    response content: ${response.text}
    ${URL}=    Set Variable    http://192.168.1.1/save?sta_ssid=${ROOT_AP_SSID}&sta_pwd=${ROOT_AP_KEY}&ap_ssid=${REPEATER_SSID}&ap_pwd=${REPEATER_KEY}
    ${curl_cmd}=    Set Variable    curl -s -o /dev/null -w "\%{http_code}" "${URL}"
    ${response}=    Execute Command    ${curl_cmd}
    Log    response code: ${response}
    Should Be Equal As Strings    ${response}    200

    Close Connection

Connect to Repeater
    Open Connection    ${STA_PC_IP}
    Login    ${STA_PC_USER}    ${STA_PC_PWD}

    Execute Command    sudo killall -9 wpa_supplicant
    Execute Command    sudo ${STA_PC_WPAS} -i ${STA_PC_WIFI_INTERFACE} -C /var/run/wpa_supplicant -B

    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} remove_network all
    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} add_network
    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} set_network 0 ssid \\"${REPEATER_SSID}\\"
    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} set_network 0 psk \\"${REPEATER_KEY}\\"
    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} enable_network 0

    FOR    ${item}    IN RANGE    20
        Sleep    3s
        ${OUTPUT}=    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} status
        IF    'wpa_state=COMPLETED' in '''${output}'''
             Log    Connected to repeater
             BREAK
        END
    END

    ${OUTPUT}=    Execute Command    sudo ${STA_PC_WPAC} -i ${STA_PC_WIFI_INTERFACE} status
    Should Contain    ${OUTPUT}    wpa_state=COMPLETED

    Execute Command    sudo dhclient -r ${STA_PC_WIFI_INTERFACE}
    Execute Command    sudo dhclient ${STA_PC_WIFI_INTERFACE}
    ${OUTPUT}=    Execute Command    ifconfig ${STA_PC_WIFI_INTERFACE}
    ${IP_LIST}=    Get Regexp Matches    ${OUTPUT}    (?<=inet )(?:\\d{1,3}\\.){3}\\d{1,3}
    Log    ${IP_LIST}
    Should Not Be Empty    ${IP_LIST}
    Execute Command    sudo ip neigh flush all

    Close Connection


