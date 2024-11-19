<p>The <code>xxmx_ap_inv_pkg</code> package plays a critical role in the Accounts Payable Invoices Data Migration process for an Oracle database environment. It provides a suite of procedures to facilitate data extraction, transformation, and management tasks in preparation for migrating invoice header and line data. Key aspects of the package include:</p>
<ul>
<li>Procedures for staging (e.g., <code>ap_invoice_hdr_stg</code> and <code>ap_invoice_lines_stg</code>) and transforming (e.g., <code>ap_invoice_hdr_xfm</code> and <code>ap_invoice_lines_xfm</code>) data, following a consistent naming convention for readability and maintainability.</li>
<li>Main procedures, <code>stg_main</code> and <code>xfm_main</code>, orchestrate the overall staging and transformation phases, respectively.</li>
<li>The <code>purge</code> procedure enables cleanup of all related data for a specified client and migration set.</li>
<li>Use of global constants and variables, such as <code>gct_PackageName</code> and <code>gvv_ProgressIndicator</code>, to manage metadata and track progress.</li>
<li>Custom exceptions (e.g., <code>e_ModuleError</code>) and robust logging and messaging systems to assist in error handling and debugging.</li>
<li>Dynamic SQL execution for tasks like data purging, leveraging the <code>EXECUTE IMMEDIATE</code> statement.</li>
<li>Utilization of Oracle features such as cursors and <code>BULK COLLECT</code> for efficient data processing.</li>
</ul>
<p>The technical details provided suggest the package is designed for efficiency and scalability, following good practices in PL/SQL development. Each procedure within the package follows strict naming conventions, comprehensive error handling, and message logging to ensure the migration process is reliable and transparent.</p>

##  ap_invoice_hdr_xfm

<pre><code class="language-markdown"># xxmx_ap_inv_pkg Package Documentation

The `xxmx_ap_inv_pkg` package contains procedures related to the Accounts Payable Invoices Data Migration within an Oracle database. It includes methods to stage (extract), transform, and manage the migration data before it is imported into the target system.

## Table of Contents

1. [Procedures](#procedures)
2. [Staging](#staging)
3. [Transformation](#transformation)
4. [Data Management](#data-management)

## Procedures

### Staging

#### ap_invoice_hdr_stg

```sql
PROCEDURE ap_invoice_hdr_stg (
    pt_i_MigrationSetID IN xxmx_migration_headers.migration_set_id%TYPE,
    pt_i_SubEntity      IN xxmx_migration_metadata.sub_entity%TYPE
)
</code></pre>
<p>Extracts the details of AP Invoice Headers into the staging table (<code>xxmx_ap_invoices_stg</code>) based on a specified migration set ID and sub-entity.</p>
<h5 id="parameters">Parameters</h5>
<ul>
<li><code>pt_i_MigrationSetID</code>: The migration set identifier.</li>
<li><code>pt_i_SubEntity</code>: The sub-entity of the migration metadata.</li>
</ul>
<h5 id="logic">Logic</h5>
<ul>
<li>Clears existing messages and logs initiation of the procedure.</li>
<li>Retrieves the migration set name for the given ID.</li>
<li>Initializes the migration details for the extract phase.</li>
<li>Extracts invoice header data using the cursor <code>ap_invoice_hdr_cur</code> into a PL/SQL table <code>ap_invoice_hdr_tbl</code>.</li>
<li>Performs a <code>BULK COLLECT</code> insert into the staging table.</li>
<li>Logs and updates the migration details upon successful extraction.</li>
</ul>
<h4 id="ap_invoice_lines_stg">ap_invoice_lines_stg</h4>
<pre><code class="language-sql">PROCEDURE ap_invoice_lines_stg (
    pt_i_MigrationSetID IN xxmx_migration_headers.migration_set_id%TYPE,
    pt_i_SubEntity      IN xxmx_migration_metadata.sub_entity%TYPE
)
</code></pre>
<p>Extracts the details of AP Invoice Lines into the staging table (<code>xxmx_ap_invoice_lines_stg</code>) for the specified migration set ID and sub-entity.</p>
<h5 id="parameters-1">Parameters</h5>
<ul>
<li><code>pt_i_MigrationSetID</code>: The migration set identifier.</li>
<li><code>pt_i_SubEntity</code>: The sub-entity of the migration metadata.</li>
</ul>
<h5 id="logic-1">Logic</h5>
<ul>
<li>Clears existing messages and logs initiation of the procedure.</li>
<li>Retrieves the migration set name for the given ID.</li>
<li>Initializes the migration details for the extract phase.</li>
<li>Extracts invoice line data using the cursor <code>ap_inv_lines_cur</code> into a PL/SQL table <code>ap_invoice_lines_tbl</code>.</li>
<li>Performs a <code>BULK COLLECT</code> insert into the staging table.</li>
<li>Logs and updates the migration details upon successful extraction.</li>
</ul>
<h3 id="transformation">Transformation</h3>
<h4 id="ap_invoice_hdr_xfm">ap_invoice_hdr_xfm</h4>
<pre><code class="language-sql">PROCEDURE ap_invoice_hdr_xfm (
    pt_i_MigrationSetID        IN xxmx_migration_headers.migration_set_id%TYPE,
    pt_i_SubEntity             IN xxmx_migration_metadata.sub_entity%TYPE,
    pt_i_SimpleXfmPerformedBy  IN xxmx_migration_metadata.simple_xfm_performed_by%TYPE
)
</code></pre>
<p>Transforms the extracted AP Invoice Header data in the staging table (<code>xxmx_ap_invoices_stg</code>) and loads it into the transformation table (<code>xxmx_ap_invoices_xfm</code>).</p>
<h5 id="parameters-2">Parameters</h5>
<ul>
<li><code>pt_i_MigrationSetID</code>: The migration set identifier.</li>
<li><code>pt_i_SubEntity</code>: The sub-entity of the migration metadata.</li>
<li><code>pt_i_SimpleXfmPerformedBy</code>: The performer of simple transformations.</li>
</ul>
<h5 id="logic-2">Logic</h5>
<ul>
<li>Clears existing messages and logs initiation of the procedure.</li>
<li>Validates parameters and checks for required simple transformations and data enrichment setup.</li>
<li>Copies data from the staging table to the transformation table.</li>
<li>Performs simple transformations and data enrichment by updating the transformation table's records.</li>
<li>Logs and updates the migration details upon successful transformation.</li>
</ul>
<h4 id="ap_invoice_lines_xfm">ap_invoice_lines_xfm</h4>
<pre><code class="language-sql">PROCEDURE ap_invoice_lines_xfm (
    pt_i_MigrationSetID        IN xxmx_migration_headers.migration_set_id%TYPE,
    pt_i_SubEntity             IN xxmx_migration_metadata.sub_entity%TYPE,
    pt_i_SimpleXfmPerformedBy  IN xxmx_migration_metadata.simple_xfm_performed_by%TYPE
)
</code></pre>
<p>Transforms the extracted AP Invoice Line data in the staging table (<code>xxmx_ap_invoice_lines_stg</code>) and loads it into the transformation table (<code>xxmx_ap_invoice_lines_xfm</code>).</p>
<h5 id="parameters-3">Parameters</h5>
<ul>
<li><code>pt_i_MigrationSetID</code>: The migration set identifier.</li>
<li><code>pt_i_SubEntity</code>: The sub-entity of the migration metadata.</li>
<li><code>pt_i_SimpleXfmPerformedBy</code>: The performer of simple transformations.</li>
</ul>
<h5 id="logic-3">Logic</h5>
<ul>
<li>Similar to <code>ap_invoice_hdr_xfm</code>, it clears messages, copies data, performs simple transformations and data enrichment, and logs updates upon successful transformation.</li>
</ul>
<h3 id="data-management">Data Management</h3>
<h4 id="stg_main">stg_main</h4>
<pre><code class="language-sql">PROCEDURE stg_main (
    pt_i_ClientCode         IN xxmx_client_config_parameters.client_code%TYPE,
    pt_i_MigrationSetName   IN xxmx_migration_headers.migration_set_name%TYPE
)
</code></pre>
<p>Main staging procedure that initiates the extraction of all required sub-entities for a given client code and migration set name.</p>
<h5 id="parameters-4">Parameters</h5>
<ul>
<li><code>pt_i_ClientCode</code>: The client code identifier.</li>
<li><code>pt_i_MigrationSetName</code>: The migration set name.</li>
</ul>
<h5 id="logic-4">Logic</h5>
<ul>
<li>Clears existing messages and logs initiation of the procedure.</li>
<li>Initializes the migration set and retrieves the Migration Set ID.</li>
<li>Loops through each sub-entity defined in the migration metadata and dynamically constructs and executes the corresponding staging procedure.</li>
<li>Logs the completion of the staging phase.</li>
</ul>
<h4 id="xfm_main">xfm_main</h4>
<pre><code class="language-sql">PROCEDURE xfm_main (
    pt_i_ClientCode       IN xxmx_client_config_parameters.client_code%TYPE,
    pt_i_MigrationSetID   IN xxmx_migration_headers.migration_set_id%TYPE
)
</code></pre>
<p>Main transformation procedure that initiates the transformation of all required sub-entities for a given client code and migration set ID.</p>
<h5 id="parameters-5">Parameters</h5>
<ul>
<li><code>pt_i_ClientCode</code>: The client code identifier.</li>
<li><code>pt_i_MigrationSetID</code>: The migration set identifier.</li>
</ul>
<h5 id="logic-5">Logic</h5>
<ul>
<li>Similar to <code>stg_main</code>, it clears messages, initiates the transformation process, and logs completion.</li>
</ul>
<h4 id="purge">purge</h4>
<pre><code class="language-sql">PROCEDURE purge (
    pt_i_ClientCode       IN xxmx_client_config_parameters.client_code%TYPE,
    pt_i_MigrationSetID   IN xxmx_migration_headers.migration_set_id%TYPE
)
</code></pre>
<p>Purges data related to the specified migration set ID from staging and transformation tables as well as migration details and headers.</p>
<h5 id="parameters-6">Parameters</h5>
<ul>
<li><code>pt_i_ClientCode</code>: The client code identifier.</li>
<li><code>pt_i_MigrationSetID</code>: The migration set identifier.</li>
</ul>
<h5 id="logic-6">Logic</h5>
<ul>
<li>Clears existing messages and logs initiation of the procedure.</li>
<li>Loops through each sub-entity defined in the migration metadata and deletes records from both staging and transformation tables.</li>
<li>Deletes related records from migration details and headers.</li>
<li>Logs the completion of the purging process.</li>
</ul>
<pre><code>
Note: The actual SQL statements for the purging procedure are commented out in the provided code and not included in the documentation. If they were to be included in the future, the logic would be executed and documented accordingly.
</code></pre>

##  ap_invoice_lines_stg

<h1 id="xxmx_ap_inv_pkg-technical-documentation">xxmx_ap_inv_pkg Technical Documentation</h1>
<h2 id="overview">Overview</h2>
<p>This package (<code>xxmx_ap_inv_pkg</code>) contains procedures for the AP Invoices data migration within a financial suite. The package provides interfaces to stage and transform data extracted from an external system, preparing it for import into an Oracle ERP system. It includes initialization of the migration set, extraction, transformation, and purging of data.</p>
<h2 id="structure">Structure</h2>
<h3 id="procedures">Procedures</h3>
<h4 id="ap_invoice_hdr_stg">1. <code>ap_invoice_hdr_stg</code></h4>
<ul>
<li><strong>Purpose</strong>: Stages AP Invoice Header records.</li>
<li><strong>Parameters</strong>:
<ul>
<li><code>pt_i_MigrationSetID</code>: The identifier for the migration set.</li>
<li><code>pt_i_SubEntity</code>: The sub-entity type for staging.</li>
</ul>
</li>
</ul>
<h4 id="ap_invoice_hdr_xfm">2. <code>ap_invoice_hdr_xfm</code></h4>
<ul>
<li><strong>Purpose</strong>: Transforms staged AP Invoice Header records.</li>
<li><strong>Parameters</strong>:
<ul>
<li><code>pt_i_MigrationSetID</code>: The identifier for the migration set.</li>
<li><code>pt_i_SubEntity</code>: The sub-entity type for transformation.</li>
<li><code>pt_i_SimpleXfmPerformedBy</code>: Denotes the system or method that will perform the simple transformation.</li>
</ul>
</li>
</ul>
<h4 id="ap_invoice_lines_stg">3. <code>ap_invoice_lines_stg</code></h4>
<ul>
<li><strong>Purpose</strong>: Stages AP Invoice Lines records.</li>
<li><strong>Parameters</strong>:
<ul>
<li><code>pt_i_MigrationSetID</code>: The identifier for the migration set.</li>
<li><code>pt_i_SubEntity</code>: The sub-entity type for staging.</li>
</ul>
</li>
</ul>
<h4 id="ap_invoice_lines_xfm">4. <code>ap_invoice_lines_xfm</code></h4>
<ul>
<li><strong>Purpose</strong>: Transforms staged AP Invoice Lines records.</li>
<li><strong>Parameters</strong>:
<ul>
<li><code>pt_i_MigrationSetID</code>: The identifier for the migration set.</li>
<li><code>pt_i_SubEntity</code>: The sub-entity type for transformation.</li>
<li><code>pt_i_SimpleXfmPerformedBy</code>: Denotes the system or method that will perform the simple transformation.</li>
</ul>
</li>
</ul>
<h4 id="stg_main">5. <code>stg_main</code></h4>
<ul>
<li><strong>Purpose</strong>: Main driver for staging processes across all sub-entities.</li>
<li><strong>Parameters</strong>:
<ul>
<li><code>pt_i_ClientCode</code>: The code that identifies the client configuration.</li>
<li><code>pt_i_MigrationSetName</code>: The name of the migration set being processed.</li>
</ul>
</li>
</ul>
<h4 id="xfm_main">6. <code>xfm_main</code></h4>
<ul>
<li><strong>Purpose</strong>: Main driver for transformation processes across all sub-entities.</li>
<li><strong>Parameters</strong>:
<ul>
<li><code>pt_i_ClientCode</code>: The code that identifies the client configuration.</li>
<li><code>pt_i_MigrationSetID</code>: The identifier for the migration set.</li>
</ul>
</li>
</ul>
<h4 id="purge">7. <code>purge</code></h4>
<ul>
<li><strong>Purpose</strong>: Purges data from staging and transformation tables and corresponding metadata.</li>
<li><strong>Parameters</strong>:
<ul>
<li><code>pt_i_ClientCode</code>: The code that identifies the client configuration.</li>
<li><code>pt_i_MigrationSetID</code>: The identifier for the migration set.</li>
</ul>
</li>
</ul>
<h2 id="exception-handling">Exception Handling</h2>
<p>In each procedure, a local exception <code>e_ModuleError</code> is defined for module-level errors. Upon such an exception, module messages are logged, and an <code>RAISE_APPLICATION_ERROR</code> call is made to generate a standard Oracle error with a custom message. The message includes the procedure name and a progress indicator to locate the source of the error.</p>
<p>Additionally, a general <code>OTHERS</code> exception handler is provided to catch unexpected Oracle exceptions. It logs the error, includes the backtrace, and raises an application error with a message for further investigation.</p>
<h2 id="logging-and-message-handling">Logging and Message Handling</h2>
<p>Throughout each procedure, calls are made to <code>xxmx_utilities_pkg.log_module_message</code> and <code>xxmx_utilities_pkg.log_data_message</code> to log notifications, errors, and other significant events. The messages are stored in the <code>XXMX_MODULE_MESSAGES</code> table for reference and debugging.</p>
<h2 id="commit-handling">Commit Handling</h2>
<p>Commits are made at significant checkpoints to maintain data consistency, especially after major operations like data purging. In the event of an error, a rollback is performed to undo changes made during the procedure execution.</p>
<h2 id="dynamic-sql-execution">Dynamic SQL Execution</h2>
<p>Dynamic SQL statements are constructed and executed using <code>EXECUTE IMMEDIATE</code> within procedures for performing DELETE operations on tables. The procedures dynamically construct the SQL statements based on the operation and table metadata.</p>
<h2 id="naming-conventions">Naming Conventions</h2>
<ul>
<li>Variables and constants follow a naming convention that includes type prefixes and suffixes indicating their purpose and data type. This convention enhances code readability and context understanding.</li>
<li>Table aliases and object references are fully qualified with the schema name to ensure clarity and avoid ambiguity.</li>
</ul>
<h2 id="code-example">Code Example</h2>
<p>Below is a simplified example of how dynamic SQL is constructed and executed for data purging in the <code>purge</code> procedure:</p>
<pre><code class="language-sql">FOR  PurgingMetadata_rec
IN   PurgingMetadata_cur
        (
         gct_ApplicationSuite
        ,gct_Application
        ,gct_BusinessEntity
        )
LOOP
     gvv_SQLTableClause := 'FROM '
                         ||gct_StgSchema
                         ||'.'
                         ||PurgingMetadata_rec.stg_table;

     gvv_SQLStatement := gvv_SQLAction
                       ||gcv_SQLSpace
                       ||gvv_SQLTableClause
                       ||gcv_SQLSpace
                       ||gvv_SQLWhereClause;

     EXECUTE IMMEDIATE gvv_SQLStatement;
     gvn_RowCount := SQL%ROWCOUNT;

     xxmx_utilities_pkg.log_module_message
          (
           -- Log message parameters
          );
END LOOP;
</code></pre>
<h2 id="additional-information">Additional Information</h2>
<ul>
<li>The package assumes the existence of utility functions and tables such as <code>xxmx_utilities_pkg</code>, <code>xxmx_client_config_parameters</code>, <code>xxmx_migration_headers</code>, and <code>XXMX_MODULE_MESSAGES</code> for its operation.</li>
<li>The scripts use database links denoted by <code>@MXDM_NVIS_EXTRACT</code> for selecting data from remote databases, indicating that the package is designed to work in a distributed database environment.</li>
</ul>

##  ap_invoice_lines_xfm

<h1 id="xxmx_ap_inv_pkg-package-documentation">xxmx_ap_inv_pkg Package Documentation</h1>
<h2 id="overview">Overview</h2>
<p>The <code>xxmx_ap_inv_pkg</code> package is designed for the Cloudbridge AP Invoices Data Migration. It consists of several procedures responsible for staging and transforming data, as well as handling the main process and data purging activities. Each procedure corresponds to specific tasks and business logic associated with preparing accounts payable invoice data for migration.</p>
<h2 id="table-of-contents">Table of Contents</h2>
<ul>
<li><a href="#procedures">Procedures</a>
<ul>
<li><a href="#ap_invoice_hdr_stg">ap_invoice_hdr_stg</a></li>
<li><a href="#ap_invoice_hdr_xfm">ap_invoice_hdr_xfm</a></li>
<li><a href="#ap_invoice_lines_stg">ap_invoice_lines_stg</a></li>
<li><a href="#ap_invoice_lines_xfm">ap_invoice_lines_xfm</a></li>
<li><a href="#stg_main">stg_main</a></li>
<li><a href="#xfm_main">xfm_main</a></li>
<li><a href="#purge">purge</a></li>
</ul>
</li>
<li><a href="#exception-handling">Exception Handling</a></li>
<li><a href="#logging-and-messaging">Logging and Messaging</a></li>
<li><a href="#coding-standards">Coding Standards</a></li>
</ul>
<hr />
<h2 id="procedures">Procedures</h2>
<h3 id="ap_invoice_hdr_stg">ap_invoice_hdr_stg</h3>
<h4 id="description">Description</h4>
<p>Extracts invoice header data and inserts it into the staging table <code>xxmx_stg.xxmx_ap_invoices_stg</code>.</p>
<h4 id="parameters">Parameters</h4>
<ul>
<li><code>pt_i_MigrationSetID</code> (IN): The identifier for the migration set.</li>
<li><code>pt_i_SubEntity</code> (IN): The sub-entity representing a segment of the business entity being processed.</li>
</ul>
<h4 id="logic">Logic</h4>
<ol>
<li>Clears messages for the 'MODULE' and 'DATA' message types.</li>
<li>Initializes the extraction by setting up logging details.</li>
<li>Extracts data from various source tables such as <code>ap_invoices_all</code>, <code>ap_supplier_sites_all</code>, and related tables using the <code>ap_invoice_hdr_cur</code> cursor.</li>
<li>Inserts extracted data into the staging table with transformation adjustments where necessary.</li>
<li>Updates migration details and logs completion.</li>
</ol>
<h4 id="exceptions">Exceptions</h4>
<ul>
<li>Raises a custom exception if the module faces any error during the extraction.</li>
</ul>
<hr />
<h3 id="ap_invoice_hdr_xfm">ap_invoice_hdr_xfm</h3>
<h4 id="description-1">Description</h4>
<p>Transforms the invoice header data in the staging table to prepare for migration.</p>
<h4 id="parameters-1">Parameters</h4>
<ul>
<li><code>pt_i_MigrationSetID</code> (IN): The identifier for the migration set.</li>
<li><code>pt_i_SubEntity</code> (IN): The sub-entity representing a segment of the business entity being processed.</li>
<li><code>pt_i_SimpleXfmPerformedBy</code> (IN): Indicator of who performs simple transformation (e.g., 'PLSQL').</li>
</ul>
<h4 id="logic-1">Logic</h4>
<ol>
<li>Deletes existing transformed data from the transform table <code>xxmx_xfm.xxmx_ap_invoices_xfm</code>.</li>
<li>Performs simple transformations and data enrichment as necessary.</li>
<li>Updates transformed data with migration status.</li>
<li>Logs detailed messages during the transformation process.</li>
</ol>
<h4 id="exceptions-1">Exceptions</h4>
<ul>
<li>Raises a custom exception if the module faces any error during the transformation.</li>
</ul>
<hr />
<h3 id="ap_invoice_lines_stg">ap_invoice_lines_stg</h3>
<h4 id="description-2">Description</h4>
<p>Extracts invoice line data and inserts it into the staging table <code>xxmx_stg.xxmx_ap_invoice_lines_stg</code>.</p>
<h4 id="parameters-2">Parameters</h4>
<ul>
<li><code>pt_i_MigrationSetID</code> (IN): The identifier for the migration set.</li>
<li><code>pt_i_SubEntity</code> (IN): The sub-entity representing a segment of the business entity being processed.</li>
</ul>
<h4 id="logic-2">Logic</h4>
<ol>
<li>Clears messages for the 'MODULE' and 'DATA' message types.</li>
<li>Initializes the extraction by setting up logging details.</li>
<li>Extracts data from various source tables such as <code>ap_invoice_lines_all</code>, <code>hr_all_organization_units</code>, and related tables using the <code>ap_inv_lines_cur</code> cursor.</li>
<li>Inserts extracted data into the staging table with transformation adjustments where necessary.</li>
<li>Updates migration details and logs completion.</li>
</ol>
<h4 id="exceptions-2">Exceptions</h4>
<ul>
<li>Raises a custom exception if the module faces any error during the extraction.</li>
</ul>
<hr />
<h3 id="ap_invoice_lines_xfm">ap_invoice_lines_xfm</h3>
<h4 id="description-3">Description</h4>
<p>Transforms the invoice line data in the staging table to prepare for migration.</p>
<h4 id="parameters-3">Parameters</h4>
<ul>
<li><code>pt_i_MigrationSetID</code> (IN): The identifier for the migration set.</li>
<li><code>pt_i_SubEntity</code> (IN): The sub-entity representing a segment of the business entity being processed.</li>
<li><code>pt_i_SimpleXfmPerformedBy</code> (IN): Indicator of who performs simple transformation (e.g., 'PLSQL').</li>
</ul>
<h4 id="logic-3">Logic</h4>
<ol>
<li>Deletes existing transformed data from the transform table <code>xxmx_xfm.xxmx_ap_invoice_lines_xfm</code>.</li>
<li>Performs simple transformations and data enrichment as necessary.</li>
<li>Updates transformed data with migration status.</li>
<li>Logs detailed messages during the transformation process.</li>
</ol>
<h4 id="exceptions-3">Exceptions</h4>
<ul>
<li>Raises a custom exception if the module faces any error during the transformation.</li>
</ul>
<hr />
<h3 id="stg_main">stg_main</h3>
<h4 id="description-4">Description</h4>
<p>Main procedure for staging process, invokes staging procedures for each business entity and sub-entity based on the migration metadata.</p>
<h4 id="parameters-4">Parameters</h4>
<ul>
<li><code>pt_i_ClientCode</code> (IN): The client code associated with the configuration.</li>
<li><code>pt_i_MigrationSetName</code> (IN): The name of the migration set being processed.</li>
</ul>
<h4 id="logic-4">Logic</h4>
<ol>
<li>Clears messages for the 'MODULE' and 'DATA' message types.</li>
<li>Initializes the migration set and retrieves the Migration Set ID.</li>
<li>Iterates through each business entity and sub-entity to call the respective staging procedure.</li>
<li>Commits the transactions after completion.</li>
</ol>
<h4 id="exceptions-4">Exceptions</h4>
<ul>
<li>Raises a custom exception if the module faces any error during the staging process.</li>
</ul>
<hr />
<h3 id="xfm_main">xfm_main</h3>
<h4 id="description-5">Description</h4>
<p>Main procedure for transform process, invokes transform procedures for each business entity and sub-entity based on the migration metadata.</p>
<h4 id="parameters-5">Parameters</h4>
<ul>
<li><code>pt_i_ClientCode</code> (IN): The client code associated with the configuration.</li>
<li><code>pt_i_MigrationSetID</code> (IN): The identifier for the migration set being processed.</li>
</ul>
<h4 id="logic-5">Logic</h4>
<ol>
<li>Clears messages for the 'MODULE' and 'DATA' message types.</li>
<li>Iterates through each business entity and sub-entity to call the respective transform procedure.</li>
<li>Commits the transactions after completion.</li>
</ol>
<h4 id="exceptions-5">Exceptions</h4>
<ul>
<li>Raises a custom exception if the module faces any error during the transform process.</li>
</ul>
<hr />
<h3 id="purge">purge</h3>
<h4 id="description-6">Description</h4>
<p>Purges staging and transformation tables for a particular migration set.</p>
<h4 id="parameters-6">Parameters</h4>
<ul>
<li><code>pt_i_ClientCode</code> (IN): The client code associated with the configuration.</li>
<li><code>pt_i_MigrationSetID</code> (IN): The identifier for the migration set being processed.</li>
</ul>
<h4 id="logic-6">Logic</h4>
<ol>
<li>Clears messages for the 'MODULE' message type.</li>
<li>Loops through metadata records to generate and execute SQL DELETE statements for each staging and transform table related to the migration set.</li>
<li>Purges records from the migration details and header tables.</li>
</ol>
<h4 id="exceptions-6">Exceptions</h4>
<ul>
<li>Raises a custom exception if the module faces any error during the purge process.</li>
</ul>
<hr />
<h2 id="exception-handling">Exception Handling</h2>
<p>Custom exceptions are defined and raised throughout the package when errors occur. An application error is raised to pass the exception to the calling environment with a specific error number and a message detailing the error.</p>
<hr />
<h2 id="logging-and-messaging">Logging and Messaging</h2>
<p>Throughout the procedures, logging messages are generated using <code>xxmx_utilities_pkg.log_module_message</code> to inform about the status, progress, and any errors encountered. The messages are categorized by severity and phase.</p>
<hr />
<h2 id="coding-standards">Coding Standards</h2>
<p>The package follows strict coding standards. Notable conventions include:</p>
<ul>
<li>Prefixes such as <code>pv_</code> for procedure variables, <code>ct_</code> for constants, and <code>e_</code> for exceptions.</li>
<li>Descriptive comments for each procedure and code block for clarity.</li>
<li>Error handling with custom exceptions and application error messages.</li>
<li>Transaction control with COMMIT and ROLLBACK statements.</li>
</ul>
<hr />

##  purge

<h1 id="xxmx_ap_inv_pkg-package-documentation">xxmx_ap_inv_pkg Package Documentation</h1>
<p>The <code>xxmx_ap_inv_pkg</code> package contains a set of procedures designed for the Cloudbridge AP Invoices Data Migration process.</p>
<h2 id="table-of-contents">Table of Contents</h2>
<ol>
<li><a href="#package-overview">Package Overview</a></li>
<li><a href="#procedures">Procedures</a>
<ul>
<li><a href="#ap_invoice_hdr_stg">ap_invoice_hdr_stg</a></li>
<li><a href="#ap_invoice_hdr_xfm">ap_invoice_hdr_xfm</a></li>
<li><a href="#ap_invoice_lines_stg">ap_invoice_lines_stg</a></li>
<li><a href="#ap_invoice_lines_xfm">ap_invoice_lines_xfm</a></li>
<li><a href="#stg_main">stg_main</a></li>
<li><a href="#xfm_main">xfm_main</a></li>
<li><a href="#purge">purge</a></li>
</ul>
</li>
</ol>
<h2 id="package-overview">Package Overview</h2>
<p>The <code>xxmx_ap_inv_pkg</code> package is created as part of the Cloudbridge AP Invoices Data Migration project. The package contains procedures that manage the extraction, transformation, and purging of invoice header and line data during the migration process.</p>
<h2 id="procedures">Procedures</h2>
<p>Below is the list of procedures available in the <code>xxmx_ap_inv_pkg</code> package and their functionalities.</p>
<h3 id="ap_invoice_hdr_stg">ap_invoice_hdr_stg</h3>
<p>This procedure performs the extract logic for AP Invoice Headers from the staging area. It opens a cursor to fetch the required details from the AP Invoices data, then performs a BULK COLLECT operation to insert into <code>xxmx_stg.xxmx_ap_invoices_stg</code> staging table.</p>
<p><strong>Signature:</strong></p>
<pre><code class="language-sql">PROCEDURE ap_invoice_hdr_stg(
    pt_i_MigrationSetID IN xxmx_migration_headers.migration_set_id%TYPE,
    pt_i_SubEntity IN xxmx_migration_metadata.sub_entity%TYPE
)
</code></pre>
<h3 id="ap_invoice_hdr_xfm">ap_invoice_hdr_xfm</h3>
<p>This procedure is responsible for transforming the extracted AP Invoice Header data. It retrieves the pre-transform data from the staging table <code>xxmx_ap_invoices_stg</code>, applies simple or complex transformations, and populates the transformed data into the <code>xxmx_ap_invoices_xfm</code> transform table.</p>
<p><strong>Signature:</strong></p>
<pre><code class="language-sql">PROCEDURE ap_invoice_hdr_xfm(
    pt_i_MigrationSetID IN xxmx_migration_headers.migration_set_id%TYPE,
    pt_i_SubEntity IN xxmx_migration_metadata.sub_entity%TYPE,
    pt_i_SimpleXfmPerformedBy IN xxmx_migration_metadata.simple_xfm_performed_by%TYPE
)
</code></pre>
<h3 id="ap_invoice_lines_stg">ap_invoice_lines_stg</h3>
<p>This procedure carries out the extract logic for AP Invoice Lines. Similar to the header procedure, it uses a cursor to fetch invoice line data, applies BULK COLLECT, and inserts it into the staging table <code>xxmx_ap_invoice_lines_stg</code>.</p>
<p><strong>Signature:</strong></p>
<pre><code class="language-sql">PROCEDURE ap_invoice_lines_stg(
    pt_i_MigrationSetID IN xxmx_migration_headers.migration_set_id%TYPE,
    pt_i_SubEntity IN xxmx_migration_metadata.sub_entity%TYPE
)
</code></pre>
<h3 id="ap_invoice_lines_xfm">ap_invoice_lines_xfm</h3>
<p>The procedure transforms AP Invoice Line data. It fetches the data from the <code>xxmx_ap_invoice_lines_stg</code> table, performs required transformations, and inserts it into the <code>xxmx_ap_invoice_lines_xfm</code> table.</p>
<p><strong>Signature:</strong></p>
<pre><code class="language-sql">PROCEDURE ap_invoice_lines_xfm(
    pt_i_MigrationSetID IN xxmx_migration_headers.migration_set_id%TYPE,
    pt_i_SubEntity IN xxmx_migration_metadata.sub_entity%TYPE,
    pt_i_SimpleXfmPerformedBy IN xxmx_migration_metadata.simple_xfm_performed_by%TYPE
)
</code></pre>
<h3 id="stg_main">stg_main</h3>
<p>The <code>stg_main</code> procedure orchestrates the extraction of all AP Invoice data. It initializes the Migration Set and calls each staging procedure sequentially for each sub-entity defined in the migration metadata.</p>
<p><strong>Signature:</strong></p>
<pre><code class="language-sql">PROCEDURE stg_main(
    pt_i_ClientCode IN xxmx_client_config_parameters.client_code%TYPE,
    pt_i_MigrationSetName IN xxmx_migration_headers.migration_set_name%TYPE
)
</code></pre>
<h3 id="xfm_main">xfm_main</h3>
<p>The <code>xfm_main</code> procedure orchestrates the transformation of all extracted AP Invoice data. It loops through the migration metadata to call each transformation procedure for each sub-entity.</p>
<p><strong>Signature:</strong></p>
<pre><code class="language-sql">PROCEDURE xfm_main(
    pt_i_ClientCode IN xxmx_client_config_parameters.client_code%TYPE,
    pt_i_MigrationSetID IN xxmx_migration_headers.migration_set_id%TYPE
)
</code></pre>
<h3 id="purge">purge</h3>
<p>The <code>purge</code> procedure cleans up the data from staging and transformation tables once the migration process is complete or needs to be reset. It uses the migration set ID to delete data related to a particular migration batch.</p>
<p><strong>Signature:</strong></p>
<pre><code class="language-sql">PROCEDURE purge(
    pt_i_ClientCode IN xxmx_client_config_parameters.client_code%TYPE,
    pt_i_MigrationSetID IN xxmx_migration_headers.migration_set_id%TYPE
)
</code></pre>
<p>Each procedure within the package adheres to the coding standards and naming conventions for prefixes as detailed at the beginning of the package specification. All procedures log their progress using <code>xxmx_utilities_pkg</code> to assist in debugging and monitoring migration progress.</p>

##  stg_main

<h1 id="technical-documentation-xxmx_ap_inv_pkg">Technical Documentation - xxmx_ap_inv_pkg</h1>
<h2 id="overview">Overview</h2>
<p>The provided PL/SQL package <code>xxmx_ap_inv_pkg</code> appears to be part of a larger application designed for data migration processes related to Accounts Payable (AP) Invoices. The package includes procedures for staging data (<code>*_stg</code>), transforming data (<code>*_xfm</code>), main routines (<code>stg_main</code>, <code>xfm_main</code>), and purging (<code>purge</code>).</p>
<p>Below is the detailed technical documentation of the package's important structures, methods, and logic.</p>
<h2 id="structure">Structure</h2>
<h3 id="package-specification">Package Specification</h3>
<pre><code class="language-plsql">PACKAGE xxmx_ap_inv_pkg 
AS
...
</code></pre>
<p>The package specification defines several procedures without their implementation details:</p>
<ul>
<li><code>ap_invoice_hdr_stg</code></li>
<li><code>ap_invoice_hdr_xfm</code></li>
<li><code>ap_invoice_lines_stg</code></li>
<li><code>ap_invoice_lines_xfm</code></li>
<li><code>stg_main</code></li>
<li><code>xfm_main</code></li>
<li><code>purge</code></li>
</ul>
<h3 id="package-body">Package Body</h3>
<pre><code class="language-plsql">PACKAGE BODY xxmx_ap_inv_pkg 
AS
...
</code></pre>
<p>The package body contains the implementation of the procedures defined in the package specification.</p>
<h4 id="global-declarations">Global Declarations</h4>
<pre><code class="language-plsql">gct_PackageName                        CONSTANT xxmx_module_messages.package_name%TYPE       := 'xxmx_ap_inv_pkg';
gct_ApplicationSuite                   CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
...
gvv_ProgressIndicator                  VARCHAR2(100);
...
</code></pre>
<p>Global constants and variables are declared at the beginning of the package body, including metadata for logging and tracking the execution of various routines.</p>
<h3 id="procedures">Procedures</h3>
<h4 id="ap_invoice_hdr_stg">ap_invoice_hdr_stg</h4>
<p>This procedure is responsible for staging the AP invoice header data. It retrieves invoice header data from various source tables and inserts them into the staging table <code>xxmx_ap_invoices_stg</code>.</p>
<h5 id="cursor-declarations">Cursor Declarations</h5>
<p>Cursors such as <code>ap_invoice_hdr_cur</code> are declared to select data from source systems.</p>
<h5 id="type-declarations">Type Declarations</h5>
<p>Types such as <code>ap_invoice_hdr_tt</code> are declared for collections based on cursor row types.</p>
<h5 id="variable-declarations">Variable Declarations</h5>
<p>Variables for control flow and process tracking are defined, e.g., <code>ct_ProcOrFuncName</code>, <code>ct_Phase</code>, <code>ct_StgTable</code>.</p>
<h4 id="ap_invoice_hdr_xfm">ap_invoice_hdr_xfm</h4>
<p>This procedure transforms the AP invoice header data prepared in the staging tables into a format suitable for the target system or application.</p>
<h5 id="cursors">Cursors</h5>
<p>Cursors retrieve data to be transformed and also lock the transformed data rows for update.</p>
<h4 id="ap_invoice_lines_stg">ap_invoice_lines_stg</h4>
<p>This procedure stages AP invoice line data.</p>
<h4 id="ap_invoice_lines_xfm">ap_invoice_lines_xfm</h4>
<p>This procedure transforms AP invoice line data after staging.</p>
<h4 id="stg_main">stg_main</h4>
<p>This procedure orchestrates the staging process by dynamically calling individual staging procedures based on metadata retrieved from the <code>xxmx_migration_metadata</code> table.</p>
<h5 id="cursors-1">Cursors</h5>
<p>Cursors like <code>StagingMetadata_cur</code> retrieve metadata required for the staging processes.</p>
<h4 id="xfm_main">xfm_main</h4>
<p>Similar to <code>stg_main</code>, this procedure orchestrates the transformation process by calling individual transformation procedures.</p>
<h4 id="purge">purge</h4>
<p>This procedure is responsible for purging data from staging and transformation tables for a specified migration set.</p>
<h2 id="logic-flow">Logic Flow</h2>
<ol>
<li>The <code>*_stg</code> procedures perform data extraction, staging, and initial preparation of AP invoice headers and lines.</li>
<li>The <code>*_xfm</code> procedures transform the staged data, enriching and modifying it to match the target system's requirements.</li>
<li>The <code>stg_main</code> procedure retrieves metadata for each sub-entity and calls the respective staging procedures.</li>
<li>The <code>xfm_main</code> procedure performs similar operations to <code>stg_main</code>, but for the transformation phase.</li>
<li>The <code>purge</code> procedure cleans up data from staging and transformation tables related to a specified migration set.</li>
</ol>
<h2 id="conclusion">Conclusion</h2>
<p>The <code>xxmx_ap_inv_pkg</code> package handles critical steps in data migration related to AP invoices. It includes routines for staging, transformation, main routines control, and data purging, ensuring that the data is ready for transfer to the target system. The use of cursors, dynamic SQL, and metadata-driven process control are notable aspects of this package.</p>

##  xfm_main

<pre><code class="language-markdown"># xxmx_ap_inv_pkg Package Documentation

## Overview
The `xxmx_ap_inv_pkg` package is part of a larger software application designed to handle data migration, specifically for Cloudbridge AP Invoices. The package includes various procedures for staging (`stg`) and transforming (`xfm`) data, as well as a procedure to purge data associated with a migration set. It is implemented in PL/SQL and intended to be executed in an Oracle Database environment.

The package is part of the AP (Accounts Payable) module, which is situated within the `FIN` (Finance) application suite. The package interacts with multiple schemas (`xxmx_stg`, `xxmx_xfm`, and `xxmx_core`) and relies on various utility packages and data structures for logging, data transformation, and migration management.

## Procedures

### ap_invoice_hdr_stg
This procedure is responsible for staging AP Invoice Header data. It extracts data from source views and tables, transforms it, and inserts it into the staging table `xxmx_ap_invoices_stg`. Data extraction is performed using a cursor defined within the procedure that selects a range of invoice-related information.

**Parameters:**
- `pt_i_MigrationSetID`: The migration set ID.
- `pt_i_SubEntity`: The sub-entity for the migration.

**Cursor:**
- `ap_invoice_hdr_cur`: Fetches data for AP Invoice Headers from the source.

**Example Usage:**
```sql
xxmx_ap_inv_pkg.ap_invoice_hdr_stg(pt_i_MigrationSetID =&gt; 12345, pt_i_SubEntity =&gt; 'AP_INV_HDR');
</code></pre>
<h3 id="ap_invoice_hdr_xfm">ap_invoice_hdr_xfm</h3>
<p>This procedure transforms AP Invoice Header data that has already been staged. It moves data from the staging table to the transform table <code>xxmx_ap_invoices_xfm</code>, applying any necessary data conversions or defaults.</p>
<p><strong>Parameters:</strong></p>
<ul>
<li><code>pt_i_MigrationSetID</code>: The migration set ID.</li>
<li><code>pt_i_SubEntity</code>: The sub-entity for the migration.</li>
<li><code>pt_i_SimpleXfmPerformedBy</code>: Specifies the performer of simple transformations.</li>
</ul>
<p><strong>Example Usage:</strong></p>
<pre><code class="language-sql">xxmx_ap_inv_pkg.ap_invoice_hdr_xfm(pt_i_MigrationSetID =&gt; 12345, pt_i_SubEntity =&gt; 'AP_INV_HDR', pt_i_SimpleXfmPerformedBy =&gt; 'PLSQL');
</code></pre>
<h3 id="ap_invoice_lines_stg">ap_invoice_lines_stg</h3>
<p>This procedure stages AP Invoice Line data. It works similarly to <code>ap_invoice_hdr_stg</code> but operates on invoice lines data instead.</p>
<p><strong>Parameters:</strong></p>
<ul>
<li><code>pt_i_MigrationSetID</code>: The migration set ID.</li>
<li><code>pt_i_SubEntity</code>: The sub-entity for the migration.</li>
</ul>
<p><strong>Example Usage:</strong></p>
<pre><code class="language-sql">xxmx_ap_inv_pkg.ap_invoice_lines_stg(pt_i_MigrationSetID =&gt; 12345, pt_i_SubEntity =&gt; 'AP_INV_LINES');
</code></pre>
<h3 id="ap_invoice_lines_xfm">ap_invoice_lines_xfm</h3>
<p>This procedure transforms AP Invoice Line data post-staging. It performs a similar role to <code>ap_invoice_hdr_xfm</code> but for invoice lines.</p>
<p><strong>Parameters:</strong></p>
<ul>
<li><code>pt_i_MigrationSetID</code>: The migration set ID.</li>
<li><code>pt_i_SubEntity</code>: The sub-entity for the migration.</li>
<li><code>pt_i_SimpleXfmPerformedBy</code>: Specifies the performer of simple transformations.</li>
</ul>
<p><strong>Example Usage:</strong></p>
<pre><code class="language-sql">xxmx_ap_inv_pkg.ap_invoice_lines_xfm(pt_i_MigrationSetID =&gt; 12345, pt_i_SubEntity =&gt; 'AP_INV_LINES', pt_i_SimpleXfmPerformedBy =&gt; 'PLSQL');
</code></pre>
<h3 id="stg_main">stg_main</h3>
<p>A procedure to execute the staging process for all entities within the Finance application suite and AP application.</p>
<p><strong>Parameters:</strong></p>
<ul>
<li><code>pt_i_ClientCode</code>: The client code.</li>
<li><code>pt_i_MigrationSetName</code>: The migration set name.</li>
</ul>
<p><strong>Example Usage:</strong></p>
<pre><code class="language-sql">xxmx_ap_inv_pkg.stg_main(pt_i_ClientCode =&gt; 'CL01', pt_i_MigrationSetName =&gt; 'Migration Set 1');
</code></pre>
<h3 id="xfm_main">xfm_main</h3>
<p>A procedure to execute the transformation process for all entities within the Finance application suite and AP application.</p>
<p><strong>Parameters:</strong></p>
<ul>
<li><code>pt_i_ClientCode</code>: The client code.</li>
<li><code>pt_i_MigrationSetID</code>: The migration set ID.</li>
</ul>
<p><strong>Example Usage:</strong></p>
<pre><code class="language-sql">xxmx_ap_inv_pkg.xfm_main(pt_i_ClientCode =&gt; 'CL01', pt_i_MigrationSetID =&gt; 12345);
</code></pre>
<h3 id="purge">purge</h3>
<p>A procedure to purge all data related to a specified migration set.</p>
<p><strong>Parameters:</strong></p>
<ul>
<li><code>pt_i_ClientCode</code>: The client code.</li>
<li><code>pt_i_MigrationSetID</code>: The migration set ID.</li>
</ul>
<p><strong>Example Usage:</strong></p>
<pre><code class="language-sql">xxmx_ap_inv_pkg.purge(pt_i_ClientCode =&gt; 'CL01', pt_i_MigrationSetID =&gt; 12345);
</code></pre>
<h2 id="exception-handling">Exception Handling</h2>
<p>The package defines a custom exception <code>e_ModuleError</code> to handle errors that may occur during the execution of its procedures. The error handling mechanism includes detailed logging and messaging via the <code>xxmx_utilities_pkg.log_module_message</code> procedure, which facilitates tracking and debugging.</p>
<h2 id="code-snippets">Code Snippets</h2>
<p>Throughout the procedures, the code makes extensive use of cursor operations, bulk data processing (<code>BULK COLLECT</code> and <code>FORALL</code>), dynamic SQL execution, and utility package functions to manage the migration process.</p>
<p>For example, <code>ap_invoice_hdr_stg</code> uses this loop for bulk data insertion:</p>
<pre><code class="language-sql">LOOP
    FETCH ap_invoice_hdr_cur BULK COLLECT INTO ap_invoice_hdr_tbl LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;
    EXIT WHEN ap_invoice_hdr_tbl.COUNT = 0;
    
    FORALL i IN 1..ap_invoice_hdr_tbl.COUNT
         INSERT INTO xxmx_stg.xxmx_ap_invoices_stg (migration_set_id, ...) VALUES (pt_i_MigrationSetID, ...);
END LOOP;
</code></pre>
<h2 id="conclusion">Conclusion</h2>
<p>The <code>xxmx_ap_inv_pkg</code> package provides an essential set of procedures for managing the data staging and transformation processes in the context of Accounts Payable data migration for Cloudbridge integration. Each procedure is tailored to handle specific entities and is designed for modularity, reusability, and ease of maintenance.</p>
<pre><code></code></pre>

## ap_invoice_hdr_stg

<pre><code class="language-markdown"># xxmx_ap_inv_pkg Package Documentation

## Overview
This package `xxmx_ap_inv_pkg` includes procedures for extracting, transforming, and loading Accounts Payable Invoice Header and Lines data as part of a data migration process. It is designed for the Cloudbridge AP Invoices Data Migration in Oracle Applications.

### Authors
- Ian S. Vickerstaff

### Change History
| Version | Date       | Author              | Description                                                            |
|---------|------------|---------------------|------------------------------------------------------------------------|
| 1.0     | DD-Mon-YYYY| Change Author       | Created.                                                               |
| 1.1     | 08-Jan-2020| Ian S. Vickerstaff  | Extract logic updates.                                                 |
| 1.2     | 20-Jan-2020| Ian S. Vickerstaff  | Added GL Account Defaulting logic.                                     |
| 1.3     | 14-Jul-2021| Ian S. Vickerstaff  | Header comments updated.                                               |

## Procedures

### ap_invoice_hdr_stg
**Purpose:** 
Extracts AP Invoice Header data from source tables and populates the staging table `xxmx_ap_invoices_stg`.

**Parameters:**
- `pt_i_MigrationSetID`: The ID of the migration set.
- `pt_i_SubEntity`: The sub-entity for the AP Invoice Header.

**Logic:**
1. Clears module and data messages.
2. Retrieves the Migration Set Name based on `pt_i_MigrationSetID`.
3. Initializes a detail record for the current entity.
4. Extracts data from source tables using `ap_invoice_hdr_cur` cursor.
5. Inserts extracted data into `xxmx_ap_invoices_stg` table.
6. Logs module messages and commits the transaction.

### ap_invoice_hdr_xfm
**Purpose:** 
Transforms the extracted AP Invoice Header data and loads it into the transformation table `xxmx_ap_invoices_xfm`.

**Parameters:**
- `pt_i_MigrationSetID`: The ID of the migration set.
- `pt_i_SubEntity`: The sub-entity for the AP Invoice Header.
- `pt_i_SimpleXfmPerformedBy`: Who performs the simple transformation.

**Logic:**
1. Clears module and data messages.
2. Transforms data and updates the corresponding transformation table.
3. Logs module messages and updates the migration details.
4. Commits the updates if transformations are successful.

### ap_invoice_lines_stg
**Purpose:** 
Extracts AP Invoice Lines data from source tables and populates the staging table `xxmx_ap_invoice_lines_stg`.

**Parameters:**
- `pt_i_MigrationSetID`: The ID of the migration set.
- `pt_i_SubEntity`: The sub-entity for the AP Invoice Lines.

**Logic:**
1. Clears module and data messages.
2. Retrieves the Migration Set Name based on `pt_i_MigrationSetID`.
3. Initializes a detail record for the current entity.
4. Extracts data from source tables using `ap_invoice_lines_cur` cursor.
5. Inserts extracted data into `xxmx_ap_invoice_lines_stg` table.
6. Logs module messages and commits the transaction.

### ap_invoice_lines_xfm
**Purpose:** 
Transforms the extracted AP Invoice Lines data and loads it into the transformation table `xxmx_ap_invoice_lines_xfm`.

**Parameters:**
- `pt_i_MigrationSetID`: The ID of the migration set.
- `pt_i_SubEntity`: The sub-entity for the AP Invoice Lines.
- `pt_i_SimpleXfmPerformedBy`: Who performs the simple transformation.

**Logic:**
1. Clears module and data messages.
2. Transforms data and updates the corresponding transformation table.
3. Logs module messages and updates the migration details.
4. Commits the updates if transformations are successful.

### stg_main
**Purpose:** 
Main procedure to execute all staging procedures for a given client code and migration set.

**Parameters:**
- `pt_i_ClientCode`: The code for the client.
- `pt_i_MigrationSetName`: The name of the migration set.

**Logic:**
1. Clears core and module messages.
2. Initializes the migration set.
3. Loops through the migration metadata and dynamically constructs and executes the staging procedure calls.
4. Commits the transaction and logs module messages.

### xfm_main
**Purpose:** 
Main procedure to execute all transformation procedures for a given client code and migration set ID.

**Parameters:**
- `pt_i_ClientCode`: The code for the client.
- `pt_i_MigrationSetID`: The ID of the migration set.

**Logic:**
1. Clears core and module messages.
2. Loops through the migration metadata and dynamically constructs and executes the transformation procedure calls.
3. Commits the transaction and logs module messages.

### purge
**Purpose:** 
Procedure to purge all data for a given client code and migration set ID.

**Parameters:**
- `pt_i_ClientCode`: The code for the client.
- `pt_i_MigrationSetID`: The ID of the migration set.

**Logic:**
1. Clears module messages.
2. Loops through the migration metadata and purges data from the staging and transformation tables.
3. Commits the transaction and logs module messages.

## Naming Conventions and Code Structure
The package follows specific naming conventions for readability and maintainability:
- `gct_`: Global constant
- `gvv_`: Global variable
- `ct_`: Local constant
- `vv_`: Local variable
- `e_`: Exception
- `pt_i_`: Input parameter
- `pt_o_`: Output parameter
- `pv_`: Procedure variable
- `xxmx_`: Prefix for objects related to the XXMX schema

**Dynamic SQL Execution:**
The procedures dynamically construct and execute SQL statements to perform necessary actions based on input parameters and metadata.

**Cursor Usage:**
Cursors are used to retrieve data from source tables for extraction and to iterate through metadata for purging and transformation processes.

**Error Handling:**
Custom exceptions and Oracle errors are caught, logged, and raised for error handling.

**Committing Transactions:**
Changes are committed after successful execution of the logic within the procedures.

**Logging and Messages:**
Module messages are logged throughout the procedures to provide insight into the process flow and to aid debugging.
</code></pre>

