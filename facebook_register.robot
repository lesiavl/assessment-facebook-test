*** Settings ***

Suite Teardown  Close All Browsers
Library  BuiltIn
Library  Selenium2Library
Library  RequestsLibrary
Library  HttpLibrary.HTTP
Library  facebook_register.py

*** Variables ***

${facebook_page}  https://www.facebook.com
${url}  http://api.temp-mail.ru
${text_assert}=  You have entered an invalid email. Please check your email address and try again.

*** Test Cases ***

Create new account on facebook
  Open Facebook Page
  ${reg_email}=  Create random email string
  Fill in the fields to create account  ${reg_email}
  Page Should Contain  ${text_assert}  loglevel=INFO
  ${email_hash}=  Get Hash From Email  ${reg_email}
  ${resp}=  Get Verification Code  ${email_hash}
  ${resp}=  Run Keyword   Get Verification Code  ${email_hash}
  Retry Until Success  ${resp}  Get Verification Code   ${email_hash}  5

#Add a profile photo
#Add a background photo
#Write post on facebook

*** Keywords ***

Open Facebook Page
  Open Browser  ${facebook_page}  browser=googlechrome
  Page Should Contain  facebook

Create Random Email String
  ${reg_email}=  Generate String
  [Return]  ${reg_email}

Fill in the fields to create account
  [Arguments]  ${reg_email}
  Input Text  id=u_0_9  Macbook
  Input Text  id=u_0_b  Air
  Wait Until Element Is Enabled   id=u_0_e  timeout=5
  Input Text  id=u_0_e  ${reg_email}
  Input Text  id=u_0_h  ${reg_email}
  ${reg_password}=  Generate String
  Input Password  id=u_0_l  ${reg_password}
  Select From List By Value  id=month  1
  Select From List By Value  id=day  29
  Select From List By Value  id=year  2008
  wait until element is enabled   id=u_0_7  timeout=5
  select radio button  sex  2
  Click Element  id=u_0_r
  Wait Until Element Is Visible  id=reg_error_inner

Get Hash From Email
  [Arguments]   ${reg_email}
  ${email_hash}=  Hash Email  ${reg_email}
  [Return]  ${email_hash}

Get Verification Code
  [Arguments]   ${email_hash}
  Create Session  verify  ${url}  verify=False
  ${resp}=  Get Request  verify  /request/mail/id/${email_hash}/format/json/
  Log To Console  ${resp}
  [Return]  ${resp}
   #parse response to get the code

Retry Until Success
  [Arguments]  ${resp}  ${keyword}  ${arg}  ${wait_time}
  :FOR  ${index}  IN RANGE  50
  \  Sleep  ${wait_time}
  \  Run Keyword Unless  ${resp.status_code} == 200  ${keyword}  ${arg}
  \  Log  ${resp.text}
  Fail  Failed with ${resp.status_code} Status Code and ${resp.text} Body
