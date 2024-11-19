Session Killing:
----------------

select * from v$session a, v$locked_object b, dba_objects c
 where a.sid = b.session_id
 and b.object_id = c.object_id
 and c.object_name like 'XXMX_GL_DAILY%';
 
alter system kill session '24,41704' immediate;

=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>