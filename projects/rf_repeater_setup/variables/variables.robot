*** Variables ***
${PDU_URL}                  http://10.12.10.160
${PDU_PORT}                 2
${PDU_USER}                 scm
${PDU_PWD}                  qwer

${BROWSER}                  Chrome

${SERIAL_PC_IP}             10.12.10.149
${SERIAL_PC_USER}           root
${SERIAL_PC_PWD}            1
${SERIAL_PORT}              /dev/ttyUSB0
${SERIAL_BAUDRATE_1}        115200    
${SERIAL_BAUDRATE_2}        460800

${STRESS_TIMES}             100

${DEFAULT_SSID}             Repeater_softap

${STA_PC_IP}                10.12.10.229
${STA_PC_USER}              scm
${STA_PC_PWD}               1
${STA_PC_WIFI_INTERFACE}    wlan0
${STA_PC_WPAS}              /home/scm/hostap/wpa_supplicant/wpa_supplicant
${STA_PC_WPAC}              /home/scm/hostap/wpa_supplicant/wpa_cli

${ROOT_AP_SSID}             56u5g
${ROOT_AP_KEY}              qwerasdf
${REPEATER_SSID}            56u5g-abcdef
${REPEATER_KEY}             qwerasdf
