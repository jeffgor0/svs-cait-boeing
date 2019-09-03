*** Settings ***
Library     CXTA
Library     Collections
Resource    cxta.robot

Documentation  Validate SSH Connections

*** Keywords ***

*** Variables ***

${DUT}  West-Leaf-1

*** Test Cases ***

1. Connect to device
    [Documentation]  Load the testbed file and connect to the DUT.
    load testbed
    connect to device "${DUT}" via "console"
    Set Test Message  Connect to device - ${DUT} - SUCCESSFUL

2. Capture Running Configuration
    [Documentation]  Capture running configuration before the test
    run "show running-config"

3. Connect via SSH
    [Documentation]  Validate SSH connection to DUT
    ${status}=  Run Keyword And Return Status  connect to device "${DUT}" via "ssh"
    Run Keyword If  ${status} == False  FAIL  SSH connection has failed
    Set Test Message  SSH connection to ${DUT} is SUCCESSFUL

4. Disconnect from SSH
    [Documentation]  Clear SSH line and validate no SSH connections
    disconnect from device "${DUT}" connection "ssh"
    run "show users"
    ${status}=  Run Keyword and Return Status  values "admin" and "ssh" do not exist on same line
    Run Keyword If  ${status} == False  FAIL  admin is still connected via SSH!
    Set Test Message  SSH connections to ${DUT} have been cleared

5. Apply ACL on VTY Line
    [Documentation]  Apply ACL on VTY line to block SSH connections
    run "conf"
    run "line vty"
    run "ip access-class VTY-ACCESS in"
    run "show ip access-list VTY-ACCESS"

6. Test SSH Connection to Device - Should fail
    [Documentation]  Test the SSH connection after the ACL has been applied. The connection should fail this time.
    ${status}=  Run Keyword And Return Status  connect to device "${DUT}" via "ssh"
    Pass Exectuion If  ${status} == False  SSH Connection was blocked - PASS
    Run Keyword If ${status} == True  FAIL  SSH connection was not blocked by ACL
