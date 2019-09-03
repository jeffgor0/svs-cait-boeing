*** Settings ***
Library     CXTA
Resource    cxta.robot
Documentation  Validate SVI interface details

*** Keywords ***
# Define user defined keywords if needed

*** Variables ***

${DUT}  West-Leaf-1
${INTERFACE}  Vlan100
${IP_ADDR}  100.100.100.1/24

*** Test Cases ***

1. Connect to Device
    [Documentation]  Load the testbed file and connect to the DUT.
    load testbed
    connect to device "${DUT}" via "ssh"
    run "term len 0"
    Log  Connect to device - ${DUT} - SUCCESSFUL.

2. Obtain Running Configuration from device
    [Documentation]  Obtain running configuration snapshot from device under test
    run "show running-config"

2. Obtain the running Configuration of the L3-Interface
    [Documentation]  Obtain the running Configuration of the L3-Interface.
    run "show run interface ${INTERFACE}"

3. Validate the Layer-3 interface state
    [Documentation]  Validate the interface state is  "up/up"
    run "show interface ${INTERFACE}"
    ${status}=  Run Keyword And Return Status  output contains "${INTERFACE} is up"
    Run Keyword If  '${status}' == 'False'  FAIL  ${INTERFACE} is not up
    Set Test Message  ${INTERFACE} is up

4. Validate the Layer-3 interface configuration details
    [Documentation]  validate the Layer-3 interface configuration details
    run "show run interface ${INTERFACE}"
    ${status}=  Run Keyword And Return Status  output contains "${IP_ADDR}"
    Run Keyword If  '${status}' == 'False'  FAIL  ${INTERFACE} is not configured with correct IP/mask
    Set Test Message  ${INTERFACE} is configured with  ${IP_ADDR}