*** Settings ***
Library     SSHLibrary
Library     String
Library     Collections
Library     SerialLibrary

Resource    ../variables/variables.robot
Resource    ../keywords/sta_pc.robot

*** Test Cases ***
Setup Repeater Stress Test
    FOR    ${test_time}    IN RANGE    ${STRESS_TIMES}
        Log To Console    \n========= This is the ${test_time} time test =========\n
        Setup Repeater
    END

*** Keywords ***
Run Console Command
    [Arguments]    ${command}
    Connect    ${SERIAL_PORT}    ${SERIAL_BAUDRATE_1}
    Write    version
    ${OUTPUT}=    Read
    Log    ${OUTPUT}

    IF    "WISE" not in $OUTPUT
        Disconnect
        Sleep    1s
        Connect    ${SERIAL_PORT}    ${SERIAL_BAUDRATE_2}
    END

    Reset Output Buffer
    Write    ${command}
    ${OUTPUT}=    Read
    Log    ${OUTPUT}
    Disconnect
    RETURN    ${OUTPUT}

Setup Repeater
    Log To Console    \n>>>>>>>>> Connect to default SSID\n
    Serial PC Run Command    ifconfig wlan0
    Sleep    0.5s
    ${OUTPUT}=    Serial PC Read
    Log    ${OUTPUT}
    ${BSSID_LIST}=    Get Regexp Matches    ${OUTPUT}    ([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}
    Log    ${BSSID_LIST}
    ${BSSID}=    Get From List    ${BSSID_LIST}    0
    Log    ${BSSID}
    
    Serial PC Run Command    dmesg start

    Connect to Default SSID    ${BSSID}


    Log To Console    \n>>>>>>>>> Setup repeater\n
    Send HTTP Get to Repeater
    Log To Console    \n>>>>>>>>> Connect to repeater\n
    Connect to Repeater

    [Teardown]    Close All Connections

