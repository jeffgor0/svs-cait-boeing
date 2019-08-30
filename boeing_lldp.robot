*** Settings ***
Library     CXTA
Resource    cxta.robot
Documentation  Validate LACP Port channel is up and has expected members

*** Keywords ***
# Define user defined keywords if needed

*** Variables ***


${DUT}  West-Leaf-1
@{NEIGHBOR_LIST}  West-Leaf-2  West-Spine-1


*** Test Cases ***


1. Connect to Device
    load testbed
    connect to device "${3850_DUT}"
    run "terminal length 0"
2. Validate LLDP Feature is enabled
    [Documentation]  Use show feature command to validate LLDP
    run "show feature | include lldp"
    ${status}=  Run Keyword and Return Status  output contains "lldp"
    Run Keyword If  '${status}' == 'False'  FAIL  LLDP is not enabled on ${DUT}
    Set Test Message  ${DUT} is enabled for LLDP

3. Run LLDP show commands
    [Documentation]  Capture LLDP running configuration and commands
    run "show run lldp"
    run "show lldp neighbors"
    run "show lldp neighbors detail"

4. Validate LLDP Neighbors Are As expected
    [Documentation]  Capture LLDP neighbors and compare them against the expected list of neighbors
    run "show lldp neighbors"
    FOR  ${NEIGHBOR}  IN  @{NEIGHBOR_LIST}
        ${status}=  Run Keyword And Return Status  output contains ${NEIGHBOR}
        Run Keyword If  '${status}' == 'False'  FAIL  LLDP ${NEIGHBOR} is not seen
        Set Test Message  ${NEIGHBOR} is seen by the DUT\n  append=True
    END