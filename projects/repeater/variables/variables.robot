*** Variables ***
${AP_IP}                                   192.168.50.1
${AP_URL}                                  http://${AP_IP}
${AP_USER}                                 admin
${AP_PWD}                                  @a12345678
${BROWSER}                                 Chrome

${AP_2G_SSID}                              56u2g
${AP_5G_SSID}                              56u5g

${AP_PSK_KEY}                              passphrase

${STA1_CONTROL_IP}                         10.12.10.229
${STA1_USER}                               scm
${STA1_PWD}                                1
${STA1_WLAN_INTERFACE}                     wlan0

${STA2_CONTROL_IP}                         10.12.10.229
${STA2_USER}                               scm
${STA2_PWD}                                1
${STA2_WLAN_INTERFACE}                     wlan0

${LANPC_CONTROL_IP}                        10.12.6.33
${LANPC_LAN_INTERFACE}                     eth0
${LANPC_USER}                              scm
${LANPC_PWD}                               1


### for stability basic check
#${stability_run_times}                     2                # driver reload times, wifi reconnect times
#${stability_iperf_time}                    10               # iperf run time in stability test
#${stability_idle_time}                     60s              # 2g, 5g connection idle test, don't remove the s character
#${stability_ping_count}                    2
#${stability_ping_times}                    5                # ping test time = ping times * ping count
### for stability real test
${stability_run_times}                     500              # driver reload times, wifi reconnect times
${stability_iperf_time}                    43200               # iperf run time in stability test
${stability_idle_time}                     43200s              # 2g, 5g connection idle test, don't remove the s character
${stability_ping_count}                    3600
${stability_ping_times}                    12                # ping test time = ping times * ping count

${throughput_test_times}                   1                # iperf run times in throughput test

${throughput_2g_iperf_pairs}               8
${throughput_5g_iperf_pairs}               15

${staut_bash}                              staut bash shell
${staut_wpa_cli}                           staut wpa_cli shell
${sta1_bash}                               sta1 bash shell
${sta1_wpa_cli}                            sta1 wpa_cli shell
${sta2_bash}                               sta2 bash shell
${sta2_wpa_cli}                            sta2 wpa_cli shell
${lanpc_bash}                              lanpc bash shell
${driver_log_bash}                         capture driver log
${fw_log_bash}                             capture firmware log

${driver_script}                           /home/scm/mac80211/scripts/run.sh
${driver_stop}                             bash ${driver_script} -o stop
${driver_start}                            bash ${driver_script} -o start -c 3

${scan_pass_ssid}                          SC-Ent

${hostapd}                                 ~/hostap/hostapd/hostapd
${wpa_supplicant}                          ~/hostap/wpa_supplicant/wpa_supplicant
${wpa_cli}                                 ~/hostap/wpa_supplicant/wpa_cli
#${wpa_supplicant}                         wpa_supplicant
#${wpa_cli}                                wpa_cli


${ping_count}                              5
${iperf_run_time}                          5

@{2g_freq_list}                            2412    2417    2422    2427    2432    2437    2442   2447    2452    2457    2462    2467    2472
@{5g_freq_list}                            5180    5200    5220    5240    5745    5765    5785   5805

# one channel
@{2g_20M_channel_list}                     1
@{2g_40M_channel_list}                     1
@{5g_20M_channel_list}                     36
@{5g_40M_channel_list}                     36l
@{5g_80M_channel_list}                     36/80
# partial channel
#@{2g_20M_channel_list}                     1        3        7         10        13
#@{2g_40M_channel_list}                     1        3        7         10        13
#@{5g_20M_channel_list}                     36       48       149       157       165
#@{5g_40M_channel_list}                     36l      48u      149l      157l      161u
#@{5g_80M_channel_list}                     36/80    48/80    149/80    157/80    161/80
# all channel
#@{2g_20M_channel_list}                     1        2        3        4        5         6         7         8    9    10    11    12    13
#@{2g_40M_channel_list}                     1        2        3        4        5         6         7         8    9    10    11    12    13
#@{5g_20M_channel_list}                     36       40       44       48       149       153       157       161
#@{5g_40M_channel_list}                     36l      40u      44l      48u      149l      153u      157l      161u
#@{5g_80M_channel_list}                     36/80    40/80    44/80    48/80    149/80    153/80    157/80    161/80



&{ch_freq_map_dic}                         1=2412        2=2417        3=2422        4=2427      5=2432     6=2437     7=2442
...                                        8=2447        9=2452        10=2457       11=2462     12=2467    13=2472
...                                        36=5180       40=5200       44=5220       48=5240    
...                                        36l=5180      40u=5200      44l=5220      48u=5240    
...                                        36/80=5180    40/80=5200    44/80=5220    48/80=5240    
...                                        149=5745      153=5765      157=5785      161=5805    165=5825
...                                        149l=5745     153u=5765     157l=5785     161u=5805
...                                        149/80=5745   153/80=5765   157/80=5785   161/80=5805

