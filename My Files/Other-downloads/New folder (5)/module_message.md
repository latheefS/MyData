<p>The file containing the <code>log_module_message</code> procedure appears to be a part of a logging system for an Oracle database application. This procedure is responsible for recording messages related to application module activities, including errors, warnings, and notifications. Here's a high-level summary of its functionalities:</p>
<ol>
<li><p><strong>Purpose</strong>: To log messages associated with specific modules of an application, detailing the message content, related package or procedure name, severity, and other contextual information.</p>
</li>
<li><p><strong>Autonomous Transaction</strong>: The procedure executes independently of the main transaction, ensuring that the logs are recorded even if the main transaction fails or is rolled back.</p>
</li>
<li><p><strong>Validation</strong>: It performs checks on the input parameters to ensure they meet certain criteria, such as length restrictions and predefined acceptable values. Any validation failure triggers an error.</p>
</li>
<li><p><strong>Debugging Support</strong>: It can check for a debugging parameter to decide whether to record certain types of messages.</p>
</li>
<li><p><strong>Logging Mechanism</strong>: It logs messages into the <code>xxmx_module_messages</code> table, including a unique message ID, relevant application and module information, and the message text. The severity level of the message determines how it is logged.</p>
</li>
<li><p><strong>Exception Handling</strong>: The procedure handles exceptions by logging them appropriately and using the <code>RAISE_APPLICATION_ERROR</code> function to notify the calling procedure of the issue. It distinguishes between a custom <code>ModuleError</code> and other Oracle errors.</p>
</li>
<li><p><strong>Transaction Commitment</strong>: It commits the transaction after inserting the log record to ensure that the log entry is saved.</p>
</li>
<li><p><strong>Example Usage</strong>: The procedure is designed to be used within the application code, potentially across different modules, to consistently log messages about system behavior, especially for monitoring and debugging purposes.</p>
</li>
</ol>
<p>In summary, the <code>log_module_message</code> procedure is a centralized logging utility for an Oracle application, aimed at capturing a wide range of messages with consistent formatting and storage, facilitating easier monitoring and troubleshooting of the application.</p>

## log_module_message

<h1 id="log_module_message-procedure-documentation">log_module_message Procedure Documentation</h1>
<h2 id="overview">Overview</h2>
<p>The <code>log_module_message</code> procedure is used to log messages for different phases and severity levels of a module within an application. It supports dynamic error handling, logging to a database table, and raises application errors when necessary.</p>
<h2 id="procedure-signature">Procedure Signature</h2>
<pre><code class="language-sql">PROCEDURE log_module_message
    (
     pt_i_ApplicationSuite         IN xxmx_module_messages.application_suite%TYPE,
     pt_i_Application              IN xxmx_module_messages.application%TYPE,
     pt_i_BusinessEntity           IN xxmx_module_messages.business_entity%TYPE,
     pt_i_SubEntity                IN xxmx_module_messages.sub_entity%TYPE,
     pt_i_Phase                    IN xxmx_module_messages.phase%TYPE,
     pt_i_Severity                 IN xxmx_module_messages.severity%TYPE,
     pt_i_PackageName              IN xxmx_module_messages.package_name%TYPE,
     pt_i_ProcOrFuncName           IN xxmx_module_messages.proc_or_func_name%TYPE,
     pt_i_ProgressIndicator        IN xxmx_module_messages.progress_indicator%TYPE,
     pt_i_ModuleMessage            IN xxmx_module_messages.module_message%TYPE,
     pt_i_OracleError              IN xxmx_module_messages.oracle_error%TYPE
    )
</code></pre>
<h2 id="parameters">Parameters</h2>
<ul>
<li><code>pt_i_ApplicationSuite</code>: The application suite for which the message is being logged.</li>
<li><code>pt_i_Application</code>: The specific application within the suite.</li>
<li><code>pt_i_BusinessEntity</code>: The business entity relevant to the message.</li>
<li><code>pt_i_SubEntity</code>: The sub-entity relevant to the message.</li>
<li><code>pt_i_Phase</code>: The phase of the application where the message is generated.</li>
<li><code>pt_i_Severity</code>: The severity level of the message.</li>
<li><code>pt_i_PackageName</code>: The package name of the module logging the message.</li>
<li><code>pt_i_ProcOrFuncName</code>: The procedure or function name within the package.</li>
<li><code>pt_i_ProgressIndicator</code>: A variable to track progress or status.</li>
<li><code>pt_i_ModuleMessage</code>: The message to be logged.</li>
<li><code>pt_i_OracleError</code>: The Oracle error code, if applicable.</li>
</ul>
<h2 id="autonomous-transaction">Autonomous Transaction</h2>
<pre><code class="language-sql">PRAGMA AUTONOMOUS_TRANSACTION;
</code></pre>
<p>The procedure runs as an autonomous transaction, which means it will not be affected by the current transaction context.</p>
<h2 id="constants-and-variables">Constants and Variables</h2>
<ul>
<li><code>ct_ProcOrFuncName</code>: A constant holding the name of the current procedure <code>log_module_message</code>.</li>
<li><code>v_debug_message</code>: A variable to store the debug message status.</li>
<li><code>e_ModuleError</code>: A user-defined exception.</li>
</ul>
<h2 id="procedure-logic">Procedure Logic</h2>
<h3 id="validation">Validation</h3>
<p>The procedure starts with several validation checks:</p>
<ol>
<li><p>It checks whether the length of <code>pt_i_ApplicationSuite</code> and <code>pt_i_Application</code> parameters does not exceed 4 characters, raising <code>e_ModuleError</code> if the condition is violated.</p>
</li>
<li><p>It validates if the <code>pt_i_Phase</code> parameter is one of the allowed values: 'CORE', 'EXTRACT', 'TRANSFORM', 'EXPORT', or 'VALIDATE', raising <code>e_ModuleError</code> if not.</p>
</li>
<li><p>It checks if the <code>pt_i_Severity</code> parameter is either 'NOTIFICATION', 'WARNING', or 'ERROR', also raising <code>e_ModuleError</code> if the value is outside this range.</p>
</li>
</ol>
<h3 id="debug-parameter-check">Debug Parameter Check</h3>
<p>It retrieves a parameter value for debugging purposes using <code>xxmx_utilities_pkg.get_single_parameter_value</code> function.</p>
<h3 id="message-logging">Message Logging</h3>
<p>Depending on the <code>pt_i_Severity</code> level and the debug parameter, an INSERT statement logs the message into the <code>xxmx_module_messages</code> table with relevant information including a unique message ID, application information, and timestamps.</p>
<h3 id="commit-transaction">Commit Transaction</h3>
<p>After the insert operation, a <code>COMMIT</code> statement is executed to save the changes made by the autonomous transaction.</p>
<h2 id="exception-handling">Exception Handling</h2>
<h3 id="module-error">Module Error</h3>
<p>If <code>e_ModuleError</code> is raised, an error message is constructed and inserted into the <code>xxmx_module_messages</code> table, then a <code>COMMIT</code> is executed followed by <code>RAISE_APPLICATION_ERROR</code> to report the error with an appropriate message.</p>
<h3 id="other-errors">Other Errors</h3>
<p>For any other errors, the procedure captures the Oracle error message, logs it into the <code>xxmx_module_messages</code> table, commits the change, and raises an application error.</p>
<h2 id="example-usage">Example Usage</h2>
<p>The procedure is intended to be called from various procedures within the application whenever there is a need to log a message to the <code>xxmx_module_messages</code> table, including during error handling.</p>
<pre><code class="language-sql">BEGIN
    log_module_message(
        pt_i_ApplicationSuite      =&gt; 'ACCT',
        pt_i_Application           =&gt; 'PAYR',
        pt_i_BusinessEntity        =&gt; 'HR',
        pt_i_SubEntity             =&gt; 'PAYROLL',
        pt_i_Phase                 =&gt; 'TRANSFORM',
        pt_i_Severity              =&gt; 'ERROR',
        pt_i_PackageName           =&gt; 'payroll_pkg',
        pt_i_ProcOrFuncName        =&gt; 'calculate_salaries',
        pt_i_ProgressIndicator     =&gt; 'STEP1',
        pt_i_ModuleMessage         =&gt; 'Invalid salary data.',
        pt_i_OracleError           =&gt; 'ORA-01400'
    );
END;
</code></pre>
<p>This call to <code>log_module_message</code> would attempt to log an error message from the <code>payroll_pkg.calculate_salaries</code> procedure during the 'TRANSFORM' phase, with the progress indicator 'STEP1'. If any of the validation checks fail or an exception is raised, it would log an appropriate error message and raise an application error for the calling procedure to handle.</p>

