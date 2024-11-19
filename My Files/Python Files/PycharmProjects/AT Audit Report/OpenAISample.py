import os
import openai

openai.api_type = "azure"
openai.api_base = "https://ai-audit-report-openai-deployment.openai.azure.com/"
openai.api_version = "2023-09-15-preview"
openai.api_key = "53aaa9e9824e45f7b681d7dc1e1050ee"

response = openai.Completion.create(
    engine="audit-report",
    prompt="What is the capital of India",
    temperature=1,
    max_tokens=100,
    top_p=0.5,
    frequency_penalty=0,
    presence_penalty=0,
    stop=None)
print(response)