import os
import pandas as pd
from openai import AzureOpenAI

csv_file_path = 'C:/Users/LatheefS/Desktop/AT Python Files/x_ve1_maximise_test_results.csv'
df = pd.read_csv(csv_file_path)
# print(df.to_string())


client = AzureOpenAI(
    api_key="53aaa9e9824e45f7b681d7dc1e1050ee",
    api_version="2023-09-15-preview",
    azure_endpoint="https://ai-audit-report-openai-deployment.openai.azure.com/"
)

prompt = "Give Summary of this dataframe"+str(df)
messages = [
    {"role": "system", "content": "AI Assistant"},
    {"role": "user", "content": prompt}
]

response = client.chat.completions.create(
    model="audit-report",  # model = "deployment_name".
    messages=messages
)

#print(response)
# print(response.model_dump_json(indent=2))
print(response.choices[0].message.content)
#print(dict(response).get('usage'))

