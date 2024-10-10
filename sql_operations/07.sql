CREATE TEMP TABLE temp_movie_info AS
SELECT mi.id, mi.info, t.title
FROM public.movie_info mi
         JOIN public.title t ON mi.movie_id = t.id
WHERE t.production_year BETWEEN 1990 AND 2000;
