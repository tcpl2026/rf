# SSHLibrary: keywords

## Execute Command

the first example

```
*** Settings ***
Documentation      Robot Framework test script
Library            SSHLibrary

*** Variables ***
${host}            192.168.191.107
${username}        scm
${password}        qwerasdf
${alias}           remote_host_1

*** Test Cases ***
Test SSH Connection
    Open Connection          ${host}            alias=${alias}
    Login                    ${username}        ${password}       delay=1
    Execute Command          hostname
    ${stdout}=               Execute Command    hostname
    Log                      ${stdout}
    Close All Connections
```

login remote pc and scan

```
*** Settings ***
Documentation      Robot Framework test script
Library            SSHLibrary

*** Variables ***
${host}            192.168.191.107
${username}        scm
${password}        qwerasdf
${alias}           remote_host_1

*** Test Cases ***
Test SSH Connection
    Open Connection          ${host}                alias=${alias}
    Login                    ${username}            ${password}            delay=1
    Execute Command          sudo killall -9 wpa_supplicant
    Execute Command          sudo wpa_supplicant -i wlan0 -C /var/run/wpa_supplicant -B
    ${stdout}=               Execute Command         sudo wpa_cli -i wlan0 scan
    Sleep                    10s
    ${stdout}=               Execute Command         sudo wpa_cli -i wlan0 scan_r
    Close All Connections
```
## Switch Connection

```
*** Settings ***
Library    SSHLibrary

*** Variables ***
${HOST1}              192.168.191.130
${HOST1_ALIAS}        dell_7090
${HOST2}              192.168.191.169
${HOST2_ALIAS}        dell_7080
${alias}
${USERNAME}           scm
${PASSWORD}           qwerasdf

*** Test Cases ***
Login Remote Host and Scan
    Open Connection                ${HOST1}                         alias=${HOST1_ALIAS}
    Login                          ${USERNAME}                      ${PASSWORD}
    ${output}                      Execute Command                  hostname
    Log                            ${output}
    Open Connection                ${HOST2}                         alias=${HOST2_ALIAS}
    Login                          ${USERNAME}                      ${PASSWORD}
    ${output}                      Execute Command                  hostname
    Log                            ${output}
    Switch Connection              ${HOST1_ALIAS}
    ${output}                      Execute Command                  hostname
    Log                            ${output}
    Close All Connections
```
## SSHLibrary: 交互式输入 Interactive shells

https://marketsquare.github.io/SSHLibrary/SSHLibrary.html#Interactive%20shells

```
Write, Write Bare, Write Until Expected Output, 
Read, Read Until, Read Until Prompt and Read Until Regexp 
can be used to interact with the server within the same shell.
```

scan示例

这个示例是先远程登录pc再进入wpa_cli下交互式输入，执行scan命令并打印scan结果。需要先在pc上把wpa_supplicant启动。

```
*** Settings ***
Library    SSHLibrary

*** Variables ***
${HOST}        192.168.191.130
${USERNAME}    scm
${PASSWORD}    qwerasdf

*** Test Cases ***
Scan on target host
    Open Connection                       ${HOST}
    Login                                 ${USERNAME}                      ${PASSWORD}
    Write                                 sudo wpa_cli -i wlan0
    Write                                 scan
    ${output}                             Read Until                       CTRL-EVENT-SCAN-STARTED
    Log                                   ${output}
    Sleep                                 5s
    ${output}=                            Read
    Log                                   ${output}
    Write                                 scan_results
    ${output}=                            Read                             loglevel=INFO    delay=0.5s
    Log                                   ${output}
    Write                                 interface
    ${output}=                            Read                             delay=0.5s
    Log                                   ${output}
    Close All Connections
```

Note

```
要进入wpa_cli进行交互式输入，这时不能用Execute Command命令了，因为Execute Command命令要返回值，会一直卡住，使用Write命令直接写

Read和Read Until是从一开始读到当前位置，所以只要当前的输出的话，在前面位置read一次

Read读的很快，命令返回值还没打印完，就Read结束了，需要加个delay，等打印完成后再读。
例如这个示例中读取scan_r的输出，如果不加delay，那么扫描到的ssid不能打印出来
```

改进的scan版本


```
执行scan命令后不等待一个固定的时间，用Read Until读到scan已结束就执行下一步。

Real Until设置一个超时的时间5s，5s内scan不结束则fail。


*** Settings ***
Library    SSHLibrary

*** Variables ***
${HOST}        192.168.191.130
${USERNAME}    scm
${PASSWORD}    qwerasdf

*** Test Cases ***
Scan on target host
    Open Connection                       ${HOST}
    Login                                 ${USERNAME}                      ${PASSWORD}
    Write                                 sudo wpa_cli -i wlan0
    Write                                 scan
    Set Client Configuration              timeout=5 seconds
    Read Until                            CTRL-EVENT-SCAN-RESULTS
    Write                                 scan_r
    ${output}=                            Read                             delay=0.5s
    Log                                   ${output}
    Close All Connections
```
