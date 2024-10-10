UPDATE public.cast_info
SET note = md5(random()::text)
WHERE id BETWEEN 5000 AND 10000;
