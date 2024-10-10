INSERT INTO public.movie_link (id, movie_id, linked_movie_id, link_type_id)
SELECT generate_series(200000, 201000),
       floor(random() * 1000000) + 1,
       floor(random() * 1000000) + 1,
       floor(random() * 10) + 1;
