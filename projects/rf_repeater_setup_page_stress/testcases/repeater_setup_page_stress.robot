*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    RequestsLibrary

Resource     ../variables/variables.robot

*** Test Cases ***
repeater setup page stress test
    FOR    ${i}    IN RANGE    100000
        Log To Console    \n========= This is the ${i} time test =========
        WiFi Reconnect
        Open Setup Page
    END


*** Keywords ***
Open Setup Page
    #[Timeout]    30 seconds
    FOR    ${j}    IN RANGE    3
        TRY
            Open Browser    ${connectivity_check_url}    ${browser}
            Sleep    5s
            Wait Until Page Contains Element    id:ap_ssid    timeout=10s
            #Set Screenshot Directory    screenshot
            #Capture Page Screenshot
            Delete All Cookies
            Close Browser
            BREAK
        EXCEPT
            Log To Console    Open setup page failed, retry
            Close Browser
        END
    END

    #${curl_cmd}=    Set Variable    curl -s -o /dev/null -w "\%{http_code}" "${connectitity_check_url}"
    #${curl_cmd}=    Set Variable    curl -s -o /dev/null --retry-delay 2 --retry 5 -w "\%{http_code}" "${connectitity_check_url}"
    #${curl_cmd}=    Set Variable    curl -s -o /dev/null -m 10 -w "\%{http_code}" "${connectitity_check_url}"
    #${response}=    Run    ${curl_cmd}
    #Log    response code: ${response}
    #Should Be Equal As Strings    ${response}    200

    #${resp}=    GET    ${connectivity_check_url}    timeout=10
    #Status Should Be    200    ${resp}

WiFi Reconnect
    Run    sudo ${wpa_cli} -i ${wlan_interface} disconnect
    Sleep    1s
    Run    sudo ${wpa_cli} -i ${wlan_interface} reconnect
    FOR    ${i}    IN RANGE    5
        TRY
            Sleep    2s
            ${status}=    Run    sudo ${wpa_cli} -i ${wlan_interface} status
            Log    ${status}
            Should Contain    ${status}    wpa_state=COMPLETED
            BREAK
        EXCEPT
            Log To Console    WiFi disconnected, wait a few more seconds
        END
    END
    Run    sudo dhclient -r ${wlan_interface}
    ${output}=    Run    sudo ifconfig ${wlan_interface}
    Log    ${output}
    Run    sudo dhclient ${wlan_interface}
    ${wlan_ip}=    Run    sudo ifconfig ${wlan_interface}
    Should Contain    ${wlan_ip}    192.168
