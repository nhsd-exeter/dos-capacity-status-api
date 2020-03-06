-- Add inactive test user --
insert into pathwaysdos.users (id, username, firstname, lastname, email, createdtime,status)
select 1000000003, 'InActiveTestUser', 'InActiveTestUser', 'InActiveTestUser', null, now(),'INACTIVE'
where not exists (select 'x' from pathwaysdos.users where id = 1000000003 or username = 'InActiveTestUser');

 -- Grant required permissions to the new test users --
insert into pathwaysdos.userpermissions (userid, permissionid)
select 1000000003, per.id from pathwaysdos.permissions per where per.name = 'editCapacity';

-- Link user to services
insert into pathwaysdos.userservices (userid, serviceid)
values(1000000003, 6811); -- uid = 153455
