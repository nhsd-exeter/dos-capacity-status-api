-- Update test service to inactive
update pathwaysdos.services
set statusid=2
where id=2333; -- uid = 133102

-- Link user to services
insert into pathwaysdos.userservices (userid, serviceid)
values(1000000002, 2333); -- uid = 133102
