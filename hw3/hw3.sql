SELECT 'ФИО: Пономаренко Андрей Григорьевич М8О-107М-20';
-- 1
-- 1.1
select userid,
       movieid,
       (rating - min(rating) over (partition by user)) /
       (max(rating) over (partition by user) - min(rating) over (partition by user)) as normed_rating,
       avg(rating) over (partition by userid)                                        as avg_rating
from movie.ratings
limit 30;