import openai
import Prompts

def test_api_call(model: str, deployment_name: str) -> str:
    openai.api_key = "d2794a3f689745b39f4379c0de49d253"
    openai.api_base = "https://decipher-plsql-openai.openai.azure.com/"
    openai.api_type = 'azure'
    openai.api_version = "2023-09-15-preview"
    prompt = "What is the factorial of 12"
    result = generate_output_with_gpt4(prompt, model, deployment_name)
    return result

def generate_output_with_gpt4(prompt: str, model: str, deployment_name: str) -> str:
    """
    Generate output using GPT-4.

    :param prompt: The prompt to be used for GPT-4.
    :param model: The GPT-4 model version.
    :return: The response from GPT-4.
    :raises ValueError: If OpenAI API key is not found.
    """
    start_time = time.perf_counter()

    messages = [
        {"role": "system", "content": "You are a AI assistant."},
        {"role": "user", "content": prompt}
    ]

    response = openai.ChatCompletion.create(
        engine=deployment_name,
        messages=messages,
        max_tokens=4096
    )

    end_time = time.perf_counter()
    print(f"The function took {end_time - start_time} seconds to execute")
    return response.choices[0].message.content.strip()