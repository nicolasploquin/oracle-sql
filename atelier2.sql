-- Atelier 2.1
insert into Adherent (no_adher, nom, prenom, rue, cp, ville, date_naissance, sexe) 
	values (1,'MARTIN','HENRI','1 rue du Pont','44000','NANTES','02/05/68','M');
insert into Adherent (no_adher, nom, prenom, rue, cp, ville, date_naissance, sexe) 
	values (2,'DELPLAT','ISABELLE',null,'44390','PETIT-MARS',TO_DATE('25/09/1972','DD/MM/YYYY'),'F'); 
insert into Adherent (no_adher, nom, prenom, rue, cp, ville, date_naissance, sexe) 
	values (3,'DELPLAT','ISABELLE',null,'44390',upper('Rezé'),TO_DATE('25/09/1972','DD/MM/YYYY'),'F'); 
commit;

-- Atelier 2.2
insert into Animateur (no_anim, nom, prenom, tel, cout_heure, no_resp, fonction) 
	values (1, 'MICHAUD', 'ALFRED', '02.40.36.36.36', 25, null, 'Agent');
insert into Animateur (no_anim, nom, prenom, tel, cout_heure, no_resp, fonction) 
	values (2, 'LEDLUZ', 'ALAIN', '02.40.25.25.25', 30, null, 'Cadre');
insert into Animateur (no_anim, nom, prenom, tel, cout_heure, no_resp, fonction) 
	values (3, 'MARGOT', 'JULIE', '02.40.58.96.69', 40, null, 'Directeur');
commit;

-- Atelier 2.3
--insert into Atelier(no_atel, intitule, genre, illustration, vente_heure, no_anim) 
--	values(1, 'POTERIE', 'CULTURE', null, 40, 1);
insert into Atelier(no_atel, intitule, genre, illustration, vente_heure, no_anim) 
	values(
    1, 'POTERIE', 'CULTURE', null, 40, 
    (select no_anim from animateur where upper(nom) = 'LEDLUZ')
   );
insert into Atelier(no_atel, intitule, genre, illustration, vente_heure, no_anim) 
	values(2, 'TENNIS', 'SPORT', null, 50, 2);
commit;

-- Atelier 2.4
insert into Activite(no_atel, jour, duree) values(1, 'MA', 2);
insert into Activite(no_atel, jour, duree) values(1, 'ME', 2);
insert into Activite(no_atel, jour, duree) values(2, 'SA', 3);
commit;

-- Atelier 2.5
insert into Inscription(no_insc, no_adher, no_atel, jour, date_inscription, note) 
	values(1, 1, 2, 'SA', to_date('06/05/2006', 'DD/MM/YYYY'), null);
insert into Inscription(no_insc, no_adher, no_atel, jour, date_inscription, note) 
	values(2, 2, 1, 'MA', to_date('09/05/2006', 'DD/MM/YYYY'), null);
insert into Inscription(no_insc, no_adher, no_atel, jour, date_inscription, note) 
	values(3, 2, 2, 'SA', to_date('06/05/2006', 'DD/MM/YYYY'), null);
commit;

-- Atelier 2.6
/*
update Animateur 
  set no_resp = 3 
  where no_anim = 2;
*/

update Animateur 
  set no_resp = (select no_anim from Animateur where nom = 'MARGOT') 
  where upper(nom) = 'LEDLUZ';
  
update Animateur set no_resp = 2 where no_anim = 1;

--update Inscription set note = 15 where no_atel = 2 and no_adher = 1;
update Inscription set 
  note = 15 where 
    no_atel = (select no_atel from Atelier where intitule='TENNIS') and 
    no_adher = (select no_adher from Adherent where nom='MARTIN');

update Inscription set note = 13 where no_atel = 2 and no_adher = 2;
update Inscription set note = 12 where no_atel = 1 and no_adher = 2;
commit;

-- Atelier 2.7
delete from Activite 
  where no_atel = 1 and jour = 'ME';
commit;



