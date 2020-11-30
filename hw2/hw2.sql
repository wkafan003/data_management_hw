SELECT 'ФИО: Пономаренко Андрей Григорьевич М8О-107М-20';
-- 1
-- 1.1
select *
from movie.ratings
limit 10;
-- 1.2
select *
from movie.links
where imdbid like '%42'
  and movieid >= 100
  and movieid <= 1000
limit 10;
-- 2
select *
from movie.links
         join movie.ratings r on links.movieid = r.movieid
where r.rating = 5
limit 10;
-- 3
-- 3.1
select count(*)
from movie.links
         left join movie.ratings r on links.movieid = r.movieid
where r.rating IS NULL;
-- 3.2
select userid
from movie.ratings
group by userid
having avg(rating) > 3.5
limit 10;
-- 4
-- 4.1
select imdbid
from movie.links
where movieid in (select ratings.movieid
                  from movie.ratings
                  group by movieid
                  having avg(rating) > 3.5)
limit 10;
-- 4.2
select avg(rating)
from movie.ratings
where userid in (select userid
                 from movie.ratings
                 group by userid
                 having count(*) > 10);
