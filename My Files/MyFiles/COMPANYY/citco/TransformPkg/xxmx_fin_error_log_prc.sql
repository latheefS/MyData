create or replace PROCEDURE xxmx_fin_error_log_prc
(
log_rowid IN VARCHAR2,
error_code IN NUMBER,
error_mesg IN VARCHAR2
)
IS

PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN

INSERT INTO xxmx_fin_error_log VALUES
(
xxmx_fin_seq.NEXTVAL,
log_rowid,
error_code,
error_mesg,
SYSDATE,
USER
);

COMMIT;

EXCEPTION
WHEN OTHERS THEN 
ROLLBACK;

END;