/* Decode, NVL, NVL2 */

-- Group By Cube et Rollup
select nvl(ville,'TOUTES'), nvl(genre,'TOUS'), count(*) effectif
  from adherent
    inner join inscription using ( no_adher )
    inner join atelier using ( no_atel ) 
  group by cube (genre, ville)
  order by ville, genre
;

-- Liste des adherents de Nantes et leurs jours d'activité (Decode)
select nom, prenom, genre, decode(jour, 'LU', 'Lundi', 'MA', 'Mardi', 'ME', 'Mercredi', 'JE', 'Jeudi', 'VE', 'Vendredi', 'SA', 'Samedi', 'DI', 'Dimanche') jour
  from v_insc
  where upper(ville) = 'NANTES'
  order by jour;
-- DECODE
select intitule, decode(jour,'LU','Lundi','MA','Mardi','ME','Mercredi','JE','Jeudi','VE','Vendredi','SA','Samedi','pas d activité le dimanche') jour
  from atelier
    inner join activite using (no_atel)
;

-- Liste des Animateurs (nom, prenom, intitulé (ou pas d'atelier) ) (NVL)
select nom, prenom, nvl(intitule, 'pas d''atelier') intitule
  from animateur
    left outer join atelier using (no_anim)
  order by nom, prenom;

-- Liste des Animateurs (nom, prenom, prix atelier (ou pas d'atelier) ) (NVL2)
select nom, prenom, nvl2(vente_heure, to_char(vente_heure), 'pas d''atelier') prix
  from animateur
    left outer join atelier using (no_anim)
  order by nom, prenom;




/* PERCENT_RANK et RANK */
select percent_rank(65) within group (order by vente_heure) "% rank"
  from atelier;
 
select intitule, vente_heure, round(( percent_rank() over (order by vente_heure)    )*100,1) "% rank"
  from atelier;
  
select no_atel, intitule, vente_heure, percent_rank() over (order by vente_heure) as rank
  from atelier
;

select * from (
  select no_atel, intitule, vente_heure, rank() over (order by vente_heure desc) rank
    from atelier
) where rank < 5;
 
select genre, rank(50) within group (order by vente_heure) rank
  from atelier
  group by genre;
 
select intitule, genre, vente_heure, rank() over (order by vente_heure) rank
  from atelier
  order by vente_heure;
 
select intitule, vente_heure
  from atelier
  order by vente_heure;
  
-- ratio_to_report

select ville, round(ratio_to_report(effectif) over () * 100, 2) "%"
  from (
    select ville, count(*) effectif
      from adherent
        group by ville
  )
;

select ville, round((ratio_to_report(count(*)) over ()) * 100, 2) "%"
  from adherent
  group by ville
;

select ville, ratio_to_report(count(*)) over () "%"
  from adherent
  group by ville
;
  
  
  

/* FIRST_VALUE et LAST_VALUE */
select distinct nom, prenom, ville, date_naissance
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
  order by ville, date_naissance
;



select distinct nom, prenom, ville, date_naissance, 
  first_value(date_naissance) over (partition by ville order by date_naissance asc) min_date
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
  order by ville, date_naissance
;

select nom, prenom, ville, date_naissance --, first_value(date_naissance) over (partition by ville order by date_naissance asc) age
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
  where date_naissance = first_value(date_naissance) over (partition by ville order by date_naissance asc)
  order by ville
;

select distinct
  first_value(prenom) over (partition by ville order by date_naissance asc) prenom,
  first_value(nom) over (partition by ville order by date_naissance asc) nom,
  first_value(ville) over (partition by ville order by date_naissance asc) ville,
  first_value(date_naissance) over (partition by ville order by date_naissance asc) date_naissance
  from adherent
  order by date_naissance
;

select nom, prenom, ville, date_naissance from (
  select distinct nom, prenom, ville, date_naissance, first_value(date_naissance) over (partition by ville order by date_naissance asc) min_date
    from adherent
      inner join inscription using (no_adher)
      inner join atelier using (no_atel)
    order by min_date, date_naissance
) where min_date = date_naissance;

select distinct nom, prenom, ville, date_naissance, 
  first_value(date_naissance) over (partition by ville order by date_naissance asc) min_date,
  first_value(nom) over (partition by ville order by date_naissance asc) min_date_nom
  from adherent
  order by min_date, date_naissance
;


-- DECODE
select intitule, decode(jour,'LU','Lundi','MA','Mardi','ME','Mercredi','JE','Jeudi','VE','Vendredi','SA','Samedi','pas d activité le dimanche')
  from atelier
    inner join activite using (no_atel)
;

-- VARIANCE
select intitule, vente_heure, round(variance(vente_heure) over (order by intitule),0) var from atelier;
select intitule, vente_heure from atelier order by vente_heure desc;

-- expression reguliere

select 'OK'  from dual
    where regexp_like('+33-123-456-789','^(\+33|0)([\.\-]|[[:space:]])?[1-9](([\.\-]|[[:space:]])?[[:digit:]]){8}$');

select 'OK'  from dual
    where 1 = 1;



-- ajout d'une virgule après le numéro de rue dans l'adresse
select rue, regexp_replace(rue, '([[:digit:]]+)([[:space:]]+)', '\1, ') from adherent;

update adherent
    set rue = regexp_replace(rue, '([[:digit:]]+)([[:space:]]+)', '\1, ')
    where regexp_like(rue, '([[:digit:]]+)([[:space:]]+)')
;

commit;








-- Calculer les recettes de chaque activité (intitulé/jour)
select intitule, jour, duree, vente_heure, sum(duree * vente_heure) recettes
  from adherent
    inner join inscription using (no_adher)
    inner join activite using (no_atel, jour)
    inner join atelier using (no_atel)
  group by intitule, jour, duree, vente_heure
  order by recettes desc
;

-- Afficher l'activité qui dégage la marge la plus importante
select intitule, jour, animateur.nom, duree, vente_heure, cout_heure, sum(duree * vente_heure) - (duree * cout_heure) marge
  from adherent
    inner join inscription using (no_adher)
    inner join activite using (no_atel, jour)
    inner join atelier using (no_atel)
    inner join animateur using (no_anim)
  group by intitule, jour, duree, vente_heure, animateur.nom, cout_heure
  order by intitule, marge desc
;

-- Activités n'ayant pas d'inscrits
select intitule, jour, count(no_insc) effectif
  from adherent
    inner join inscription using (no_adher)
    right outer join activite using (no_atel, jour)
    inner join atelier using (no_atel)
    group by intitule, jour
      having count(no_insc) = 0
    order by effectif desc, intitule, jour
;





select adherent.prenom, intitule, jour, animateur.nom
  from adherent
    inner join inscription using (no_adher)
    inner join activite using (no_atel, jour)
    inner join atelier using (no_atel)
    inner join animateur using (no_anim)
  order by intitule, jour, adherent.prenom
;

-- PIVOT
select ville, genre, count(no_insc)
  from adherent
    inner join inscription using (no_adher)
    inner join activite using (no_atel, jour)
    inner join atelier using (no_atel)
  group by cube (ville, genre)
  order by ville, genre
;

-- Effectif par ville et par genre
select ville, genre, count(no_insc) effectif
    from adherent
      inner join inscription using (no_adher)
      inner join activite using (no_atel, jour)
      inner join atelier using (no_atel)
  group by cube (ville, genre)
  order by ville, genre
;



select * from (
  select ville, sexe, genre, no_insc
    from adherent
      inner join inscription using (no_adher)
      inner join activite using (no_atel, jour)
      inner join atelier using (no_atel)
)
pivot
(
  count(no_insc)
  for genre in ('SCIENCES' as sciences,'SPORT' as sport,'CULTURE' as culture,'TNIC' as tnic)
)
order by ville;


select * from (
  select ville, genre, no_insc
    from adherent
      inner join inscription using (no_adher)
      inner join activite using (no_atel, jour)
      inner join atelier using (no_atel)
)
pivot
(
  count(no_insc)
  for genre in (select genre in atelier group by genre)
)
order by ville;

-- Effectif par animateur et par genre
select * from (
  select prenom, nom, genre, no_insc
    from inscription
      inner join activite using (no_atel, jour)
      inner join atelier using (no_atel)
      inner join animateur using (no_anim)
)
pivot
(
  count(no_insc)
  for genre in ('SCIENCES','SPORTS','CULTURE','TNIC')
)
order by nom;

-- Effectif pour toutes les villes et tous les genres
select ville, genre, count(no_insc) effectif
  from atelier
    cross join adherent
    left outer join inscription using (no_adher, no_atel)
  group by ville, genre
  order by ville, genre
;

-- requêtes hiérarchique

select no_anim, no_resp, nom
  , SYS_CONNECT_BY_PATH(nom, '<-') superieurs
  , decode(CONNECT_BY_ISLEAF,0,'Cadre','Animateur') statut
  , level
  , CONNECT_BY_ROOT nom big_chef
  , PRIOR nom superieur_direct
  from animateur
  start with no_resp is null
  connect by prior no_anim = no_resp;


select no_anim, no_resp, nom, SYS_CONNECT_BY_PATH(nom, '->') superieurs, 
    CONNECT_BY_ISLEAF, level, CONNECT_BY_ROOT nom big_chef, PRIOR nom superieur_direct
  from animateur
  start with no_anim = 2
  connect by no_anim = prior no_resp;


    
