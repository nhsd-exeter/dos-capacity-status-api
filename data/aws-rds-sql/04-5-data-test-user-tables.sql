-- Add test users --
insert into pathwaysdos.users (id, username, firstname, lastname, email, createdtime,status)
select 1000000000, 'ViewUser', 'ViewUser', 'ViewUser', null, now(),'ACTIVE'
where not exists (select 'x' from pathwaysdos.users where id = 1000000000 or username = 'ViewUser');

insert into pathwaysdos.users (id, username, firstname, lastname, email, createdtime,status)
select 1000000001, 'EditUser', 'EditUser', 'EditUser', null, now(),'ACTIVE'
where not exists (select 'x' from pathwaysdos.users where id = 1000000001 or username = 'EditUser');

-- Grant required permissions to the new test users --
insert into pathwaysdos.userpermissions (userid, permissionid)
select 1000000001, per.id from pathwaysdos.permissions per where per.name = 'editCapacity';

-- Link user to services
insert into pathwaysdos.userservices (userid, serviceid)
values(1000000000, 6811); -- uid = 153455
insert into pathwaysdos.userservices (userid, serviceid)
values(1000000001, 6811); -- uid = 153455

-- Make some services Ancestors of the Linked services
UPDATE pathwaysdos.services SET parentid=6811  WHERE id=2668;  -- uid = 149198
UPDATE pathwaysdos.services SET parentid=2668  WHERE id=25774; -- uid = 162172
