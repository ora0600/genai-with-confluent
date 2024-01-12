from tools.tools import get_profile_url

from langchain.prompts import PromptTemplate
from langchain_openai import ChatOpenAI

from langchain.agents import initialize_agent, Tool
from langchain.agents import AgentType


# Function will search the fullname in linkedin and come back we a linkedin username profile URL
def lookup(name: str) -> str:
    # instance of ChatOpenAI
    llm = ChatOpenAI(temperature=0, model_name="gpt-3.5-turbo")

    # Input person, output URL (Output Indicator)
    template = """given the full name {name_of_person} I want you to get it me a link to their Linkedin profile page.
                          Your answer should contain only a URL"""

    # Name of the Tool, Function (this will be called by the Agent if this tool will used), description is the key for choose the right cool, please be clear
    tools_for_agent1 = [
        Tool(
            name="Crawl Google 4 linkedin profile page",
            func=get_profile_url,
            description="useful for when you need get the Linkedin Page URL",
        ),
    ]

    # create template with input
    prompt_template = PromptTemplate(
        input_variables=["name_of_person"], template=template
    )

    # Initialize the AGENT, verbose=TRUE means we will see everything in the reason process
    agent = initialize_agent(
        tools_for_agent1, llm, agent=AgentType.ZERO_SHOT_REACT_DESCRIPTION, verbose=True
    )

    # run the Agent
    linkedin_username = agent.run(prompt_template.format_prompt(name_of_person=name))

    return linkedin_username
