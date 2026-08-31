*** Keywords ***
login asus router
    Open Browser                          url=${AX56U_LOGIN_URL}                browser=${browser}
    Maximize Browser Window
    Sleep                                 3s
    Wait Until Page Contains Element      id:login_username
    Input Text                            name:login_username                   ${AX56U_LOGIN_USER}
    Input Password                        name:login_passwd                     ${AX56U_LOGIN_PASSWORD}
    Click Element                         class:button

    Wait Until Page Contains Element      id:NM_connect_title

    set language to english

logout asus router
    Click Element                         xpath: //*[contains(text(), "Logout")]
    Close Browser 

set language to english
    ${language}                            Get Text                     id:selected_lang
    Log                                    ${language}
    IF                                     '${language}' != 'English'
                                           Mouse Over                   id:selected_lang
                                           Sleep                        1s
                                           Click Element                xpath: //*[contains(text(), "English")]
                                           Sleep                        3s
    END

goto wireless general page
    Click Element                                 id:Advanced_Wireless_Content_menu
    Wait Until Page Contains Element              name:wl_unit

set band
    [Documentation]                 0:2g, 1:5g
    [Arguments]                     ${band}                         
    ${currentband}=                 Get Selected List Label                       name:wl_unit
    IF                              '${band}' == '2g'
                                    IF                                            '${currentband}' != '2.4 GHz'
                                                                                  Select From List By Value                name:wl_unit           0
                                                                                  Reload Page
                                                                                  Wait Until Page Contains Element         name:wl_unit
                                    END
                                                                                  
    ELSE IF                         '${band}' == '5g'
                                    IF                                            '${currentband}' != '5 GHz'
                                                                                  Select From List By Value                name:wl_unit           1
                                                                                  Reload Page
                                                                                  Wait Until Page Contains Element         name:wl_unit
                                    END
    END

set band to 2g
    set band                                      2g

set band to 5g
    set band                                      5g

set channel
    [Documentation]                               2g: 1-13 5g:36-161, 20M:36, 40M:36l, 80M:36/80
    [Arguments]                                   ${channel}
    ${currentchannel}=                            Get Selected List Value                              name:wl_channel
    #${currentchannel}=                            Get Selected List Label                              name:wl_channel
    IF                                            '${currentchannel}' != '${channel}'
                                                  Select From List By Value                            name:wl_channel               ${channel}
    END

apply settings
    Click Button                                  xpath://input[@value="Apply"]
    TRY
                                                  Handle Alert             action=ACCEPT    timeout=0.5 s
    EXCEPT
                                                  Log                      No alert box
    END
    TRY
                                                  Handle Alert             action=ACCEPT    timeout=0.5 s
    EXCEPT
                                                  Log                      No alert box
    END
    Sleep                                         0.5s
    Wait Until Element Is Not Visible             xpath://span[contains(text(),'Applying Settings')]    timeout=30
    Sleep                                         3s

change 5g channel
    [Arguments]                                   ${channel}
    login asus router
    goto wireless general page
    
    set band to 5g
    set channel                                   ${channel}
    Sleep                                         3s

    apply settings

    logout asus router

set ssid
    [Arguments]                                   ${2g_ssid}    ${5g_ssid}
    login asus router
    goto wireless general page
    
    set band                                      2g
    Input Text                                    id:wl_ssid    ${2g_ssid}
    Sleep                                         3s
    apply settings

    set band                                      5g
    Input Text                                    id:wl_ssid    ${5g_ssid}
    Sleep                                         3s
    apply settings

    logout asus router

set 5g bandwidth
    [Documentation]                               1:20MHz, 2:40MHz, 3:80MHz
    [Arguments]                                   ${bw}
    login asus router
    goto wireless general page
    set band                                      5g

    ${currentbandwidth}=                          Get Selected List Label         name:wl_bw
    IF                                            '${bw}' == '20m'
                                                  IF                              '${currentbandwidth}' != '20MHz'
                                                                                  Select From List By Value          name:wl_bw     1
                                                  END
    ELSE IF                                       '${bw}' == '40m'
                                                  IF                              '${currentbandwidth}' != '40MHz'
                                                                                  Select From List By Value          name:wl_bw     2
                                                  END
    ELSE IF                                       '${bw}' == '80m'           
                                                  IF                              '${currentbandwidth}' != '80MHz'
                                                                                  Select From List By Value          name:wl_bw     3
                                                  END
    END                                   

    Sleep                                         3s
    apply settings

    logout asus router
