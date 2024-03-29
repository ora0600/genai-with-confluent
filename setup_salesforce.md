# Setup Salesforce
Start with Developer Account Signup [here](https://developer.salesforce.com/signup)

In our documentation you will find a c ouple of entries how to confgure Salesforce CDC:
* Configure Salesforce CDC: see [docu](https://docs.confluent.io/cloud/current/connectors/cc-salesforce-source-cdc.html#quick-start)
* Configure SALESFORCE for CDC. [follow these steps](https://developer.salesforce.com/docs/atlas.en-us.change_data_capture.meta/change_data_capture/cdc_select_objects.htm)
* Follow this setup from [Vincent](https://github.com/vdesabou/kafka-docker-playground/tree/master/connect/connect-salesforce-cdc-sourcesalesforcesalesforceCDC)

Here are my steps with current screenshots (Jan. 2024):
1. first setup language to english, otherwise you need the words the in current language  (Setting under User) 

![CDC Config 1](img/setup1.png)

2. Switch to setup, click on the wheel (right upper corner) 
search for Change Data Capture in quick search box in Lightning (left side upper field) 

![CDC Config 2](img/setup2.png)


3. choose entity contact and lead and move to right side (selected entities) 

![CDC Config 3](img/setup3.png)

The corresponding CDC Name is ContactChangeEvent and LeadChangeEvent

4. My user is system administrator
search for apps and click on App Manager and then New Connected App (right upper corner) 

![CDC Config 4](img/setup4.png)

5. enter values for the app, and save click continue 

![CDC Config 5](img/setup5.png)

6. click Manager Consumer Details, wait for code via Email and copy consumer key and secret 
Save Consumer key and sceret for later user
The relevant pieces of information are the Consumer Key and the Consumer Secret
Click on Manage and change by edit policies and choose IP Relaxation: Relax IP restrictions  

![CDC Config 6](img/setup6.png)


7. From your personal settings, in the Quick Find box, enter Reset, and then select Reset My Security Token. Click Reset Security Token. The new security token is sent to the email address in your Salesforce personal settings. 

![CDC Config 7](img/setup7.png)

new security token is send via email, save password security token for later use

8. search for oauth and set under OAuth and openID Connect Setting the Allow OAuth User-name-Password Flows to enable  

![CDC Config 8](img/setup8.png)

9. add connected app to Profile System Administrator: search profile , click on Profiles, edit System Administrator and enable connected app 

![CDC Config 9](img/setup9.png)

Now you everything configured in Salesforce. The Salesforce Connector parameters will stored later in  `terraform/terraform.tfvars`:
```bash
 sf_user = "salesforce user"
 sf_password = "password"
 sf_cdc_name = "LeadChangeEvent"
 sf_password_token = "password token"
 sf_consumer_key = "consumer key of connected app"
 sf_consumer_secret = "consumer secret of connect app"
```
The

Salesforce CDC configuration is finished. goto [Main Readme](README.md)
