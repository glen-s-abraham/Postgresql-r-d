select id from users order by id desc limit 3;
select username,caption from users join posts on users.id = posts.user_id where users.id = 200;
select username,(select count(*) from likes l where l.user_id=u.id) as like_counts from users u;

show data_directory;
select oid,datname from pg_database;
select * from pg_class;

create index users_username_idx on users(username);

explain analyse select * from users where username = 'Emil30';
----Execution Time: 0.517 ms

drop index users_username_idx;

explain analyse select * from users where username = 'Emil30';
----Execution Time: 0.896 ms

create index users_username_idx on users(username);
select pg_size_pretty(pg_relation_size('users'));
select pg_size_pretty(pg_relation_size('users_username_idx'));

select relname,relkind from pg_class where relkind='i';

explain select username, contents from users join comments on comments.user_id = users.id where username = 'Alyson14';
explain analyze select username, contents from users join comments on comments.user_id = users.id where username = 'Alyson14';

----Common Table Expression

select users.username,tags.created_at 
from users 
join (
	select user_id,created_at from caption_tags 
	union all 
	select user_id, created_at from photo_tags
)as tags on tags.user_id = users.id
where tags.created_at < '2010-01-07';

----CTE version of the above query
with tags as (
	select user_id,created_at from caption_tags 
	union all 
	select user_id, created_at from photo_tags
)
select users.username,tags.created_at 
from users 
join tags on tags.user_id = users.id
where tags.created_at < '2010-01-07';

---- recursive CTE's
with recursive countdown(val) as (
	select 3 as val 
	union
	select val-1 from countdown where val >1
)
select * from countdown

WITH RECURSIVE suggestions(leader_id, follower_id, depth) AS (
    SELECT leader_id, follower_id, 1 AS depth
    FROM followers
    WHERE follower_id = 1000
    
    UNION
    
    SELECT f.leader_id, f.follower_id, s.depth + 1
    FROM followers f
    JOIN suggestions s ON s.leader_id = f.follower_id
    WHERE s.depth < 3
)
SELECT DISTINCT u.id, u.username
FROM suggestions s
JOIN users u ON u.id = s.leader_id
WHERE s.depth > 1
LIMIT 30;

