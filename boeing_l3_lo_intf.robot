*** Settings ***
Library     CXTA
Resource    cxta.robot
Documentation  Validate L3 Loopback interface state and configuration

*** Keywords ***
# Define user defined keywords if needed

*** Variables ***

${DUT}  West-Leaf-1
${INTERFACE}  loopback0
@{ADMIN_STATE}  up
@{IP_ADDR}  172.17.0.7
@{NET_MASK}  32

*** Test Cases ***

1. Connect to Device
    [Documentation]  Load the testbed file and connect to the DUT.
    load testbed
    connect to device "${DUT}" via "vty"
    Log  Connect to device - ${DUT} - SUCCESSFUL.

2. Obtain the running Configuration of the L3-Interface
    [Documentation]  Obtain the running Configuration of the L3-Interface.
    run "show run interface ${INTERFACE}"

3. Validate the Layer-3 interface state
    [Documentation]  Validate the interface state is "admin up"
    ${json}=  run parsed json "show interface ${INTERFACE}"
    ${state}=  Get Value From Json  ${json}  $..TABLE_interface.ROW_interface.admin_state
    ${status}=  Run Keyword and Return Status  Should Be True  "${state}" == "${ADMIN_STATE}"
    Log  ${INTERFACE} is up
    Run Keyword If  ${status} == False  FAIL  ${INTERFACE} is not up

4. Validate the Layer-3 interface configuration details
    [Documentation]  validate the Layer-3 interface configuration details
    ${json}=  run parsed json "show interface ${INTERFACE}"
    ${CFG_IP_ADDR}=  Get Value From Json  ${json}  $..TABLE_interface.ROW_interface.eth_ip_addr
    ${CFG_NET_MASK}=  Get Value From Json  ${json}  $..TABLE_interface.ROW_interface.eth_ip_mask
    ${status}=  Run Keyword And Return Status  should be true  "${IP_ADDR}" == "${CFG_IP_ADDR}"
    Log  '${IP_ADDR}' == '${CFG_IP_ADDR}'
    Run Keyword If  '${status}' == 'False'  FAIL  The interface %{INTERFACE} is not configured with the right IP ${IP_ADDR}
    ${status}=  Run Keyword And Return Status  should be true  "${NET_MASK}" == "${CFG_NET_MASK}"
    Log  ${NET_MASK} == ${CFG_NET_MASK}
    Run Keyword If  '${status}' == 'False'  FAIL  The interface ${INTERFACE} is not configured with the right NET_MASK ${NET_MASK}
