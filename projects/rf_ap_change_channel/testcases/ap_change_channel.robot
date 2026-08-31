*** Settings ***
Library    SeleniumLibrary

Resource    ../keywords/asus_router_config.robot
Resource    ../variables/variables.robot

*** Test Cases ***
AP Change Channel
    FOR    ${i}    IN RANGE    10000
        TRY
            Log To Console    \nThis is the ${i} time reboot
            set ssid             56u5g        56u5g5
            Sleep                60s

            set ssid             56u2g        56u5g
            change 5g channel    149/80
            Sleep                60s

            change 5g channel    36/80
            Sleep                60s

            set 5g bandwidth     20m
            sleep                60s

            set 5g bandwidth     40m
            sleep                60s

            set 5g bandwidth     80m
            sleep                60s
        EXCEPT
            Log To Console    ignore error, continue trying
            Close All Browsers
        END
    END

