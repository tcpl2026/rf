# 自定义关键字

```
import time

def mylog(msg):
    '''
    output my log
    '''
    today = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    print("[" + msg + "]" + " "*4 + today)

if __name__ == "__main__":
    mylog("ok")
```

```
*** Settings ***
Library            somelog.py


*** Test Cases ***
test_mylib
    mylog        hello world
    log          hello world
```
