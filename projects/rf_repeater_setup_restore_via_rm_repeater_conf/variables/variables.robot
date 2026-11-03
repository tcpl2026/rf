*** Variables ***
${SERIAL_PORT}              /dev/ttyUSB0
${SERIAL_BAUDRATE_1}        115200    
${SERIAL_BAUDRATE_2}        460800

${STRESS_TIMES}             100

${DEFAULT_SSID}             Repeater_softap

${STA_PC_IP}                10.12.6.124
${STA_PC_USER}              scm
${STA_PC_PWD}               1
${STA_PC_WIFI_INTERFACE}    wlan0
${STA_PC_WPAS}              wpa_supplicant
${STA_PC_WPAC}              wpa_cli

${ROOT_AP_SSID}             tuf2g
${ROOT_AP_KEY}              qwerasdf
${REPEATER_SSID}            tuf2g_ext
${REPEATER_KEY}             qwerasdf
