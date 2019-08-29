*** Settings ***
Library     CXTA
Resource    cxta.robot

Documentation  Validate LACP feature and Trunking


*** Keywords ***
# Define user defined keywords if needed

*** Variables ***

${DUT}  West-Leaf-1
${PORT_CHANNEL}  Po1
@{NATIVE-VLAN}  1000
@{ALLOWED_VLAN}  1-2,308,322,324,328,332,340,344,352,366,1000,3011

*** Test Cases ***
1. Connect to Device.
    [Documentation]  Load the testbed file and connect to the DUT.
    load testbed
    connect to device "${DUT}"
    Log  Connect to device - "${DUT}" - SUCESSFUL.

2. Verify feature LACP is enabled on the DUT.
    [Documentation]  Verify feature LACP is enabled on the DUT.
    run "show feature | include lacp"
    output contains "enabled"
    Log  Device "${DUT}" is enabled for feature LACP

3. Obtain port-channel running configuration.
    [Documentation]  Obtain port-channel running configuration.
    run "show run interface ${PORT_CHANNEL}"

4. Verify port-channel is configured for trunking.
    [Documentation]  Verify port-channel is configured for trunking.
    run "show run interface ${PORT_CHANNEL}"
    output contains "mode trunk"

5. Validate port-channel interface native VLAN.
    [Documentation]  Validate port-channel interface native VLAN.
    ${json}=  run parsed json "show interface ${PORT_CHANNEL} trunk"
    ${CFG-NATIVE-VLAN}=  Get Value From Json  ${json}  $..TABLE_interface.ROW_interface.native
    #${CFG-NATIVE-VLAN}=  get parsed "native"
    ${status}=  Run Keyword And Return Status  Should Be True  "${CFG-NATIVE-VLAN}" == "${NATIVE-VLAN}"
    Log  '${CFG-NATIVE-VLAN}' == '${NATIVE-VLAN}'
    Run Keyword If  '${status}' == 'False'  FAIL  The interface ${PORT_CHANNEL} native VLAN is NOT configured correctly.
    Log  The interface ${PORT_CHANNEL} native VLAN is configured correctly.

6. Validate port-channel interface allowed VLAN list.
    [Documentation]  Validate port-channel interface allowed VLAN list.
    ${json}=  run parsed json "show interface ${PORT_CHANNEL} trunk"
    ${CFG-ALLOWED-VLAN}=  Get Value From Json  ${json}  $..TABLE_allowed_vlans.ROW_allowed_vlans.allowedvlans
    #${CFG-ALLOWED-VLAN}=  get parsed "allowedvlans"
    ${status}=  Run Keyword And Return Status  should be true  "${CFG-ALLOWED-VLAN}" == "${ALLOWED_VLAN}"
    Log  '${CFG-ALLOWED-VLAN}' == '${ALLOWED_VLAN}'
    Run Keyword If  '${status}' == 'False'  FAIL  The interface ${PORT_CHANNEL} is NOT configured for allowed VLAN list.
    Log  The interface ${PORT_CHANNEL} is configured for allowed VLAN list.