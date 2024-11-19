import os
from openai import AzureOpenAI

def call_azureopenai():
    try:
        client = AzureOpenAI(
            api_key="53aaa9e9824e45f7b681d7dc1e1050ee",
            api_version="2023-09-15-preview",
            azure_endpoint="https://ai-audit-report-openai-deployment.openai.azure.com/"
        )

        response = client.chat.completions.create(
            model="audit-report",  # model = "deployment_name".
            messages=[
                {"role": "system", "content": "Assistant is a large language model trained by OpenAI."},
                {"role": "user", "content": "Who were the founders of Microsoft?"}
            ]
        )

        # print(response)
        print(response.model_dump_json(indent=2))
        print(response.choices[0].message.content)
    except:
        print(f"Exception Occured:\n{traceback.format_exc()}")