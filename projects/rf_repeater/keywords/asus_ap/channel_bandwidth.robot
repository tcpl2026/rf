*** Keywords ***
Set Bandwidth
    [Documentation]    1:20MHz, 2:40MHz, 3:80MHz
    [Arguments]    ${bw}
    ${currentbandwidth}=    Get Selected List Label    name:wl_bw
    IF    '${bw}' == '20m'
        IF    '${currentbandwidth}' != '20MHz'
            Select From List By Value    name:wl_bw    1
        END
    ELSE IF    '${bw}' == '40m'
        IF    '${currentbandwidth}' != '40MHz'
            Select From List By Value    name:wl_bw    2
        END
    ELSE IF    '${bw}' == '80m'
        IF    '${currentbandwidth}' != '80MHz'
            Select From List By Value    name:wl_bw    3
        END
    END

Set Channel
    [Documentation]    2g: 1-13 5g:36-161, 20M:36, 40M:36l, 80M:36/80
    [Arguments]    ${channel}
    ${currentchannel}=    Get Selected List Value    name:wl_channel
    IF    '${currentchannel}' != '${channel}'
        Select From List By Value    name:wl_channel    ${channel}
    END
