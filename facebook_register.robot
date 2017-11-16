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
${phone_number}=  +1 902-200-8716
${facebook_reg_error}=  Sorry, we are not able to process your registration.
${text_inBio}=  I am MacBook Air, I last up to an incredible 12 hours between charges.
${text_forPost}=  Make big things happen. All day long.

${global.timeout}   10

*** Test Cases ***

Create New Account On Facebook
  Open Facebook Page
  Fill in the fields to create account

  Page Should Contain  ${phone_number}  loglevel=INFO
  Go To Profile Page

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

Fill in the fields to create account
  ${rand_name}=  Generate Fake Name
  Input Text  id=u_0_9  ${rand_name[0]}
  Input Text  id=u_0_b  ${rand_name[1]}
  Wait Until Element Is Visible   id=u_0_e  ${global.timeout}
  Input Text  id=u_0_e  ${phone_number}
  Wait Until Element Is Visible  id=u_0_l  ${global.timeout}
  ${reg_password}=  Generate String
  Input Password  id=u_0_l  ${reg_password}
  Select From List By Value  id=month  1
  Select From List By Value  id=day  29
  Select From List By Value  id=year  2008
  wait until element is enabled   id=u_0_7  ${global.timeout}
  Select Radio Button  sex  2
  Click Element  id=u_0_r

Go To Profile Page
  Wait Until Element Is Visible  xpath=//a[@title="Profile"]  ${global.timeout}
  Click Element  xpath=//a[@title="Profile"]

Upload Profile Photo
  Wait Until Element Is Visible  class=profilePicThumb  ${global.timeout}
  Click Element  class=profilePicThumb
  Wait Until Element Is Visible  class=_3jk
  ${img}=  relative2absolute  ./macbook-air.jpeg
  Choose File  (//div[@class="_3jk"]/input)[3]  ${img}
  Wait Until Page Contains Element  data-testid=profilePicSaveButton  ${global.timeout}
  Click Element  data-testid=profilePicSaveButton

Upload Background Photo
  Wait Until Element Is Visible  css=#u_0_15  ${global.timeout}
  Click Element  css=#pagelet_timeline_profile_actions > a
  Wait Until Element Is Visible  class=_57ns _p  ${global.timeout}
  Click Element  class=_57ns _p
  ${backgroung_img}=  relative2absolute  ./open_graph_logo.png
  Choose File  name=cover_pic  ${backgroung_img}
  Wait Until Element Is Visible  data-testid=cover_photo_save_button  ${global.timeout}
  Click Element  data-testid=cover_photo_save_button

Add Text In Bio
  Wait Until Element Is Visible  class=_5jgy  ${global.timeout}
  Input Text  class=_5jgy  ${text_inBio}
  Click Element  xpath=(//button[@type="submit"])[9]

Write Post
  Wait Until Element Is Visible  xpath=//a[@title="Profile"]  ${global.timeout}
  Execute Javascript  window.scrollTo(0, 543)
  Click Element  class=_1mf _1mj
  Wait Until Element Is Visible  data-testid=react-composer-post-button  ${global.timeout}
  Input Text  class=_1mf _1mj  ${text_forPost}
  Click Element  class=_3nc_
  Wait Until Element Is Visible  class=_3vgi  ${global.timeout}
  Click Element  class=_5zfs
  Click Element  class=_1mf _1mj
  Click Element  data-testid=react-composer-post-button
  Wait Until Element Is Enabled  xpath=//a[@title="Profile"]  ${global.timeout}
