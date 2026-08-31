*** Settings ***
Library     SSHLibrary
Library     String
Library     Collections

Resource    ../variables/variables.robot
Resource    ../keywords/pdu_port_on_off.robot
Resource    ../keywords/serial_pc.robot
Resource    ../keywords/sta_pc.robot

*** Test Cases ***
Setup Repeater Stress Test
    FOR    ${test_time}    IN RANGE    ${STRESS_TIMES}
        Log To Console    \n========= This is the ${test_time} time test =========\n
        Setup Repeater
    END

*** Keywords ***
Setup Repeater
    Log To Console    \n>>>>>>>>> Turn off PDU port\n
    Login PDU
    Turn Off PDU Port    ${PDU_PORT}
    Logout PDU
    Sleep    5s

    Login Serial PC And Start Tio    ${SERIAL_BAUDRATE_1}

    Login PDU
    Log To Console    \n>>>>>>>>> Turn on PDU port\n
    Turn On PDU Port    ${PDU_PORT}
    Logout PDU

    Sleep    10s

    ${OUTPUT}=    Serial PC Read
    Log    ${OUTPUT}
    IF    "WISE" not in $OUTPUT
        Close All Connections
        Login Serial PC And Start Tio    ${SERIAL_BAUDRATE_2}
    END

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
 
