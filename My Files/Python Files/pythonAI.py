from openai import AzureOpenAI
import pandas as pd
import traceback
import warnings

warnings.simplefilter('ignore')

# Input the CSV file path and read the CSV file into a pandas DataFrame
csv_file_path = r"C:\Users\LatheefS\Desktop\AT Python Files\x_ve1_maximise_test_results.csv"
df = pd.read_csv(csv_file_path)


# Call OpenAi to generate content for the prompt been passed
def call_openai():
    try:
        client = AzureOpenAI(
            api_key="53aaa9e9824e45f7b681d7dc1e1050ee",
            api_version="2023-09-15-preview",
            azure_endpoint="https://ai-audit-report-openai-deployment.openai.azure.com/"
        )

        prompt = "Give comprehensive summary focusing on key metrics like Total Number of Tests, Number of Tests Passed and Failed,Pass Rate and Fail Rate,Error Messages and Failed Steps,Breakdown by Test Area,Common Error Messages,and Recommendations like Investigate Timeout Issues,Focus on PO Process Improvements,Maintain and Monitor Other Areas of " + str(df)
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
        print(f"Exception Occurred:\n{traceback.format_exc()}")


call_openai()
