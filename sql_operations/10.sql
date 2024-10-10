DROP TABLE IF EXISTS public.temp_table;
CREATE TABLE public.temp_table AS
SELECT * FROM public.movie_info WHERE id < 5000;
