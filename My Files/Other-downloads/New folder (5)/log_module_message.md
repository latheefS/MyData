<p>The file containing the <code>log_module_message</code> procedure appears to be a PL/SQL script designed for logging events or messages within an Oracle database system. Here is a high-level summary of what this file does:</p>
<ol>
<li><p><strong>Purpose</strong>: The primary function is to log messages related to a software module's execution. These messages can include various details, such as the application suite, application, business entity, phase of execution, and errors if any.</p>
</li>
<li><p><strong>Parameters Handling</strong>: The procedure accepts a range of parameters that specify details about the message to be logged, including severity levels (such as notifications, warnings, and errors) and identifiers for business processes.</p>
</li>
<li><p><strong>Validations</strong>: The procedure includes validation checks for parameters to ensure they meet certain criteria (e.g., character lengths, valid phase names).</p>
</li>
<li><p><strong>Independence</strong>: It uses the <code>AUTONOMOUS_TRANSACTION</code> pragma, meaning it operates independently of any other transactions that might be occurring, preventing it from interfering with other database operations.</p>
</li>
<li><p><strong>Debugging Support</strong>: The procedure has the capability to handle debug messages, depending on certain conditions.</p>
</li>
<li><p><strong>Database Interaction</strong>: It inserts messages into a specific database table (<code>xxmx_module_messages</code>), essentially writing logs to the database.</p>
</li>
<li><p><strong>Committing Changes</strong>: After logging the message, it commits the transaction, ensuring that the log is saved.</p>
</li>
<li><p><strong>Error Handling</strong>: The script can handle errors specifically related to the module as well as other unexpected exceptions, logging them appropriately and providing feedback for debugging purposes.</p>
</li>
<li><p><strong>Usage Scenario</strong>: An example usage scenario is provided to demonstrate how the procedure might be called within another PL/SQL block or a stored procedure to log progress or issues during operations like payroll calculations.</p>
</li>
</ol>
<p>Overall, the file serves as an error and event logging utility for an Oracle database, particularly focusing on supporting database operations by providing a means of tracking execution phases, monitoring progress, and recording errors for system administration and debugging efforts.</p>

## log_module_message

<h1 id="technical-documentation-for-log_module_message-procedure">Technical Documentation for <code>log_module_message</code> Procedure</h1>
<p>The <code>log_module_message</code> procedure is a PL/SQL block that logs messages related to various phases of a software module's execution in an Oracle database. The messages contain information about the application suite, application, business entity, sub-entity, migration set ID, and more. Below, the procedure is documented in detail, explaining its structure, logic, and usage.</p>
<h2 id="procedure-definition">Procedure Definition</h2>
<pre><code class="language-sql">PROCEDURE log_module_message
...
END log_module_message;
</code></pre>
<p>The <code>log_module_message</code> is a standalone stored procedure that accepts multiple parameters to record detailed module execution messages. It supports a default value for <code>pt_i_FileSetID</code> and defines data types according to the columns of the <code>xxmx_module_messages</code> table.</p>
<h2 id="parameters">Parameters</h2>
<p>The procedure accepts the following parameters:</p>
<ul>
<li><code>pt_i_ApplicationSuite</code>: The application suite name (must be 4 characters or less).</li>
<li><code>pt_i_Application</code>: The application name (must be 4 characters or less).</li>
<li><code>pt_i_BusinessEntity</code>: The business entity name involved.</li>
<li><code>pt_i_SubEntity</code>: The sub-entity name involved.</li>
<li><code>pt_i_FileSetID</code>: The file set identifier with a default value of 0.</li>
<li><code>pt_i_MigrationSetID</code>: The migration set identifier.</li>
<li><code>pt_i_Phase</code>: The phase of the module (<code>CORE</code>, <code>EXTRACT</code>, <code>TRANSFORM</code>, <code>EXPORT</code>, <code>VALIDATE</code>).</li>
<li><code>pt_i_Severity</code>: The severity of the message (<code>NOTIFICATION</code>, <code>WARNING</code>, <code>ERROR</code>).</li>
<li><code>pt_i_PackageName</code>: The package name where the procedure is contained.</li>
<li><code>pt_i_ProcOrFuncName</code>: The name of the procedure or function being executed.</li>
<li><code>pt_i_ProgressIndicator</code>: An indicator of the progress.</li>
<li><code>pt_i_ModuleMessage</code>: The detailed message of the module.</li>
<li><code>pt_i_OracleError</code>: Any Oracle error encountered.</li>
</ul>
<h2 id="local-declarations">Local Declarations</h2>
<h3 id="constants">Constants</h3>
<ul>
<li><code>ct_ProcOrFuncName</code>: The constant name of the procedure for internal use.</li>
</ul>
<h3 id="variables">Variables</h3>
<ul>
<li><code>v_debug_message</code>: A temporary variable to store the debug message indicator.</li>
</ul>
<h3 id="exceptions">Exceptions</h3>
<ul>
<li><code>e_ModuleError</code>: A custom exception used to handle specific module errors.</li>
</ul>
<h2 id="logic">Logic</h2>
<h3 id="autonomous-transaction-pragma">Autonomous Transaction Pragma</h3>
<p>The pragma <code>AUTONOMOUS_TRANSACTION</code> ensures that the transaction within the procedure is independent of any calling transaction.</p>
<h3 id="validations">Validations</h3>
<p>The procedure performs several validations on input parameters to ensure their lengths and values meet expected criteria. If not, it raises the custom <code>e_ModuleError</code> exception.</p>
<pre><code class="language-sql">IF LENGTH(pt_i_ApplicationSuite) &gt; 4 THEN
    ...
END IF;
...
IF UPPER(pt_i_Phase) NOT IN ('CORE', 'EXTRACT', 'TRANSFORM', 'EXPORT','VALIDATE') THEN
    ...
END IF;
</code></pre>
<h3 id="debug-message-handling">Debug Message Handling</h3>
<p>The procedure retrieves a debug message indicator from another package function <code>xxmx_utilities_pkg.get_single_parameter_value</code>. Depending on whether this indicator is <code>Y</code> and the severity is <code>NOTIFICATION</code>, different handling is executed.</p>
<h3 id="insertion-logic">Insertion Logic</h3>
<p>The procedure contains logic to insert a new record into the <code>xxmx_module_messages</code> table with all necessary data populated from the input parameters. If the severity is <code>WARNING</code> or <code>ERROR</code>, or if the debug message is not <code>Y</code>, the record is inserted without additional conditional checks.</p>
<pre><code class="language-sql">INSERT INTO xxmx_module_messages
...
VALUES
(
    ...
);
</code></pre>
<h3 id="commit-transaction">Commit Transaction</h3>
<p>The procedure commits the transaction, thereby saving the new record to the database.</p>
<h3 id="exception-handling">Exception Handling</h3>
<p>There are two exception handlers:</p>
<ul>
<li><code>e_ModuleError</code>: Handles module-specific errors by logging them and raising an application error with a message referencing the <code>XXMX_MODULE_MESSAGES</code> table.</li>
<li><code>OTHERS</code>: Catches any other exceptions that occur, logs them, and also raises an application error with a reference to the <code>XXMX_MODULE_MESSAGES</code> table.</li>
</ul>
<h2 id="example-usage">Example Usage</h2>
<p>The procedure would typically be used within a PL/SQL block or another stored procedure to log messages about module execution, like so:</p>
<pre><code class="language-sql">BEGIN
    log_module_message(
        pt_i_ApplicationSuite =&gt; 'HRMS',
        pt_i_Application =&gt; 'PAY',
        pt_i_BusinessEntity =&gt; 'PAYROLL',
        pt_i_SubEntity =&gt; 'EMP',
        pt_i_MigrationSetID =&gt; 123,
        pt_i_Phase =&gt; 'TRANSFORM',
        pt_i_Severity =&gt; 'NOTIFICATION',
        pt_i_PackageName =&gt; 'payroll_pkg',
        pt_i_ProcOrFuncName =&gt; 'calculate_salary',
        pt_i_ProgressIndicator =&gt; '50%',
        pt_i_ModuleMessage =&gt; 'Halfway through salary calculation.',
        pt_i_OracleError =&gt; NULL
    );
END;
</code></pre>
<h2 id="summary">Summary</h2>
<p>The <code>log_module_message</code> procedure is a comprehensive tool for recording detailed messages pertaining to module operations within an Oracle database. It has checks in place to validate the input parameters and will log any errors encountered during its execution, ensuring that there is a robust audit trail available for system administrators and developers to troubleshoot and understand the flow of the system.</p>

