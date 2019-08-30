*** Settings ***
Library     CXTA
Resource    cxta.robot

Documentation  Validate vPC Peer Link and Keepalive


*** Keywords ***
# Define user defined keywords if needed

*** Variables ***

${DUT}  West-Leaf-1
${VPC_KEEPALIVE_SEND_INTF}  mgmt0
${VPC_KEEPALIVE_DEST_IP}  172.31.33.68


*** Test Cases ***
1. Connect to Device.
	[Documentation]  Load the testbed file and connect to the DUT.
    load testbed
    connect to device "${DUT}"
    run "term length 0"
#${status}=  Run Keyword And Return Status  connect to device "${DUT}" via "ssh"
#Run Keyword If  ${status} == False  FAIL  Connect to device failed - check connectivity.
#Set Test Message  Connect to device - ${DUT} - SUCESSFUL.

2. Collect Running configuration
    [Documentation]  Collect running configuration 
    run "show running-config"

2. Verify feature VPC is enabled on the DUT.
	[Documentation]  Verify feature VPC is enabled on the DUT.
	run "show feature | include vpc"
	${status}=  Run Keyword And Return Status  output contains "enabled"
    Run Keyword If  ${status} == False  FAIL  Feature vPC is not enabled
	Set Test Message  Device "${DUT}" is enabled for feature VPC.

3. Obtain VPC running configuration.
	[Documentation]  Obtain VPC running configuration.
	run "show run vpc"


4. Validate VPC Keep-Alive status.
   [Documentation]  Validate VPC Keep-Alive status.
    run "show vpc peer-keepalive"
    ${status}=  Run Keyword And Return Status  values "vPC keep-alive status" and "peer is alive" exist on same line
    Run Keyword If  '${status}' == 'False'  FAIL  The VPC peer keep-alive is NOT alive - UNSUCCESSFUL
	Set Test Message  The VPC peer keep-alive is alive - SUCCESSFUL

5. Validate VPC Keep-Alive send interface status.
   [Documentation]  Validate VPC Keep-Alive send interface status.
    run "show vpc peer-keepalive"
    ${status}=  Run Keyword And Return Status  values "Sent on interface" and "${VPC_KEEPALIVE_SEND_INTF}" exist on same line
    Run Keyword If  '${status}' == 'False'  FAIL  The VPC peer keep-alive is NOT using interface ${VPC_KEEPALIVE_SEND_INTF} - UNSUCCESSFUL
	Set Test Message  The VPC peer keep-alive is using ${VPC_KEEPALIVE_SEND_INTF} - SUCCESSFUL	
	
6. Validate VPC Keep-Alive Destination Address.
   [Documentation]  Validate VPC Keep-Alive Destination Address.
    run "show vpc peer-keepalive"
    ${status}=  Run Keyword And Return Status  values "Destination" and "${VPC_KEEPALIVE_DEST_IP}" exist on same line
    Run Keyword If  '${status}' == 'False'  FAIL  The VPC peer keep-alive destination is NOT as expected - UNSUCCESSFUL
	Set Test Message  The VPC peer keep-alive destination is as expected - SUCCESSFUL
	
7. Validate VPC Peer-Link status.
   [Documentation]  Validate VPC Peer-Link status.
    run "show vpc brief"
    ${status}=  Run Keyword And Return Status  values "Peer status" and "peer adjacency formed ok" exist on same line
    Run Keyword If  '${status}' == 'False'  FAIL  The VPC peer Link is down - UNSUCCESSFUL
	Set Test Message  The VPC peer Link is up - SUCCESSFUL	