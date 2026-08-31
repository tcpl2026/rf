# DateTime: keywords

## Get Current Date

```
**** Settings ***
Library    DateTime

*** Variables ***

*** Test Cases ***
Log File
    ${runtime}=    get current time
    Set Variable    ${log_file}    log_${runtime}.txt
    Log    log file: ${log_file}

*** Keywords ***
Get Current Time
    ${current_time}=    Get Current Date    result_format=%Y%m%d-%H%M%S
    Log    Current time: ${current_time}
    RETURN    ${current_time}
```
