# for loops

https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#for-loops

```
*** Variables ***
@{2g_channel_list}                       2412    2417    2422    2427    2432    2437    2442   2447    2452    2457    2462

*** Test Cases ***
print list
    FOR    ${item}    IN         @{2g_channel_list}
           Log        ${item}
    END

------------------------------
*** Variables ***
@{CHANNEL_LIST}    1    2    3
...                4    5    6
...                7    8    9
...                10    11

*** Test Cases ***
print channel list
    FOR    ${i}    IN    @{CHANNEL_LIST}
           Log To Console    ${i}
    END
-------------------------------
*** Test Cases ***
case 1
    FOR    ${i}    IN RANGE    500
           Log     ${i}
    END
-------------------------------
*** Test Cases ***
case 1
    FOR    ${i}    IN RANGE    1    11    2
        Log To Console    ${i}
    END
```



## for循环例子

usb网卡在不停的scan，使用协议分析仪在抓usb的log，当scan失败时，停止usb协议分析仪的log，防止最新的log被后面的log冲掉。

停止协议分析仪的log是采取坐标定位的方式，定位stop按钮的位置。

test.py

```
import pyautogui

def stop_log_when_scan_fails():
    pyautogui.click(480, 1056, duration=0.5)
    pyautogui.click(547, 709, duration=2)
```

```
*** Settings ***
Documentation      Robot Framework test script
Library            SSHLibrary
Library            test.py

*** Variables ***
${host}            192.168.191.107
${username}        scm
${password}        qwerasdf
${alias}           remote_host_1

*** Test Cases ***
Test SSH Connection
    Open Connection          ${host}               alias=${alias}
    Login                    ${username}           ${password}            delay=1
    Execute Command          sudo killall -9 wpa_supplicant
    Execute Command          sudo wpa_supplicant -i wlan0 -C /var/run/wpa_supplicant -B
    FOR                      ${i}                  IN RANGE                9999999
        ${stdout}=           Execute Command       sudo wpa_cli -i wlan0 scan
        Log                  ${stdout}
        Run Keyword If       '${stdout}'!= 'OK'    Exit For Loop
        Sleep                10s
    END
    stop_log_when_scan_fails
    Close All Connections
```

