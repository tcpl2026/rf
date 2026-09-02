*** Settings ***
Library    SeleniumLibrary
Library    SSHLibrary

Resource    ../variables/variables.robot
Resource    ../keywords/reset_and_setup_asus_ap.robot
Resource    ../keywords/config_asus_ap.robot

*** Test Cases ***
case 1
    Config ASUS AP    band=2g    ssid=test2g    bw=20m    channel=6    wifi_mode=ax    security_mode=psk2    key=1234567890
    Config ASUS AP    band=5g    ssid=test5g    bw=80m    channel=149/80    wifi_mode=ac    security_mode=psk2    key=1234567890
