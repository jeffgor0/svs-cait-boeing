*** Settings ***
Library     CXTA
Resource    cxta.robot
Documentation  Validate LACP Port channel is up and has expected members

*** Keywords ***
# Define user defined keywords if needed

*** Variables ***

${DUT}  West-Leaf-1
${BUNDLE}  Po1
@{BUNDLE_INTF}  eth1/2  eth1/3

*** Test Cases ***
1. Connect to Device
	[Documentation]  Load the testbed file and connect to the DUT.
    load testbed
    connect to device "${DUT}"
    run "term len 0"
	Set Test Message  Connect to device - "${DUT}" - SUCCESSFUL.

2. Obtain Running configuration
    [Documentation]  Obtain running configuration from device
    run "show running-config"
	
3. Obtain the running Configuration of the Interface
    [Documentation]  Obtain the running Configuration of the Interface.
	run "Show run interface ${BUNDLE}"

4. Validate interfaces are configured for LACP port channel
   [Documentation]  Validate interface is a part of the port-channel
    FOR  ${INTERFACE}  IN  @{BUNDLE_INTF} 
        run "show interface ${INTERFACE}"
        ${status}=  Run Keyword And Return Status  output contains "mode active"
        Run Keyword If  '${status}' == 'False'  FAIL  ${INTERFACE} is not configured for LACP port channel
        Set Test Message  ${INTERFACE} is configured for LACP port channel\n  append=True
    END

5. Validate LACP Port channel is up
    [Documentation]  Validate LACP port channel is up
    run "show port-channel summary"
    FOR  ${INTERFACE}  IN  @{BUNDLE_INTF}
        ${status}=  Run Keyword And Return Status  values "${BUNDLE}" and ${INTERFACE} exist on same line
        Run Keyword If  '${status}' == 'False'  FAIL  ${INTERFACE} is not up in ${BUNDLE}
        Set Test Message  ${INTERFACE} is up in ${BUNDLE}\n  append=True
    END
