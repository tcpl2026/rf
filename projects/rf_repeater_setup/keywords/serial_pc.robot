*** Settings ***
Library     SSHLibrary
Library     DateTime
Resource    ../variables/variables.robot

*** Keywords ***
Login Serial PC And Start Tio
    [Arguments]    ${BAUDRATE}
    Open Connection    ${SERIAL_PC_IP}    alias=serialpc    encoding_errors=ignore
    Login    ${SERIAL_PC_USER}    ${SERIAL_PC_PWD}
    ${CURRENT_TIME}=    Get Current Date    result_format=%Y%m%d-%H%M%S
    Log    ${CURRENT_TIME}
    ${FW_LOG_FILE}=    Set Variable    firmware_log_${CURRENT_TIME}.txt
    Log    Firmware log file name is: ${FW_LOG_FILE}
    Execute Command    killall -9 tio
    Write    tio ${SERIAL_PORT} -b ${BAUDRATE} -l ~/${FW_LOG_FILE}

Serial PC Run Command
    [Arguments]    ${COMMAND}
    Switch Connection    serialpc
    Write    ${COMMAND} 

Serial PC Read
    Switch Connection    serialpc
    ${OUTPUT}=    read
    RETURN    ${OUTPUT}




