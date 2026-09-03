*** Settings ***
Library    SeleniumLibrary
Library    SSHLibrary

Resource    ../variables/variables.robot
Resource    ../keywords/reset_and_setup_asus_ap.robot
Resource    ../keywords/config_asus_ap.robot

Suite Setup    Reset And Setup ASUS AP

*** Test Cases ***
Switch channel from 5GHz 149 HE80 to 36 HE80 then to 2.4GHz 11 HE20 repeatedly
    FOR    ${i}    IN RANGE    1    10000
        TRY
            Log To Console    \n========= This is the ${i} time test =========

            Log To Console    \n>>>>>>>>> Set AP to 5GHz Channel 149 HE80
            Config ASUS AP    band=5g    ssid=56u5g    bw=80m    channel=149/80    wifi_mode=ax    security_mode=psk2    key=${AP_PSK_KEY}
            Sleep    20s

            Log To Console    \n>>>>>>>>> Set AP to 5GHz Channel 36 HE80
            Config ASUS AP    band=5g    ssid=56u5g    bw=80m    channel=36/80    wifi_mode=ax    security_mode=psk2    key=${AP_PSK_KEY}
            Sleep    20s

            Log To Console    \n>>>>>>>>> Set AP to 2.GHz Channel 11 HE20
            Config ASUS AP    band=5g    ssid=56u5g5g    bw=80m    channel=36/80    wifi_mode=ax    security_mode=psk2    key=${AP_PSK_KEY}
            Config ASUS AP    band=2g    ssid=56u5g    bw=20m    channel=11    wifi_mode=ax    security_mode=psk2    key=${AP_PSK_KEY}
            Sleep    20s

            Log To Console    \n>>>>>>>>> Set AP to 5Hz Channel 165 HE20
            Config ASUS AP    band=2g    ssid=56u2g    bw=20m    channel=11    wifi_mode=ax    security_mode=psk2    key=${AP_PSK_KEY}
            Config ASUS AP    band=5g    ssid=56u5g    bw=20m    channel=165    wifi_mode=ax    security_mode=psk2    key=${AP_PSK_KEY}
            Sleep    20s

            # 华硕路由器的bug: 设置了一定次数后, 配置不再生效, 周期reset后重新配置避免这个问题
            IF    ${i} % 100 == 0
                Reset And Setup ASUS AP
            END
        EXCEPT
            Log To Console    Ignore error, continue trying
            Close All Connections
        END
    END
