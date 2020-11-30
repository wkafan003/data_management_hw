SELECT 'ФИО: Пономаренко Андрей Григорьевич М8О-107М-20';
-- Создание таблицы
create table movie.content_genres
(
	"movieId" integer,
	genre text
);

alter table movie.content_genres owner to postgres;

-- bash: docker cp ./data_store/raw_data/genres.csv postgres_host:/genres.csv
--Считывание из файла данных
begin;

create temporary table temp_csv
(
    values text
) on commit drop;
copy temp_csv from '/genres.csv';

insert into movie.content_genres("movieId", genre)
select split_part(values, ',', 1)::int as moveId, split_part(values, ',', 2) as genre
from temp_csv;

commit;

-- Нахождение топа тэгов и запись в файл + разрешение доступа на дамп
-- bash: docker exec -it postgres_host bash
-- bash: mkdir /usr/share/data_store/
-- bash: mkdir /usr/share/data_store/raw_data/
-- bash: touch /usr/share/data_store/raw_data/tags.csv
-- bash: chmod 0777 /usr/share/data_store/raw_data/
-- bash: chmod 0777 /usr/share/data_store/raw_data/tags.csv
begin;
create temporary table top_rated_tags_temp
(
    values text
) on commit drop;

with top_rated as (
    select movieid, avg(rating) as avg_rating
    from movie.ratings
    group by movieid
    having count(*) > 50
    order by avg_rating desc
    limit 150
)
insert
into top_rated_tags_temp (select distinct genre
                          from top_rated
                                   join movie.content_genres g on top_rated.movieid = g."movieId"
                          order by genre);

copy top_rated_tags_temp to '/usr/share/data_store/raw_data/tags.csv' with csv header delimiter as E'\t';
commit;
