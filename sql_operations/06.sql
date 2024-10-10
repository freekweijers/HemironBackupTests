INSERT INTO public.company_name (id, name, country_code, imdb_id, name_pcode_nf, name_pcode_sf, md5sum)
SELECT generate_series(234998, 244998),
       md5(random()::text),
       substring(md5(random()::text) from 1 for 6),
       floor(random() * 100000),
       substring(md5(random()::text) from 1 for 5),
       substring(md5(random()::text) from 1 for 5),
       md5(random()::text);
