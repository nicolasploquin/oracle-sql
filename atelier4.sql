-- Atelier 4

-- u1 --
create or replace view v_anim as 

  select no_atel, intitule, genre, vente_heure, atelier.no_anim, nom, prenom, tel
    from atelier inner join animateur on atelier.no_anim = animateur.no_anim;
--create or replace view v_anim as 
--  select no_atel, intitule, genre, vente_heure, atelier.no_anim, nom, prenom, tel
--    from atelier,animateur where atelier.no_anim = animateur.no_anim;










create or replace view v_insc as
  select no_insc, jour, date_inscription, note, nom, prenom, ville, sexe, intitule, genre
    from adherent 
      inner join inscription using (no_adher)
      inner join atelier using (no_atel)
  with read only;



















grant select, insert on v_anim to u2;
grant select on v_insc to u2;
create public synonym v_anim_u1 for v_anim;
create public synonym v_insc_u1 for v_insc;

create sequence s_atel start with 120 increment by 1;
grant select on s_atel to u2;
create public synonym s_atel_u1 for s_atel;

-- u2 --
insert into dm_v_anim_u2 (no_atel, intitule, genre, vente_heure, no_anim)
  values (u2.s_atel.nextval, 'GOLF', 'SPORT', 15, 7);

commit;

select * 
  from formation.v_anim
  order by genre, intitule;  
  
select nom,prenom,ville,intitule, genre
  from v_insc
  where upper(trim(ville))='NANTES' and upper(trim(genre))='SCIENCES'
  order by nom, prenom;  
  
  
  
  
  
  
  
  
  
  
  
  
  