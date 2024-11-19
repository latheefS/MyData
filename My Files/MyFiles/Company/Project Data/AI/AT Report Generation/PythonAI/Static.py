static_dict = {
    "Introduction": "This document details the results of the <Version> Quarterly Update Testing.  As per Oracle’s timetable for quarterly releases for wave <number>, the upgrade took place on non-production environments on the <day(dd/mm/yy)>, and into the production environment on the <day (dd/mm/yy)>.",

    "Purpose": """The purpose of this document is to provide details of the testing performed during the <Version> Quarterly Update testing window, defects introduced by the updates, resolution details, and any lessons learned.
    """,

    "Purpose_short": """The document provides;
•	Scope of the testing
•	The processes and tools used during testing
•	Test execution Summary
•	Defect Summary (at test completion)
•	Details of any active defects (at test completion) and action plans to resolve
•	Lessons learned
    """,

    "Scope": """The scope of functional regression testing was approved by <Client Name> key stakeholders. The golden thread suite of tests, based on key business processes was used, with the addition of further tests identified from the impact assessment of changes, new functionality and fixes documented by Oracle. As agreed - only mandatory changes were taken with the release. Non-mandatory changes will be reviewed and collated into a roadmap. 
    """,

    "Test Overview": """This section provides summary details of the tests that were performed in each module/area, defects identified and what was and wasn’t met in relation to planned entry and exit criteria.""",

    "Tools": """The testing window lasted <duration>> as prescribed by Oracle’s quarterly patching process. Testing was performed by members of Version 1, supported by <Client Name> and managed via Azure Dev Ops. Any failed tests were linked to associated defects, which were managed by Version 1. Test evidence was captured by testers during test execution and stored in Dev Ops with the test itself.""",

    "Environment":"""As discussed and agreed at the planning stage the bulk of the functional and integration testing was carried out in the environments below (last refresh from PROD date <dd/mm/yy>).
    """,

    "Test Entry":"""The following entry criteria was agreed.
    """,

    "Test Exit":"""The following entry criteria was agreed.
    """,

    "Evidence": """All functional testing across the agreed scope of modules was tracked in Azure Dev Ops via summary dashboards. Test evidence can be found in Azure Dev Ops.
    """,

    "Defects": """This section summarises the defects identified during the course of the test phase and for any outstanding defects agreed action plan to resolve and/or workarounds.
    """,

    "Communications": """It was agreed with <Client Name> that they would update any documentation necessary to reflect the changes introduced with the release.
    """,

    "Lessons": """
    The following entry criteria was agreed.
    """,

    "Summary": """
    Assume the role of a functional consultant who is creating a document. Your task is to extract a relevant executive summary of the given input file. 
    - Use simple and non-technical words to explain. 
    - Do not make any assumptions, do not include anything that is not relevant to the data provided. 
    - Do not use any technical words. It should be pure non-technical summary."""
}