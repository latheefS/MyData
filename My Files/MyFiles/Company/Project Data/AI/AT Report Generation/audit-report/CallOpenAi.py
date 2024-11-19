from openai import AzureOpenAI
import pandas as pd
import traceback
import warnings
import Prompts
import os

warnings.simplefilter('ignore')

# Input the CSV file path and read the CSV file into a pandas DataFrame
csv_file_path = os.environ.get('inputFile')
df = pd.read_csv(csv_file_path)

# Initialize the OpenAI client
client = AzureOpenAI(
    api_key="53aaa9e9824e45f7b681d7dc1e1050ee",
    api_version="2023-09-15-preview",
    azure_endpoint="https://ai-audit-report-openai-deployment.openai.azure.com/"
)


# Define a function to generate content for a given prompt
def generate_content(prompt):
    try:
        messages = [
            {"role": "system", "content": "Data Analyst"},
            {"role": "user", "content": prompt}
        ]

        response = client.chat.completions.create(
            model="audit-report",  # model = "deployment_name".
            messages=messages
        )

        return response.choices[0].message.content
    except Exception as e:
        print(f"Exception Occurred:\n{traceback.format_exc()}")
        return str(e)  # Return the error message


# Example usage
prompt = Prompts.prompt_dict['Comprehensive Summary']
output1 = generate_content(prompt)

# prompt2 = "Provide additional insights based on the data"  # Example additional prompt
# output2 = generate_content(prompt2)
#
# # Now you can use 'output1' and 'output2' elsewhere in your code
# print("Output 1:", output1)
# print("Output 2:", output2)
