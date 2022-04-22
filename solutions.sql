-- source C:/Users/vm270/Desktop/NEW CAREER/TheSQL/INSTAGRAM CLONE/instagram_clone.sql

-- 1. Finding 5 older users 
select * from users
order by created_at limit 5;

-- 2. Day of the week, most users got registered
select dayname(created_at) as day,count(*) as day_most_users_got_registered from users
group by day
order by day_most_users_got_registered desc limit 2;

-- 3. Users who never posted ( 0 posts )
select distinct(username)
from users
left join photos
on users.id=photos.user_id
where photos.id is null;

-- 4. User with most like on single photo
select users.id,users.username,photos.id,photos.image_url,count(*) as most_likes
from users
inner join photos
on users.id=photos.user_id
inner join likes
on photos.id=likes.photo_id
group by photos.id
order by most_likes desc limit 1;


select users.id,users.username,photos.id,photos.image_url,count(*) as Maximum_likes
from photos
inner join likes
on likes.photo_id=photos.id
inner join users
on photos.user_id=Users.id
group by photos.id
order by Maximum_likes desc limit 1;

--  5. How many times average user post ( avg of no. of posts by each user ))
select (select count(*) from photos) / (select count(*) from users) as average;

-- 6. 5 Most popular hashtags
select tags.tag_name,count(*) as maximum_tags
from tags
inner join photo_tags
on tags.id=photo_tags.tag_id
group by tags.id
order by maximum_tags desc limit 5;

-- 7. Users who have liked every single photo ( Problem of bots )
select users.username,count(*) as posts_liked
from users
inner join likes
on users.id=likes.user_id
group by users.id
having posts_liked=257;

-- 8.  Preventing Self Follows ( Using Database Triggers )

DELIMITER $$
CREATE TRIGGer prevent_self_follows
    BEFORE INSERT ON follows FOR EACH ROW
    BEGIN
        IF NEW.follower_id = NEW.followee_id
        THEN
            SIGNAL SQLSTATE '45000'
        END IF;
    END;
$$
DELIMITER;