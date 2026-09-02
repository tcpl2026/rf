*** Settings ***
Resources    ../variables/variables.robot
Resources    asus_ap/common.robot

*** Keywords ***
Config ASUS AP
    [Arguments]    ${band}    ${ssid}    ${bw}    ${channel}    ${mode}=ax    ${security_mode}=wpa2psk    ${passphrase}=${AP_PSK_KEY}
    Login ASUS AP

    Go To Wireless General Page
    Set Band         ${band}

    Set SSID         ${ssid}
    Set Bandwidth    ${bw}
    Set Channel      ${channel}
    Set WiFi Mode    ${mode}
    
    Apply Settings
    Logout ASUS AP
