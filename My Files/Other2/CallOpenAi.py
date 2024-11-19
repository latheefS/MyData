from openai import AzureOpenAI
import Prompts
import pandas as pd
import traceback
import warnings
import Prompts

warnings.simplefilter('ignore')

# Input the CSV file path and read the CSV file into a pandas DataFrame
csv_file_path = r"C:\Users\LatheefS\Desktop\PythonAI\input\x_ve1_maximise_test_results.csv"
df = pd.read_csv(csv_file_path)
# print(df.to_string())

# Initialize the OpenAI client
client = AzureOpenAI(
    api_key="d2794a3f689745b39f4379c0de49d253",
    api_version="2023-09-15-preview",
    azure_endpoint="https://decipher-plsql-openai.openai.azure.com/"
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


# Usage
# prompt = Prompts.prompt_dict['Summary']+ str(df)
prompt = str(df) + Prompts.prompt_dict['Comprehensive Summary']
# prompt = "Give comprehensive summary focusing on key metrics and insights of the provided csv data" + str(df)
output = generate_content(prompt)
print("Output:", output)