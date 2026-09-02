security mode open
    [Arguments]                                   ${band}
    set band                                      ${band}

    ${currentauthmode}                            Get Selected List Label        name:wl_auth_mode_x
    IF                                            '${currentauthmode}' != 'Open System'
                                                  Select From List By value      name:wl_auth_mode_x    open
    END

    apply settings

asus router open
    login asus router
    goto wireless general page

    security mode open                            2g
    security mode open                            5g

    logout asus router

security mode tkip
    [Arguments]                                   ${band}
    set band                                      ${band}
    
    ${currentauthmode}                            Get Selected List Label                       name:wl_auth_mode_x
    Log                                           ${currentauthmode}
    IF                                            '${currentauthmode}' != 'WPA/WPA2-Personal'
                                                  Select From List By value                     name:wl_auth_mode_x    pskpsk2
    END
     
    ${currentcrypto}                              Get Selected List Label                       name:wl_crypto
    Log                                           ${currentcrypto}
    IF                                            '${currentcrypto}' != 'TKIP+AES'
                                                  Select From List By value                     name:wl_crypto    tkip+aes
    END

    Input Text                                    name:wl_wpa_psk                               ${passphrase}

    apply settings

asus router tkip
    login asus router
    goto wireless general page

    security mode tkip    2g
    security mode tkip    5g

    logout asus router

security mode ccmp
    [Arguments]                                   ${band}
    set band                                      ${band}
    
    ${currentauthmode}                            Get Selected List Label                       name:wl_auth_mode_x
    Log                                           ${currentauthmode}
    IF                                            '${currentauthmode}' != 'WPA2-Personal'
                                                  Select From List By value                     name:wl_auth_mode_x    psk2
    END
     
    ${currentcrypto}                              Get Selected List Label                       name:wl_crypto
    Log                                           ${currentcrypto}
    IF                                            '${currentcrypto}' != 'AES'
                                                  Select From List By value                     name:wl_crypto    aes
    END

    Input Text                                    name:wl_wpa_psk                               ${passphrase}

    apply settings

asus router ccmp
    login asus router
    goto wireless general page

    security mode ccmp    2g
    security mode ccmp    5g

    logout asus router

