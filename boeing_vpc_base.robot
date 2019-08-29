*** Settings ***
Library     CXTA
Library     Collections
Resource    cxta.robot

Documentation  Test case: Validate VPC configuration
...            -Obtain vPC Configuration
...            -Validate vPC role
...            -Validate vPC peer configuration
...            -Validate vPC configuration consistency status

*** Keywords ***
# Define user defined keywords if needed

*** Variables ***

${DUT}=  West-Leaf-1
@{VPC-PEER-STATUS}=  peer-ok
@{VPC-PEER-CONSISTENCY-STATUS}=  SUCCESS
@{VPC-ROLE}=  primary
@{VPC-TYPE2-CONSISTENCY-STATUS}=  consistent


*** Test Cases ***
1. Connect to Device.
	  [Documentation]  Load the testbed file and connect to the DUT.
    load testbed
    connect to device "${DUT}" via "vty"
	  Log  Connect to device - "${DUT}" - SUCESSFUL.

2. Verify feature VPC is enabled on the DUT.
    [Documentation]  Verify feature VPC is enabled on the DUT.
    run "show feature | i vpc"
    output contains "enabled"
    Log  Device "${DUT}" is enabled for feature VPC.

3. Obtain VPC running configuration.
    [Documentation]  Obtain VPC running configuration.
    run "show run vpc"

4. Validate VPC peer configuration.
    [Documentation]  Validate VPC peer configuration.
    ${peer_status}=  run parsed json "show vpc"
    ${CFG-VPC-PEER-STATUS}=  Get Value From Json  ${peer_status}  $..vpc-peer-status
    ${status}=  Run Keyword and Return Status  Should Be True  "${CFG-VPC-PEER-STATUS}" == "${VPC-PEER-STATUS}"
    Log  ${CFG-VPC-PEER-STATUS} == ${VPC-PEER-STATUS}
    Run Keyword If  ${status} == False  FAIL  The VPC peer adjacency is NOT formed - UNSUCCESSFUL.
    Log  The VPC peer adjacency is formed - SUCCESSFUL.

5. Validate VPC configuration consistency status.
    [Documentation]  Validate VPC configuration consistency status.
    ${consistency_status}=  run parsed json "show vpc"
    ${CFG-VPC-PEER-CONSISTENCY-STATUS}=  Get Value From Json  ${consistency_status}  $..vpc-peer-consistency-status
    ${status}=  Run Keyword And Return Status  should be true  "${CFG-VPC-PEER-CONSISTENCY-STATUS}" == "${VPC-PEER-CONSISTENCY-STATUS}"
    Log  '${CFG-VPC-PEER-CONSISTENCY-STATUS}' == '${VPC-PEER-CONSISTENCY-STATUS}'
    Run Keyword If  '${status}' == 'False'  FAIL  The VPC configuration consistency is NOT formed - UNSUCCESSFULL.
    Log  The VPC configuration consistency is formed - SUCCESSFULL.

6. Validate VPC role configured.
    [Documentation]  Validate VPC role configured.
    ${vpc_role}=  run parsed json "show vpc"
    ${CFG-VPC-ROLE}=  Get Value From Json  ${vpc_role}  $..vpc-role
    ${status}=  Run Keyword And Return Status  should be true  "${CFG-VPC-ROLE}" == "${VPC-ROLE}"
    Log  '${CFG-VPC-ROLE}' == '${VPC-ROLE}'
    Run Keyword If  '${status}' == 'False'  FAIL  The VPC role is NOT as expected - UNSUCCESSFUL.
    Log  The VPC role is as expected - SUCCESSFUL.
    Log  Configured VPC role is ${CFG-VPC-ROLE}.

7. Validate VPC Type2 consistency status.
   [Documentation]  Validate VPC Type2 consistency status.
    ${type2_status}=  run parsed json "show vpc"
    ${CFG-VPC-TYPE2-CONSISTENCY-STATUS}=  Get Value From Json  ${type2_status}  $..vpc-type-2-consistency
    ${status}=  Run Keyword And Return Status  should be true  "${CFG-VPC-TYPE2-CONSISTENCY-STATUS}" == "${VPC-TYPE2-CONSISTENCY-STATUS}"
    Log  '${CFG-VPC-TYPE2-CONSISTENCY-STATUS}' == '${VPC-TYPE2-CONSISTENCY-STATUS}'
    Run Keyword If  '${status}' == 'False'  FAIL  The VPC Type2 consistency status is NOT as expected - UNSUCCESSFULL.
    Log  The VPC Type2 consistency status is as expected - UNSUCCESSFULL.
    Log  The VPC Type2 consistency status is ${CFG-VPC-TYPE2-CONSISTENCY-STATUS}.