-- Atelier 3.a1
select no_anim, intitule, genre, nom, prenom
  from atelier
    inner join animateur using (no_anim)
  where genre = 'SCIENCES'
  order by genre, intitule, nom;
  
-- Atelier 3.a2
select animateur.no_anim, intitule, genre, nom, prenom
  from atelier
    inner join animateur on animateur.no_anim = atelier.no_anim
  where
    genre = 'SCIENCES'
  order by genre, intitule, nom;
  
-- Atelier 3.a3 
select intitule, genre, nom, prenom
  from atelier, animateur
  where atelier.no_anim = animateur.no_anim 
    and genre = 'SCIENCES'
  order by genre, intitule, nom;
  
-- Atelier 3.b 
select intitule, jour, prenom || ' ' || nom as nom_complet, date_inscription
  from atelier
    inner join inscription using (no_atel)
    inner join adherent using (no_adher)
  where
    ville = 'NANTES'
--    and length(nom_complet) > 15
  order by nom_complet, intitule, jour;





















-- Atelier 3.c 
select intitule, to_char(avg(note),'90D0') moyenne
  from atelier
    inner join inscription using (no_atel)
  group by intitule
  order by moyenne desc;
select intitule, round(avg(note),1) moyenne
  from atelier
    inner join inscription using (no_atel)
  group by intitule
  order by moyenne desc;
  
-- Atelier 3.d 
select nvl(ville,'TOUTES') as ville, nvl(genre,'TOUS') as genre, count(*) effectif
--select ville, genre, count(*) effectif
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
--  group by cube (ville, genre)
  group by cube (ville, genre)
  order by effectif desc, ville, genre;
  
select genre, ville, count(*) effectif
  from inscription
    inner join adherent using (no_adher)
    inner join atelier using (no_atel)
  group by cube (genre, ville) -- rollup
  order by genre, ville;
  
-- Atelier 3.e1 
select nom, prenom, tel
  from animateur,atelier
  where
    animateur.no_anim = atelier.no_anim (+) and
    no_atel is null
  order by nom;
  
-- Atelier 3.e2 
select nom, prenom, tel, no_atel, intitule
  from animateur
    left outer join atelier using (no_anim)
  where
    no_atel is null
  order by nom;
  
-- Atelier 3.e3 
select nom, prenom, tel
  from animateur
minus
select nom, prenom, tel
  from animateur
    inner join atelier using (no_anim)
order by nom;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
-- Atelier 3.f1 
select nom, prenom, ville
  from inscription
    inner join adherent using (no_adher)
    inner join atelier using (no_atel)
  where genre = 'SCIENCES'
intersect
select nom, prenom, ville
  from inscription
    inner join adherent using (no_adher)
    inner join atelier using (no_atel)
  where genre = 'TNIC'
order by nom;

-- Atelier 3.f2 
select distinct nom, prenom, count(distinct genre)
  from inscription
    inner join adherent using (no_adher)
    inner join atelier using (no_atel)
  where genre = 'SCIENCES' or genre = 'TNIC'
  group by nom, prenom
    having count(distinct genre) = 2
  order by nom, prenom
;

-- Atelier 3.g1 
select distinct nom, prenom
  from inscription
    inner join adherent using (no_adher)
    inner join atelier using (no_atel)
  where intitule in ('POTERIE','PEINTURE')
  order by nom;
  
-- Atelier 3.g2 
select distinct nom, prenom, ville
  from atelier
    inner join inscription using (no_atel)
    inner join adherent using (no_adher)
  where intitule = 'POTERIE' 
    or  intitule = 'PEINTURE'
  order by nom;
  
-- Atelier 3.g3 
select nom, prenom, ville
  from inscription
    inner join adherent using (no_adher)
    inner join atelier using (no_atel)
  where intitule = 'POTERIE'
union
select nom, prenom, ville
  from inscription
    inner join adherent using (no_adher)
    inner join atelier using (no_atel)
  where intitule = 'PEINTURE'
order by nom
;
  
-- Atelier 3.h 
select no_atel, intitule, genre, count(*) effectif
  from inscription
    inner join atelier using (no_atel)
  group by intitule, genre, no_atel
    having count(*) > 2
  order by effectif desc
;

select no_atel, intitule, genre, no_insc, no_adher
  from inscription
    inner join atelier using (no_atel)
  order by genre, intitule
;

  
select count(*)
  from inscription
    inner join atelier using (no_atel)
;
select intitule, count(*)
  from inscription
    inner join atelier using (no_atel)
  group by intitule
;
select genre, count(*)
  from inscription
    inner join atelier using (no_atel)
  group by genre
;
select genre,intitule, count(*)
  from inscription
    inner join atelier using (no_atel)
  group by (genre,intitule)
;
  
  
-- Atelier 3.i 
select intitule, to_char(avg(floor(months_between(add_months(trunc(sysdate,'YYYY'),12)-1, date_naissance)/12)),'90D0') age
  from atelier
    inner join inscription using (no_atel)
    inner join adherent using (no_adher)
  group by intitule
    having avg(floor(months_between(add_months(trunc(sysdate,'YYYY'),12), date_naissance)/12)) > 52
  order by age desc, intitule
;  

select intitule, to_char(avg(age),'90D0') age_moyen
  from atelier
    inner join inscription using (no_atel)
    inner join adherent using (no_adher)
  group by intitule
    having avg(age) > 52
  order by age_moyen desc, intitule
; 

-- Age des participants par atelier
select intitule, floor(months_between(sysdate, date_naissance)/12) age, date_naissance, prenom, nom
  from atelier
    inner join inscription using (no_atel)
    inner join adherent using (no_adher)
  order by intitule, age desc
;
  
-- Age moyen des participants par atelier
select intitule, to_char(avg(floor(months_between(sysdate, date_naissance)/12)),'90D0') age
  from atelier
    inner join inscription using (no_atel)
    inner join adherent using (no_adher)
  group by intitule
  order by age desc, intitule
;
  
  
  
  
  
  
  
