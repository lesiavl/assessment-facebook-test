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
${text_inBio}=  I am MacBook Air, I last up to an incredible 12 hours between charges.
${text_forPost}=  Make big things happen. All day long.

*** Test Cases ***

Create New Account On Facebook
  Open Facebook Page
#  ${reg_email}=  Create random email string      ${reg_email}
  Fill in the fields to create account  talkshowhost8@gmail.com
  Page Should Contain  ${text_assert}  loglevel=INFO
  ${email_hash}=  Get Hash From Email  ${reg_email}
  Retry Until Success  ${resp}  Get Verification Code   ${email_hash}  5
  ${resp}=  Get Verification Code  ${email_hash}
  ${verif_code}=  Get Json Value  ${resp.text}  /code
  Enter Verification Code   ${verif_code}

Add Profile Photo
  Go To Profile Page
  Upload Profile Photo
  Page Should Contain  class=profilePic img  loglevel=INFO

Add Background Photo
  Go To Profile Page
  Upload Background Photo
  Page Should Contain  class=coverChangeThrobber img  loglevel=INFO

Add User Description
  Add Text In Bio
  Execute Javascript  window.scrollTo(0, 1209)
  Element Should Contain  data-testid=profile_intro_card_bio_text  ${text_inBio}

Write Post In Timeline
  Write Post
  Element Should Contain  class=_5mfr _47e3  ${text_forPost}


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
  Select Radio Button  sex  2
  Click Element  id=u_0_r
  Wait Until Element Is Visible  id=reg_error_inner

Get Hash From Email
  [Arguments]   ${reg_email}
  ${email_hash}=  Hash Email  ${reg_email}
  [Return]  ${email_hash}

Retry Until Success
  [Arguments]  ${resp}  ${keyword}  ${arg}  ${wait_time}
  :FOR  ${index}  IN RANGE  50
  \  Sleep  ${wait_time}
  \  Run Keyword Unless  ${resp.status_code} == 200  ${keyword}  ${arg}
  \  Log  ${resp.text}
  Fail  Failed with ${resp.status_code} Status Code and ${resp.text} Body

Get Verification Code
  [Arguments]   ${email_hash}
  Create Session  verify  ${url}  verify=False
  ${resp}=  Get Request  verify  /request/mail/id/${email_hash}/format/json/
  Log To Console  ${resp}
  [Return]  ${resp}
   #parse response to get the code

Enter Verification Code
  [Arguments]  ${resp}
  Wait Until Element Is Visible  id=code_in_cliff  timeout=5
  Input Text  id=code_in_cliff  ${resp.text}
  Wait Until Element Is Enabled  id=u_c_l  timeout=5
  Click Element  id=u_c_l
  Wait Until Element Is Visible  xpath=(//a[@href="#"])[8]  timeout=5
  Click Element  xpath=(//a[@href="#"])[8]

Go To Profile Page
  Wait Until Element Is Visible  xpath=//a[@title="Profile"]  timeout=5
  Click Element  xpath=//a[@title="Profile"]

Upload Profile Photo
  Wait Until Element Is Visible  class=profilePicThumb  timeout=5
  Click Element  class=profilePicThumb
  Wait Until Element Is Visible  class=_3jk
  ${img}=  relative2absolute  ./macbook-air.jpeg
  Choose File  (//div[@class="_3jk"]/input)[3]  ${img}
  Wait Until Page Contains Element  data-testid=profilePicSaveButton  timeout=5
  Click Element  data-testid=profilePicSaveButton

Upload Background Photo
  Wait Until Element Is Visible  css=#u_0_15  timeout=10
  Click Element  css=#pagelet_timeline_profile_actions > a
  Wait Until Element Is Visible  class=_57ns _p  timeout=10
  Click Element  class=_57ns _p
  ${backgroung_img}=  relative2absolute  ./open_graph_logo.png
  Choose File  name=cover_pic  ${backgroung_img}
  Wait Until Element Is Visible  data-testid=cover_photo_save_button  timeout=10
  Click Element  data-testid=cover_photo_save_button

Add Text In Bio
  Wait Until Element Is Visible  class=_5jgy  timeout=10
  Input Text  class=_5jgy  ${text_inBio}
  Click Element  xpath=(//button[@type="submit"])[9]

Write Post
  Wait Until Element Is Visible  xpath=//a[@title="Profile"]  timeout=10
  Execute Javascript  window.scrollTo(0, 543)
  Click Element  class=_1mf _1mj
  Wait Until Element Is Visible  data-testid=react-composer-post-button  timeout=10
  Input Text  class=_1mf _1mj  ${text_forPost}
  Click Element  class=_3nc_
  Wait Until Element Is Visible  class=_3vgi  timeout=10
  Click Element  class=_5zfs
  Click Element  class=_1mf _1mj
  Click Element  data-testid=react-composer-post-button
  Wait Until Element Is Enabled  xpath=//a[@title="Profile"]  timeout=10
