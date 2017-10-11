-- Atelier 6.1
select next_day(sysdate+7,6) from dual;

select * from v_insc;
select * from v_anim;

select * 
  from inscription inner join atelier using (no_atel)
  where upper(trim(genre))='SPORT';
      
create sequence s_no 
  start with 200
  increment by 1
  nocycle
  nomaxvalue;
  
insert into atelier (no_atel, intitule, genre, vente_heure, no_anim)
  values (c_id.nextval, 'VOILE', 'SPORT', 12, 7);
insert into activite (no_atel, jour, duree) values ((select no_atel from atelier where intitule = 'VOILE'),'SA',3);
insert into activite (no_atel, jour, duree) values ((select no_atel from atelier where intitule = 'VOILE'),'DI',3);
insert into activite (no_atel, jour, duree) values ((select no_atel from atelier where intitule = 'VOILE'),'ME',3);
  
insert into atelier (intitule, genre, vente_heure, no_anim)
  values ('PIANO', 'CULTURE', 20, 5);
insert into activite (no_atel, jour, duree) values ((select no_atel from atelier where intitule = 'PIANO'),'LU',1);
insert into activite (no_atel, jour, duree) values ((select no_atel from atelier where intitule = 'PIANO'),'MA',1);
insert into activite (no_atel, jour, duree) values ((select no_atel from atelier where intitule = 'PIANO'),'JE',1);
insert into activite (no_atel, jour, duree) values ((select no_atel from atelier where intitule = 'PIANO'),'VE',1);

insert into inscription (no_atel, no_adher, jour, date_inscription) values ((select no_atel from atelier where intitule = 'PIANO'),12,'LU',sysdate);
insert into inscription (no_atel, no_adher, jour, date_inscription) values ((select no_atel from atelier where intitule = 'PIANO'),12,'LU',sysdate);

commit;
  
  
insert into activite values (40,'SA',3);
insert into activite values (40,'DI',3);

-- Inscrire à l'atelier Voile les adherents ne pratiquant pas de sport

create table info_inscription_genre as
  select no_adher, no_insc, no_atel, jour, genre
      from inscription inner join atelier using (no_atel)
;



merge into Inscription insc
  using (
    select no_adher, genre 
      from info_inscription_genre where genre='SPORT'
  ) inscSport
  on(
    insc.no_adher = inscSport.no_adher
  )
  when not matched then
    insert (no_insc,no_adher,no_atel,jour,date_inscription,date_sortie)
     values (s_no.nextval,inscSport.no_adher,40,'SA',sysdate,next_day(sysdate,6));
--    insert (no_insc,no_adher,no_atel,jour,date_inscription,date_sortie)
--     values (s_no.nextval,inscSport.no_adher,40,'SA',sysdate,next_day(sysdate+7,6))
--    insert (no_insc,no_adher,no_atel,jour,date_inscription,date_sortie)
--     values (s_no.nextval,inscSport.no_adher,40,'DI',sysdate,next_day(sysdate+7,7))
--    insert (no_insc,no_adher,no_atel,jour,date_inscription,date_sortie)
--     values (s_no.nextval,inscSport.no_adher,40,'SA',sysdate,next_day(sysdate+14,6))
    insert (no_insc,no_adher,no_atel,jour,date_inscription,date_sortie)
     values (s_no.nextval,inscSport.no_adher,40,'DI',sysdate,next_day(sysdate+14,7))
;
     
 select * from v_insc;

     






select genre, intitule, decode(jour,'LU','LUNDI','MA','MARDI','ME','MERCREDI','JE','JEUDI','VE','VENDREDI','SA','SAMEDI','DI','DIMANCHE','NULL') jour
  from atelier
    inner join activite using (no_atel)
  order by genre, intitule, jour
;































   
     