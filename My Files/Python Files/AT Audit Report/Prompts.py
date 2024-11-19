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
    Please analyze the provided CSV data focusing on the columns u_company, error_message, failed_step, process_id, reasons, result, and test_area. I am particularly interested in obtaining accurate counts and insights based on the following criteria:
    - Do not make any assumptions, do not include anything that is not relevant to the data provided.
    - Use only u_company,error_message,failed_step,process_id,reasons,result,test_area columns data for summarization.
    - Analyze the values from the column "result" and provide the number of Passed and Failed results.
    - Analyze the values from the column "test_area" and understand the module name.
    - Analyze the values from the column "error_message" and provide "the most common error message".
    - Analyze the values from the column "reasons" and provide "the most common error reason".
    - Analyze the values from the column "failed_step" and provide "the list of failed steps".
    - Do not oversight in the analysis, provide the insights and counts based on the actual provided data.
    - Accurately count the number of Passed & Failed results for each module.
    - Do not make any mistake in counting the number of Passed & Failed results by doing a careful review and enumeration of the provided data.
    - Please double-check the test counts for each module to ensure accuracy
    - Could you please verify the count of tests for the each test_area and verify how you arrived at that number.
    - Please double-check your counts and summaries to ensure accuracy.
    - Ensure accuracy by counting the occurrences of 'Passed' and 'Failed' in the result column.
    1. Total Number of Tests:
        Calculate the total number of tests conducted by counting the entries in the dataset.
    2. Number of Tests Passed and Failed: Provide the number of tests that passed and failed. Ensure accuracy by counting the occurrences of 'Passed' and 'Failed' in the result column. Please double-check your counts to ensure accuracy.
        Passed:
        Failed:
    3. Pass Rate and Fail Rate: Provide the pass and fail rate for each module (test area). Ensure accuracy by counting the occurrences of 'Passed' and 'Failed' in the result column.
        Pass Rate: Ensure accuracy by counting the occurrences of 'Passed' in the result column for each module (test area).
        Fail Rate: Ensure accuracy by counting the occurrences of 'Failed' in the result column for each module (test area).
    4. Breakdown by Test Area: For each unique value in the test_area column, count the number of tests, including both passed and failed tests. Ensure accuracy by counting the occurrences of 'Passed' and 'Failed' in the result column.
    5. Insights by Test Area:
        -   Each Test Area Pass details should have how many tests passed giving pass percentage
        -   Each Test Area Fail details should have how many tests failed giving fail percentage
            - Determine the most common reasons for test failures
            - Failed Test:
            - Failed Test Reason:
            - Failed Step Reason:
    6. Common Error Messages:
            - Identify the most common error_message across all failed tests.
    7. Failed Test Reason:
            - The most common reasons for failed tests were
    8. Failed Step Reason:
            - The most common reasons for failed steps were
    """,

    "Comprehensive Summary": """
    Based on the u_company,error_message,failed_step,process_id,reasons,result,test_area columns of the provided CSV data, provide a comprehensive summary focusing on key metrics and insights
    - Do not make any assumptions
    - use only u_company,error_message,failed_step,process_id,reasons,result,test_area columns data for summarization
    - based on "error_message" column values only tell "the most common error message"
    - based on "reasons" column values only tell "the most common error reason"
    - based on "failed_step" column values only tell "the list of failed steps"
    
    1. Total Number of Tests:
        Total Tests Conducted: 
    2. Number of Tests Passed and Failed:
        Passed: 
        Failed: 
    3. Pass Rate and Fail Rate:
        Pass Rate: 
        Fail Rate: 
    4. Breakdown by Test Area:

    5. Insights by Test Area:
        -   Each Test Area Pass details should have how many tests passed giving pass percentage
        -   Each Test Area Fail details should have how many tests failed giving fail percentage
            - The most common error message of this test area was
            - Failed Test:
            - Failed Test Reason:
            - Failed Step Reason:

    6. Common Error Messages:
            - The most common error messages across all areas were
    7. Failed Test Reason:
            - The most common reasons for failed tests were
    8. Failed Step Reason:
            - The most common reasons for failed steps were
    """
}