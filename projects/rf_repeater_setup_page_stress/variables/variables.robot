*** Variables ***
#${connectivity_check_url}    http://connectivitycheck.cbg-app.huawei.com/generate_204
${connectivity_check_url}    http://192.168.1.1
${browser}                   Chrome

${wpa_cli}                   /home/scm/hostap/wpa_supplicant/wpa_cli
${wlan_interface}            wlan0

${TIMEOUT}                   30s
