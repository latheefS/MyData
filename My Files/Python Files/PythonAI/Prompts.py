prompt_dict = {
    "Summary": """
    Please analyze the provided CSV data focusing on the columns u_company, error_message, failed_step, process_id, reasons, result, test_area and test_id. I am particularly interested in obtaining  insights based on the following criteria:
 
    - Analyze the values from the column "error_message" and provide "the most common error message".
    - Analyze the values from the column "reasons" and provide "the most common error reason".
    - Analyze the values from the column "failed_step" and provide "the list of failed steps".
 
    Insights by Test Area:
            - Determine the most common reasons for test failures
            - Failed Test:
            - Failed Test Reason:
            - Failed Step Reason:
    Common Error Messages:
            - Identify the most common error_message across all failed tests.
    Failed Test Reason:
            - The most common reasons for failed tests were
    Failed Step Reason:
            - The most common reasons for failed steps were """,

    "Comprehensive Summary": """
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
    """
}