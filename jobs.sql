use msdb;
go 

exec sp_add_job 'calculate_fine';

go
exec sp_add_jobstep 
@job_name = 'calculate_fine' , 
@step_name = 'execute procedure',
@subsystem = 'TSQL',
@database_name = 'EduLib3',
@command = 'exec poc_calculate_fine;',
@on_success_action  = 1;

go
exec sp_add_schedule 
@schedule_name ='daily fine' ,
@freq_type  = 4,
@freq_interval = 1,
@active_start_time = 080000;

go
exec sp_attach_schedule 
@job_name = 'calculate_fine',
@schedule_name ='daily fine';

go 
exec sp_add_jobserver 
@job_name = 'calculate_fine';

go



