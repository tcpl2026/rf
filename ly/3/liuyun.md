# 3

34 dictionary变量

```
*** Variables ***
&{dict}    name=Tony    age=30

*** Test Cases ***
Dict_Suite_TestCase
    Log To Console    ${dict}[name]
    Log To Console    ${dict.age}
    Log To Console    ${dict}
    Log Many          &{dict}

```
