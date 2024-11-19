prompt_dict = {
    "Summary": """
    Please analyze the provided CSV data focusing on the columns u_company, error_message, failed_step, process_id, reasons, result, test_area and test_id. I am particularly interested in obtaining  insights based on the following criteria:
 
    - Analyze the values from the column "error_message" and provide "the most common error message".
    - Analyze the values from the column "reasons" and provide "the most common error reason".
    - Analyze the values from the column "failed_step" and provide "the list of failed steps".
    - Analyze the values from the columns "error_message", "reasons", and "failed_step", provide detailed insights for each unique Test Area from the column "test_area" in below format
 
    Insights by Test Area:
    Test Area Name:
            - Failed Test:
            - Failed Test Reason:
            - Failed Step Reason:
            - Common Error Messages:
            - Common Error Reason:
            """
}