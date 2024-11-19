import pandas as pd
import numpy as np
from pandasai import PandasAI
from pandasai.llm.openai import OpenAI

class MyPandasAI(PandasAI):
    def chat(self, df, prompt):
        # Get the answer from the OpenAI API
        answer = self.llm.chat(prompt)
        # Return the answer
        return answer

OPENAI_API_KEY = "53aaa9e9824e45f7b681d7dc1e1050ee"
llm = OpenAI(api_token=OPENAI_API_KEY)
pandas_ai = MyPandasAI(llm)

# Read the CSV file into a pandas DataFrame
csv_file_path = 'C:/Users/LatheefS/Desktop/AT Python Files/x_ve1_maximise_test_results.csv'
df = pd.read_csv(csv_file_path)
print(df)

response = pandas_ai(df, "Summarize the data of the dataframe")
print(response)