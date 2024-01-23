# generative AI with Confluent 

This is a real-time generative AI demo with Confluent Cloud. The idea was influenced by [this](https://www.udemy.com/course/langchain/?referralCode=D981B8213164A3EA91AC) awesome training in Udemy lead by Eden Marco (LangChain- Develop LLM powered applications with LangChain). Eden Marco gave me the promoted link ^.
Eden Marco do a every good intro into Lngchain LLM development in Python. I took the ice-breaker idea and moved it into a real use case running Data in Motion with Confluent and AI.

Use Case:
<table><tr><td>Having Leads in CRM and do need more content for a cold calling. Content like Short Summary, some fact and ice-breakers will be generated by AI and will help the Sales Development person to get all the information she/he need more or less in real-time without any further research investment. This save money, and increase value for the prospect and of course sales development person.</td></tr></table>


The repo will deploy:
* Confluent CLoud Basic Cluster
* a fully-managed Salesforce CDC Connector
* Flink SQL Pool
* 3 Topics with Schema (AVRO)
    * salesforce_contacts - coming for CDC Connector (Salesforce)
    * salesforce_myleads - a transformed format with Flink SQL
    * salesforce_mycalls - myleads added with ice-breaker content/output

![alt Demo Architecture](img/architecture.png)

Please Clone this repository on your desktop:
```bash
cd $HOME # or what-ever directory you want to use
git clone https://github.com/ora0600/genai-with-confluent.git
cd genai-with-confluent/terraform/
```

# pre-reqs

The demoing execution is fully automated, but before execution, you need to setup a couple things here:

## Salesforce developer Login

Follow my setup in Salesforce with screenshots [here](setup_salesforce.md)

## Confluent Cloud

You need a working account for Confluent Cloud. Sign-up with Confluent Cloud is very easy and you will get a $400 budget for your first trials for free. If you don't have a working Confluent Cloud account please [Sign-up to Confluent Cloud](https://www.confluent.io/confluent-cloud/tryfree/?utm_campaign=tm.campaigns_cd.Q124_EMEA_Stream-Processing-Essentials&utm_source=marketo&utm_medium=workshop).

## Tools

* install kafka or Confluent Platform (we need the tools kafka-avro-consumer-console and kafka-avro-producer-console), [Downlod Confluent Platform](https://www.confluent.io/get-started/?product=self-managed)
* Local install Confluent CLI, [install the cli](https://docs.confluent.io/confluent-cli/current/install.html) 
* install terraform on your desktop. [Follow the installation guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* Install iterm 2, [see](https://iterm2.com/)
* I am running still completely on bash on my Intel Mac. Environment Variables are set in `~/.bash_profile`, if you running other OS or use other Shells like zsh, please setup that script can execute kafka tools without absolution path.
* install Python3 on MacOS: [Downland](https://www.python.org/downloads/macos/) and follow the instructions
* Install all the python modules we need;
```bash
pip3 install confluent_kafka
pip3 install requests
pip3 install fastavro
pip3 install avro
pip3 install jproperties
pip3 install langchain
pip3 install openai
pip3 install langchain_openai
pip3 install -U langchain-community
pip3 install google-search-results
pip3 install Flask
pip3 install langchain_core
pip3 install pydantic
```

## API Keys from Confluent Cloud Cluster and Salesforce

For Confluent Cloud: Create API Key in Confluent Cloud via CLI (In my case as OrgAdmin):
```bash
    confluent login
    confluent api-key create --resource cloud --description "API for terraform"
    # It may take a couple of minutes for the API key to be ready.
    # Save the API key and secret. The secret is not retrievable later.
    #+------------+------------------------------------------------------------------+
    #| API Key    | <your generated key>                                             |
    #| API Secret | <your generated secret>                                          |
    #+------------+------------------------------------------------------------------+
```

Copy all the Parameter for Confluent Cloud into the `terraform.tfvars` file by execute the following command with your own data:
```bash
cat > terraform.tfvars <<EOF
confluent_cloud_api_key = "{Cloud API Key}"
confluent_cloud_api_secret = "{Cloud API Key Secret}"
sf_user= "salesforce user"
sf_password = "password"
sf_cdc_name = "LeadChangeEvent"
sf_password_token = "password token"
sf_consumer_key = "consumer key of connected app"
sf_consumer_secret = "consumer secret of connect app"
EOF
```
Terraform will take all these parameters and doing the configuraiton for you and finally deploy all confluent cloud resources including service accounts and role bindings.

## Generative AI API we use

We use langchain LLM version 0.1 [Langchain Docu](https://python.langchain.com/docs/get_started/introduction)

HINT:
<table><tr><td>Now, it will cost money. Unfortunately the APIs are not for free. I spend 10$ for open AI, 10$ for ProxyCurl API and SERP API is still in free status.</td></tr></table>

First we need a key which allow us to use OpenAI. Follow steps from [here](https://platform.openai.com/docs/quickstart/account-setup) to create an Account and then an API Key only.

Next Task: Create proxycurl api key. ProxyCurl will be used to scrape Linkedin. Sign Up to proxyurl and buy credits for 10$ (or whatever you think is enough, maybe you start more less) , [follow these Steps](https://nubela.co/proxycurl). You get 10 free credit. Which could be enough for a simple demo.

To be able to search in Google the correct linkedin Profile URL, we need a API key of SERP API from [here](https://serpapi.com/).

Now, put all Keys into `env-vars` file by executing the command:
```bash
cat > env-vars <<EOF
export PYTHONPATH=/YOURPATH
export OPENAI_API_KEY=YOUR openAI Key
export PROXYCURL_API_KEY=YOUR ProxyURL Key
export SERPAPI_API_KEY=Your SRP API KEy
EOF
```

Congratulation the preparation is done. This was a huge setup, I know. But all the rest is "one command execution"

# Execute the generative AI Demo with Confluent Cloud, Salesforce and langchain LLM
Now comes the easy part. Just execute terraform.
Please be aware to not use the terminal application iterm2 right now. Please use e.g. the standard terminal of MacOS.
HINT:
<table><tr><td>With terraform apply erverything will be deployed and a script is calling iterms to splitt three windows and start in each window a different program. If you start terraform from iterm2 Terminal, then the window splitt will not work. So, please to have to full automation do not start `terraform apply` from iterm2. </td></tr></table>

Execute terraform and all confluent cloud resources will deployed automatically:
```bash
cd terraform
terraform init
terraform plan
terraform apply
``` 

This will take a while till all Confluent Cloud resources are provisioned. If this it is done, iterm2 terminals will be opened automatically and three services are executed.

![alt terminals](img/terminals.png)

Ok, now you need to add a new lead into Salesforce. This is the only manual step in that demo.

![alt terminals](img/new_lead.png)

The generative AI will take new lead from Kafka cluster  topic and do LLM action by getting information from Linkedin and doing execute the prompt automatically and in real-time.
![alt terminals](img/ice_breaker.png)

The Prompt is the task description for Chatgpt, we formulated the following content:
* given the Linkedin information {linkedin_information} about a person from I want you to create:
   1. a short summary
   2. two interesting facts about them
   3. A topic that may interest them
   4. 2 creative Ice breakers to open a conversation with them


# Destroy the Confluent Cloud Resources
If you are finished, you can stop the programs in Terminal with CTRL+c and destroy everything in Confluent Cloud by :
```bash
terraform destroy
``` 

If you will get an error, execute destroy again, till everything is green.
```bash
terraform destroy
``` 

# Licenses
You need a Confluent Cloud Account (new ones get 400$ credit for free).
You need an OPenAI Account, with current credit.
You need a ProxyCurl API Account, with current credits.
Your need SERP API Account, here you will a starting amount of connections. This was enough in my case.

In  Total I spend 20 $ (Open AI, ProxyCurl) and I am still not out of credits.

