DELETE FROM public.movie_info
WHERE id IN (SELECT id FROM public.movie_info LIMIT 1000);
