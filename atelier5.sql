-- Atelier 5.1
select nom, prenom, ville
  from adherent
  where
    ville = (
      select ville from adherent
        where upper(trim(nom)) = 'GERMAIN'
    ) 
  order by nom, prenom;
  
select ville 
  from adherent
  where upper(nom) = 'GERMAIN'
;



select nom, prenom, ville
  from adherent
    inner join (
      select ville 
        from adherent
        where upper(nom) = 'GERMAIN'
    ) using (ville)
  order by ville, nom
;





  
select nom, prenom, ville, ville_germain
  from adherent
    cross join (
      select ville ville_germain from adherent
        where upper(nom) = 'GERMAIN'
    )
;

select nom, prenom, ville 
  from adherent adh1
    inner join (
      select ville from adherent
        where upper(nom) = 'GERMAIN'
    ) adh2 using (ville)
;

select nom, prenom, ville 
  from adherent adh1
    inner join (
      select ville from adherent
        where upper(nom) = 'GERMAIN'
    ) adh2 using (ville)
;



-- sans sous-requ�te

select adh.nom, adh.prenom, ville 
  from adherent adh_germain
    inner join adherent adh using (ville)
--    inner join adherent adh on adh_germain.ville = adh.ville
  where adh_germain.nom = 'GERMAIN'
;

select adh.nom, adh.prenom, ville, adh_germain.nom, adh_germain.prenom 
  from adherent adh_germain
    inner join adherent adh using (ville)
--    inner join adherent adh on adh_germain.ville = adh.ville
  where adh_germain.nom = 'GERMAIN'
;


  
-- Atelier 5.2a 
select no_adher, adherent.nom, adherent.prenom, animateur.nom nom_anim
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
    inner join animateur using (no_anim)
  where
    upper(animateur.nom) = 'POIRIER'
  order by nom_anim, prenom;
  
-- Atelier 5.2b 
select no_adher, adherent.nom, adherent.prenom
  from adherent
    inner join inscription using (no_adher)
  where no_atel in (
    select no_atel
      from atelier
        inner join animateur using (no_anim)
      where upper(nom) = 'POIRIER'
  )
  order by nom, prenom
;
  
-- Atelier 5.3a 
select ville, to_char(count(*)/total*100,'90D0') "%"
  from 
    adherent, (select count(*) total from adherent)
  group by ville, total
  order by "%" desc;
  
select ville, no_adher
  from adherent
  order by ville; 
  
select ville, count(no_adher) total_ville
  from adherent
  group by ville
  order by ville; 
  
select count(no_adher) total
  from adherent;
  
  
select ville, total_ville, total, round(total_ville / total * 100, 1) "%"
  from (
    select ville, count(no_adher) total_ville
    from adherent
    group by ville  
  ) cross join (
    select count(no_adher) total
      from adherent
  )
; 
  
--select ville, total_ville, total, round(total_ville / total * 100, 1) "%"
select ville, round(count(*) / total * 100, 1) "%"
  from adherent
    cross join (
      select count(no_adher) total
        from adherent
    )
  group by ville, total
; 

select ville, count(no_adher), total, count(no_adher)/total*100
  from adherent
    cross join (
      select count(no_adher) total
        from adherent
    )
    group by ville, total
; 
  
select ville, round(count(*) / (select count(*) from adherent) * 100, 1) "%"
  from adherent
  group by ville
; 
  

select ville, round(count(no_adher) / total * 100, 2) "%"
  from adherent
    cross join (select count(no_adher) total from adherent)
  group by ville, total
  order by "%" desc, ville
; 
  
(select count(no_adher) from adherent)
  ;


-- Atelier 5.3b 
select ville, to_char(effectif/total*100,'90D0') "%"
  from 
    (select ville, count(*) effectif 
      from adherent
      group by ville),
    (select count(*) total 
      from adherent)
  order by effectif desc;

-- Atelier 5.3c 
select ville, to_char(count(*)/(select count(*) from adherent)*100,'90D0') "%"
  from adherent
  group by ville
  order by "%" desc;
  
-- Atelier 5.3d 
select ville, to_char(ratio_to_report(effectif) over () * 100,'90D0') "%"
  from (
    select ville, count(*) effectif
      from adherent
        group by ville
  )
  order by "%" desc;

select ville, round((ratio_to_report(count(*)) over ()) * 100, 1) "%"
  from adherent
  group by ville
;
select ville, (ratio_to_report(count(*)) over ()) "%"
  from adherent
  group by ville
;


-- Atelier 5.4a 
select no_adher, nom, prenom, date_naissance, intitule, genre
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
  where genre = 'SPORT'
    and not date_naissance < any (
      select date_naissance
        from adherent
          inner join inscription using (no_adher)
          inner join atelier using (no_atel)
        where genre = 'SPORT'
    )
;
  
-- Atelier 5.4b 
select no_adher, nom, prenom, date_naissance, intitule, genre
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
  where
    genre = 'SPORT' and
    date_naissance = (
      select max(date_naissance)
        from adherent
          inner join inscription using (no_adher)
          inner join atelier using (no_atel)
        where genre = 'SPORT'
    )
;
  
-- �tapes interm�diaires
select nom, prenom, intitule, genre, date_naissance
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
  where genre = 'SPORT'
  order by date_naissance desc;
  
select max(date_naissance)
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
  where genre = 'SPORT'
;  

   
-- Atelier 5.4c 
select no_adher, nom, prenom, date_naissance, intitule, genre
  from (
      select max(date_naissance) as date_naissance
        from adherent
          inner join inscription using (no_adher)
          inner join atelier using (no_atel)
        where genre = 'SPORT'
    ) inner join adherent using (date_naissance)
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
  where genre = 'SPORT'
;

select no_adher, nom, prenom, date_naissance
  from (
      select max(date_naissance) as date_naissance
        from adherent
          inner join inscription using (no_adher)
          inner join atelier using (no_atel)
        where genre = 'SPORT'
    ) inner join adherent using (date_naissance)
;



-- Atelier 5.4d
-- avec classement 11g
select * from (
  select nom, prenom, intitule, genre, date_naissance
    from adherent
      inner join inscription using (no_adher)
      inner join atelier using (no_atel)
    where genre = 'SPORT'
    order by date_naissance desc
) where rownum = 1;

-- avec classement 12c
select nom, prenom, intitule, genre, date_naissance
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
  where genre = 'SPORT'
  order by date_naissance desc
  offset 0 rows 
  fetch next 3 rows only;
 
  
-- Atelier 5.5a
-- sous-requ�te corr�l�e
select nom, prenom, ville, date_naissance
  from adherent adh_ext
  where date_naissance = (
      select min(adh_int.date_naissance)
        from adherent adh_int
        where adh_int.ville = adh_ext.ville
    )
  order by date_naissance
;

select nom, prenom, ville, date_naissance
  from adherent adh_ext
;

select min(adh_int.date_naissance)
    from adherent adh_int
    where adh_int.ville = adh_ext.ville
;

-- Atelier 5.5b
select nom, prenom, ville, date_naissance
  from adherent
  where (ville,date_naissance) in (
      select ville, min(date_naissance)
        from adherent
        group by ville
    )
  order by date_naissance
;
-- Atelier 5.5c
select nom, prenom, ville, date_naissance
  from adherent adh inner join (
    select ville, min(date_naissance) date_naissance
        from adherent
        group by ville
    ) using (ville, date_naissance)
--  ) adh_min on adh.ville = adh_min.ville 
--          and adh.date_naissance = adh_min.date_naissance
  order by date_naissance
;




select * from adherent;

select ville, min(date_naissance)
  from adherent
  group by ville
;


select distinct prenom, nom, ville, date_naissance,
      first_value(date_naissance) 
        over (partition by ville order by date_naissance asc) min_date,
      first_value(prenom) 
        over (partition by ville order by date_naissance asc) prenom_min
  from adherent
  order by ville, date_naissance
;

select distinct
  first_value(prenom) over (partition by ville order by date_naissance asc) prenom,
  first_value(nom) over (partition by ville order by date_naissance asc) nom,
  first_value(ville) over (partition by ville order by date_naissance asc) ville,
  first_value(date_naissance) over (partition by ville order by date_naissance asc) date_naissance
  from adherent
  order by date_naissance
;


-- Atelier 5.6
select nom, prenom, note, intitule
  from adherent 
    inner join inscription using (no_adher)
    inner join (
      select no_atel,intitule,max(note) note
        from atelier 
          inner join inscription using (no_atel)
        group by no_atel, intitule
    ) using (no_atel,note)
  order by note desc,intitule
;

select nom, prenom, note, intitule      -- avec fonction analytique rank()
  from (
        select no_insc, no_atel, no_adher, note,
            rank() over (partition by no_atel order by note desc) note_rank
        from inscription
    ) inner join atelier using (no_atel)
    inner join adherent using (no_adher)
    where note_rank = 1
  order by note desc,intitule
;



-- Atelier 5.7
select no_anim,nom,prenom,avg(note) moyenne
  from inscription 
    inner join atelier using (no_atel)
    inner join animateur using (no_anim)
  group by no_anim,nom,prenom
    having avg(note) = (
      select max(avg(note)) moyenne
        from inscription
          inner join atelier using (no_atel)
        group by no_anim
    )
;

select max(avg(note)) moyenne
  from inscription
    inner join atelier using (no_atel)
  group by no_anim
;

select max(avg(note)) moyenne
  from inscription
    inner join atelier using (no_atel)
  group by no_anim
;

select max(note)
  from inscription
    inner join atelier using (no_atel)
;





-- Atelier 5.8a
select 
  no_adher,nom,prenom,rue,cp,ville,intitule,jour,
  duree,vente_heure,vente_heure*duree montant,total 
from adherent
  inner join inscription using (no_adher) 
  inner join activite  using (no_atel,jour)
  inner join atelier using (no_atel)
  cross join (
    select sum(vente_heure*duree) total
      from adherent
        inner join inscription using (no_adher) 
        inner join activite  using (no_atel,jour)
        inner join atelier using (no_atel)
      where no_adher=6
  )
where no_adher=6;

-- Atelier 5.8b
select 
  no_adher,nom,prenom,rue,cp,ville,intitule,jour
  duree,vente_heure,vente_heure*duree montant,total 
from adherent
  inner join inscription using (no_adher) 
  inner join activite  using (no_atel,jour)
  inner join atelier using (no_atel)
  cross join (
    select sum(vente_heure*duree) total
      from adherent
        inner join inscription using (no_adher) 
        inner join activite  using (no_atel,jour)
        inner join atelier using (no_atel)
      where no_adher=6
  )
where no_adher=6;

-- Atelier 5.9a
select distinct ville, genre, intitule
  from adherent cross join atelier
minus
select ville, genre, intitule
  from adherent
    inner join inscription using (no_adher) 
    inner join atelier using (no_atel)
order by ville, genre, intitule
;

select distinct ville, genre
  from adherent cross join atelier
minus
select ville, genre
  from adherent
    inner join inscription using (no_adher) 
    inner join atelier using (no_atel)
order by ville, genre
;

-- Atelier 5.9b
select distinct ville, genre, count(no_insc) effectif
  from adherent
    cross join atelier
    left outer join inscription using (no_adher, no_atel)
  group by ville, genre
    having count(no_insc) = 0
order by effectif desc, ville, genre
;

select distinct ville, genre, intitule, no_insc
  from adherent
    cross join atelier
    left outer join inscription using (no_adher, no_atel)
order by ville, genre, intitule, no_insc
;

select ville, genre, count(no_insc) effectif
  from adherent
    cross join atelier
    left outer join inscription using (no_adher, no_atel)
  group by ville, genre
order by ville, genre, effectif
;

select * from (
  select ville, genre, no_insc
    from adherent
      cross join atelier
      left outer join inscription using (no_adher, no_atel)
) pivot (
  count(no_insc)
  for genre in ('SPORT' as sport,'SCIENCES' as sciences,'TNIC' as tnic,'CULTURE' as culture)
);

select * from (
  select nvl(ville,'TOUTES') ville, nvl(genre,'TOUS') genre, count(no_insc) effectif
    from adherent
      cross join atelier
      left outer join inscription using (no_adher, no_atel)
    group by cube (ville, genre)
) pivot (
  sum(effectif)
  for genre in ('CULTURE' as culture,'SPORT' as sport,'TNIC' as tnic,'SCIENCES' as sciences, 'TOUS' as tous)
)
order by tous desc, ville;




-- Atelier 5.10a
select ville, genre, to_char(100*count(*)/effectif_ville,'990D0') "%"
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
    inner join (
      -- effectif par ville
      select ville, count(*) effectif_ville
        from adherent
          inner join inscription using (no_adher)
        group by ville
    ) using (ville)
  group by ville, genre, effectif_ville
    having (ville, count(*)) in (
      -- effectif max par ville pour un genre
      select ville, max(effectif) effectif_max
        from (
          select ville, genre, count(*) effectif
            from adherent
              inner join inscription using (no_adher)
              inner join atelier using (no_atel)
            group by ville, genre
        )
        group by ville
    )
  order by ville, genre
;

-- Participation par ville et genre
select nom, prenom, ville, genre --, count(*) participation_genre
  from adherent
    left outer join inscription using (no_adher)
    left outer join atelier using (no_atel)
--  group by (ville,genre)
  order by ville, genre desc;
  
select nom, prenom, ville
    from adherent
    order by ville, nom
;



-- effectif par ville
select ville, count(*) effectif_ville
  from adherent
    inner join inscription using (no_adher)
  group by ville
;

-- pourcentage ville par genre
select ville, genre, to_char(100*count(*)/effectif_ville,'990D0') "%"
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
    inner join (
      -- effectif par ville
      select ville, count(*) effectif_ville
        from adherent
          inner join inscription using (no_adher)
        group by ville
    ) using (ville)
  group by ville, genre, effectif_ville
  order by ville, "%" desc
;

-- effectif max par ville pour un genre
select ville, max(effectif) effectif_max
  from (
    select ville, genre, count(*) effectif
      from adherent
        inner join inscription using (no_adher)
        inner join atelier using (no_atel)
      group by ville, genre
  )
  group by ville
;
  
-- Participation a Angers
select no_insc,nom,prenom,intitule,genre
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
  where
    upper(ville) = 'ANGERS'
;


select ville, genre, ratio_to_report(count(no_insc)) over (partition by ville) "%"
    from adherent
        inner join inscription using (no_adher)
        inner join atelier using (no_atel)
    group by ville, genre
;


select ville, genre, 
    ratio_to_report(count(no_insc)) over (partition by ville) "%", 
    rank() over (partition by ville order by count(no_insc) desc) rang
    from adherent
        inner join inscription using (no_adher)
        inner join atelier using (no_atel)
    group by ville, genre
;

-- Atelier 5.10b
select ville, genre, to_char("%"*100,'990D0')||'%' "%" 
    from (
        select ville, genre, 
            ratio_to_report(count(no_insc)) over (partition by ville) "%", 
            rank() over (partition by ville order by count(no_insc) desc) rang
            from adherent
                inner join inscription using (no_adher)
                inner join atelier using (no_atel)
            group by ville, genre
    )
    where rang = 1
;




