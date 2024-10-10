INSERT INTO public.aka_name (id, person_id, name, imdb_index, name_pcode_cf, name_pcode_nf, surname_pcode, md5sum)
SELECT generate_series(1000000, 1001000),
       floor(random() * 1000000) + 1,
       md5(random()::text),
       substring(md5(random()::text) from 1 for 3),
       md5(random()::text),
       md5(random()::text),
       md5(random()::text),
       md5(random()::text);
