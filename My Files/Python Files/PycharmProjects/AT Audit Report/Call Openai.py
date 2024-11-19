from openai import AzureOpenAI
import pandas as pd
import numpy as np
import prompts
import traceback
import warnings
warnings.simplefilter('ignore')

# # Prompt the user for the CSV file path and read the CSV file into a pandas DataFrame
# # csv_file_path = input("Enter the CSV file path: ")
csv_file_path = 'C:/Users/LatheefS/Desktop/AT Python Files/x_ve1_maximise_test_results.csv'
df = pd.read_csv(csv_file_path)
# # print(df.columns)
# failed_df = df[df['result']=='Failed']
# df = failed_df
# # print(failed_df[['reasons','result','error_message']].to_string())
# print(df.to_string())

def call_openai():
    try:
        client = AzureOpenAI(
            api_key="53aaa9e9824e45f7b681d7dc1e1050ee",
            api_version="2023-09-15-preview",
            azure_endpoint="https://ai-audit-report-openai-deployment.openai.azure.com/"
        )

        # prompt = "Give description of this dataframe" + str(df)
        prompt = prompts.prompt_dict['Comprehensive Summary']+str(df)
        # prompt = prompts.prompt_dict['Summary'] + str(df)
        # prompt = prompts.prompt_dict['Test Overview'] + str(df)
        messages = [
            {"role": "system", "content": "AI Assistant"},
            {"role": "user", "content": prompt}
        ]

        response = client.chat.completions.create(
            model="audit-report",  # model = "deployment_name".
            messages=messages
        )

        # print(response)
        # print(response.model_dump_json(indent=2))
        print(response.choices[0].message.content)
        # print(dict(response).get('usage'))
    except:
        print(f"Exception Occured:\n{traceback.format_exc()}")


call_openai()
