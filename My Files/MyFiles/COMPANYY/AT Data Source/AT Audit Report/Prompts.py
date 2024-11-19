prompt_dict = {
    "Introduction": "Provide a concise summary of the dataframe and display its failed result with respective error_message as explanation",

    "Purpose": """
    Assume the role of a functional consultant who is creating a document to tell the purpose the document which is to provide details of the testing performed during the Quarterly Update testing window, defects introduced by the updates, resolution details and any lessons learned. And tell what document provides.
    - Do not include the column names.
    - Do not make assumptions.
    - Use simple and non-technical words to explain. 
    - Do not include anything that is not relevant to the data provided. 
    - Do not use any technical words.

    The document provides:
    """,

    "Scope": """
    Assume the role of a functional consultant who is creating an actions table based on the transcript of a meeting. The table should meet the following criteria:
    - The table should include the columns: ID, Date Raised, Action Description, Owner, and Due Date.
    - Do not include the column names in the output.
    - Do not make assumptions, only include data provided in the transcript.
    - The table should use Pipes as a delimiter.
    - Each action should be an individual row in the table.

    The transcript is as follows:
    """,

    "Test Overview": """
    Assume the role of a functional consultant who is creating a document to tell the summary of tests succeeded and failed. This is a section which tells abut the quarterly testing 
    - Use simple and non-technical words to explain. 
    - Do not make any assumptions, do not include anything that is not relevant to the data provided. 
    - Do not use any technical words. It should be pure non-technical summary.
    - Do not mention test names instead tell the count of tests passed and failed""",

    "Summary": """
    Assume the role of an AI functional consultant who is creating a document. Your task is to extract a relevant executive summary of the given input file. 
    - Use simple and non-technical words to explain. 
    - Do not make any assumptions, do not include anything that is not relevant to the data provided. 
    - Do not use any technical words. It should be pure non-technical summary."""
}