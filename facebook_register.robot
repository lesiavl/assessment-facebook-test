*** Settings ***

Suite Teardown  Close All Browsers
Library  BuiltIn
Library  Collections
Library  Selenium2Library
Library  RequestsLibrary
Library  HttpLibrary.HTTP
Library  facebook_register.py

*** Variables ***

${facebook_page}  https://www.facebook.com
${url}  https://privatix-temp-mail-v1.p.mashape.com

${phone_number}  +1 902-200-8709
${text_inBio}   I am MacBook Air, I last up to an incredible 12 hours between charges.
${text_forPost}   Make big things happen. All day long.

${global.timeout}   30

*** Test Cases ***

Create New Account On Facebook
  [Documentation]  Test Case should have verified the email provided in the FB account,
  ...  but due to problems with FB user validation and temporary mail services,
  ...  there is no possibility to do this
  ${rand_name}=  Generate Fake Name
  ${reg_email}=  Create random email string
  Open Facebook Page
  ${email_hash}=  Get Hash From Email  ${reg_email}
  Fill in the fields to create account  ${rand_name}  ${reg_email}
  ${resp}=  Get Verification Code  ${email_hash}
  ${resp}=  Run Keyword   Get Verification Code  ${email_hash}
  Retry Until Success  ${resp}  Get Verification Code   ${email_hash}  50
  Verify Email Address  ${resp}
  Page Should Contain  xpath=//span[@class="_1qv9"]/span  ${rand_name[0]}  loglevel=INFO

Add Profile Photo
  [Documentation]  Contains login keyword due to the fact, that accounts with random addresses are banned by FB
  Login To Facebook
  Upload Profile Photo
  Page Should Contain Image  xpath=//div[@class="_18nt _18nu"]/img  loglevel=INFO

Add Background Photo
  Upload Background Photo
  Page Should Contain Image  xpath=//div[@class="_2oru _4on5"]/img  loglevel=INFO

Add User Info
  Add Text In Intro
  Execute Javascript  window.scrollTo(0, 1012)
  Element Should Contain  xpath=//div[@data-testid="profile_intro_card_bio_text"]/span  ${text_inBio}

Write Post In Timeline
  Write Post
  Element Should Contain  xpath=//div[@class="_58jw"]/p  ${text_forPost}

*** Keywords ***


Create Random Email String
  ${reg_email}=  Generate String
  [Return]  ${reg_email}

Get Hash From Email
  [Arguments]   ${reg_email}
  ${email_hash}=  Hash Email  ${reg_email}
  [Return]  ${email_hash}

Get Verification Code
  [Arguments]   ${email_hash}
  ${headers}=  Create Dictionary  X-Mashape-Key=ddnF7F5nb4mshqLT4ePktDXH1MsLp1r3Ya4jsn9hlsNzcNBpbX
  Create Session  verify  ${url}  headers=${headers}  verify=True
  ${resp}=  Get Request  verify  /request/mail/id/${email_hash}
  Log To Console  ${url}/request/mail/id/${email_hash}
  Log To Console  ${resp.text}
  [Return]  ${resp}

Verify Email Address
  [Arguments]  ${resp}
  ${verif_code}=  Get Json Value  ${resp}  /mail_subject
  ${verif_code}=  Format String  ${verif_code}
  [Return]  ${verif_code}

Retry Until Success
  [Arguments]  ${resp}  ${keyword}  ${arg}  ${wait_time}
  :FOR  ${index}  IN RANGE  5
  \  Sleep  ${wait_time}
  \  Run Keyword Unless  ${resp.status_code} == 200  ${keyword}  ${arg}
  \  Log  ${resp.text}
  Fail  Failed with ${resp.status_code} Status Code and ${resp.text} Body

Close Dialogue Box
  ${present}=  Run Keyword And Return Status   Element Should Be Visible  xpath=//a[@action='cancel']
  Run Keyword If  ${present}  Click Element  xpath=//a[@action='cancel']

Open Facebook Page
  Open Browser  ${facebook_page}  browser=googlechrome  alias=facebook
  Page Should Contain  facebook

Fill in the fields to create account
  [Arguments]  ${rand_name}  ${reg_email}
  Input Text  id=u_0_9  ${rand_name[0]}
  Input Text  id=u_0_b  ${rand_name[1]}
  Wait Until Element Is Visible   id=u_0_e  ${global.timeout}
  ${reg_email}=  Set Variable  ${rand_name[0]}${rand_name[1]}${reg_email}
  Input Text  id=u_0_e  ${reg_email}
  Input Text  id=u_0_h  ${reg_email}
  Wait Until Element Is Visible  id=u_0_l  ${global.timeout}
  ${fb_password}=  Generate String
  Input Password  id=u_0_l  ${fb_password}
  Select From List By Value  id=month  1
  Select From List By Value  id=day  29
  Select From List By Value  id=year  1990
  wait until element is enabled   id=u_0_7  ${global.timeout}
  Select Radio Button  sex  2
  Click Element  id=u_0_r
  Close Dialogue Box

Login To Facebook
  Go To   ${facebook_page}
  Wait Until Element Is Visible  id=email  ${global.timeout}
  Input Text  id=email  pulpfiction_fb@meta.ua
  Input Text  id=pass   qwerasdfzxcv1234
  Click Element  xpath=//input[@value='Log In']
  ${present}=  Run Keyword And Return Status   Element Should Be Visible  xpath=//a[@action='cancel']
  Run Keyword If  ${present}  Click Element  xpath=//a[@action='cancel']
  Dismiss Alert   accept=False
  Wait Until Element Is Visible  xpath=//a[@title="Profile"]  ${global.timeout}
  Click Element  xpath=//a[@title="Profile"]

Upload Profile Photo
  Close Dialogue Box
  Wait Until Element Is Visible  xpath=//a[@title="Profile"]  ${global.timeout}
  Click Element  xpath=//a[@title="Profile"]
  Wait Until Element Is Visible  css=#pagelet_timeline_profile_actions > a  ${global.timeout}
  Click Element  css=#pagelet_timeline_profile_actions > a
  Wait Until Element Is Visible  xpath=//img[@class="_18nv img"]  ${global.timeout}
  Click Element  xpath=//div[@role='presentation']/i
  ${img}=  relative2absolute  ./pulpfiction.jpg
  Wait Until Element Is Enabled  xpath=//a[@data-action-type='upload_photo']/div/input  ${global.timeout}
  Choose File  xpath=//a[@data-action-type='upload_photo']/div/input  ${img}
  Wait Until Element Is Enabled  xpath=//button[@data-testid="profilePicSaveButton"]  ${global.timeout}
  Click Element  xpath=//button[@data-testid="profilePicSaveButton"]
  Wait Until Element Is Enabled  xpath=//a[@title="Close"]  ${global.timeout}
  Wait Until Keyword Succeeds  2min  5sec  Click Element  xpath=//a[@title="Close"]

Upload Background Photo
  Close Dialogue Box
  Wait Until Element Is Visible  css=#pagelet_timeline_profile_actions > a  ${global.timeout}
  Click Element  css=#pagelet_timeline_profile_actions > a
  Wait Until Element Is Visible  xpath=//div[@role='button']/i  ${global.timeout}
  Click Element  xpath=//div[@role='button']/i
  ${backgroung_img}=  relative2absolute  ./pulpfiction.jpg
  Wait Until Element Is Enabled  xpath=//input[@name='cover_pic']  ${global.timeout}
  Choose File  xpath=//input[@name='cover_pic']  ${backgroung_img}
  Wait Until Element Is Visible  xpath=//button[@data-testid='cover_photo_save_button']  ${global.timeout}
  Click Element  xpath=//button[@data-testid='cover_photo_save_button']

Add Text In Intro
  Go To   ${facebook_page}
  Close Dialogue Box
  Wait Until Element Is Visible  xpath=//a[@title="Profile"]  ${global.timeout}
  Click Element  xpath=//a[@title="Profile"]
  Delete Text From Box
  Execute Javascript  window.scrollTo(0, 416)
  Wait Until Element Is Visible  id=profile_intro_card_bio  ${global.timeout}
  Click Element  id=profile_intro_card_bio
  Wait Until Element Is Enabled  xpath=//textarea[@data-testid="profile_intro_card_edit_bio_text_area"]  ${global.timeout}
  Input Text  xpath=//textarea[@data-testid="profile_intro_card_edit_bio_text_area"]  ${text_inBio}
  Click Element  xpath=//button[@data-testid="profile_intro_card_save_bio_button"]
  Reload Page

Delete Text From Box
  ${present}=  Run Keyword And Return Status   Element Text Should Be  xpath=//div[@data-testid="profile_intro_card_bio_text"]/span  ${text_inBio}
  log to console  ${present}
  Run Keyword If  ${present}  Click Element  xpath=//a[@tooltip="Edit"]/i
  Wait Until Element Is Enabled  xpath=//textarea[@data-testid="profile_intro_card_edit_bio_text_area"]  ${global.timeout}
  Clear Element Text  xpath=//textarea[@data-testid="profile_intro_card_edit_bio_text_area"]
  Click Element  xpath=//button[@data-testid="profile_intro_card_save_bio_button"]

Write Post
  Go To   ${facebook_page}
  Close Dialogue Box
  Wait Until Element Is Visible  xpath=//a[@title="Profile"]  ${global.timeout}
  Click Element  xpath=//a[@title="Profile"]
  Focus  css=#pagelet_timeline_profile_actions > a
  Execute Javascript  window.scrollTo(0, 0)
  Wait Until Element Is Visible  xpath=//div[@class="_1mf _1mj"]  ${global.timeout}
  Click Element  xpath=//div[@class="_1mf _1mj"]
  ${el}=  Set Variable  xpath=(//div[@role="presentation"])[4]
  ${textarea_id}=   Get Element Attribute   ${el}@id
  Execute Javascript  (document.querySelector('#${textarea_id} > div > div > div > div > div > div > div > span > span').textContent = ${text_forPost})
  Click Element  xpath=//button[@data-testid="react-composer-post-button"]
  Wait Until Element Is Enabled  xpath=//a[@title="Profile"]  ${global.timeout}
