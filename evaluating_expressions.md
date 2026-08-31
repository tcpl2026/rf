# evaluating expressions

Many keywords, such as Evaluate, Run Keyword If and Should Be True, accept an expression that is evaluated in Python.


## Evaluate

Evaluates the given expression in Python and returns the result.

```
*** Test Cases ***
case 1
    ${a}=         Set Variable     abc
    Log           ${a}
    ${result}=    Evaluate         'd' in '${a}'
    Log           ${result}
    IF            not ${result}
                  Log              d not in ${a}
    END
```

## IF语句也支持Evaluate

```
*** Test Cases ***
case 1
    ${a}=        Set Variable        abc
    Log          ${a}
    IF           'd' not in '${a}'
                 Log                 d not in ${a} 
    END
```

## 字符串里有换行符

```
用三个单引号引起来'''${output}'''

IF    'wpa_state=COMPLETED' not in '''${output}'''
```

