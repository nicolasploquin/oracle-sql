--set serveroutput on;

--
-- suppression des tables
--
drop table Inscription;
drop table Activite;
drop table Atelier;
drop table Animateur;
drop table Adherent;
--
-- création des tables
--
--
-- création de la table adhérent
--
create table Adherent (
	no_adher number(4),
	nom varchar2(25), 
	prenom varchar2(25), 
	rue varchar2(35), 
	cp char(5), 
	ville varchar2(25), 
	date_naissance date, 
	sexe char(1), 
	constraint ck_adh_sexe check(sexe in ('F','M')), 
	constraint pk_adh primary key(no_adher));
  
--
-- création de la table animateur
--
create table Animateur (
	no_anim number(4) ,
	nom varchar2(25) , 
	prenom varchar2(25), 
	tel char(14), 
	no_resp number(4), 
	fonction varchar2(9), 
	cout_heure number(4), 
	constraint ck_ani_fct check(fonction in ('Agent','Cadre','Directeur')), 
	constraint pk_ani primary key(no_anim));

alter table Animateur add
	constraint fk_ani_ani foreign key(no_resp) references animateur(no_anim) on delete set null;

--
-- création de la table atelier
--
create table Atelier (
	no_atel number(4) , 
	intitule varchar2(35), 
	genre varchar2(9), 
	illustration blob invisible,
	vente_heure number(4), 
	no_anim number(4), 
	constraint ck_ate_genre check(genre in ('CULTURE','SCIENCES','SPORT','TNIC')), 
	constraint fk_ate_ani foreign key(no_anim) references animateur(no_anim) on delete set null, 
	constraint pk_ate primary key(no_atel));

--
-- création de la table activite
--
create table Activite (
	no_atel number(4) not null ,
	jour char(2) not null , 
	duree number(2), 
	constraint fk_act_ate foreign key(no_atel) references atelier(no_atel) on delete cascade, 
	constraint pk_act primary key(no_atel, jour));

--
-- création de la table inscription
--
create table Inscription (
	no_insc number(4) generated as identity, 
	no_adher number(4) not null, 
	no_atel number(4) not null, 
	jour char(2) not null, 
	date_inscription date, 
	note number(2), 
	date_sortie date,
	constraint ck_insc_date check (date_sortie>=date_inscription),
	constraint fk_ins_ate foreign key(no_atel) references atelier(no_atel) on delete cascade, 
	constraint fk_ins_act foreign key(no_atel, jour) references activite(no_atel, jour) on delete cascade, 
	constraint fk_ins_adh foreign key(no_adher) references adherent(no_adher) on delete cascade, 
	constraint pk_ins primary key(no_insc));

--
-- insertion des données
--
-- insertion des données dans la table Adherent
insert into adherent values (20,'DE PIE','Denis','46, RUE DES HÉRONS CENDRÉS','44800','SAINT HERBLAIN','24/03/1956','M');
insert into adherent values (21,'ALLICARTE','Michèle','25 RUE DES MARRONNIERS','44000','NANTES','01/02/1965','F');
insert into adherent values (22,'ALMARANTE','Irène','22 RUE DES FRÊNES','35000','RENNES','12/10/1965','F');
insert into adherent values (23,'ALBIN','Marcel','10 RUE DU VÉLODROME','44100','NANTES','10/01/1958','M');
insert into adherent values (24,'AMITT','Gérald','25 RUE DE LA POSTE','44000','NANTES','10/12/1984','M');
insert into adherent values (25,'APPERT','Nicolas','25 RUE DE L''ÉLECTRICITÉ','35000','RENNES','25/12/1981','M');
insert into adherent values (26,'APPLIQUE','Isabelle','65 AVENUE DE LA CONCORDANCE','35000','RENNES','10/12/1984','F');
insert into adherent values (27,'AROBASQUE','Marcel','10 RUE DE L''ESPERLUETTE','44000','NANTES','10/11/1965','M');
insert into adherent values (28,'ATOS','Murielle','1 AVENUE ST ANDRÉ','44100','NANTES','12/10/1969','F');
insert into adherent values (29,'PARKER','Emilie','10 RUE DU CRIME','44000','NANTES','10/02/1965','F');
insert into adherent values (30,'CHALENDON','Albin','10 RUE DU MARGINAL','35000','RENNES','10/05/1946','M');
insert into adherent values (31,'MICHEL','Andre','10 RUE FABLE','44000','NANTES','10/02/1965','M');
insert into adherent values (32,'LAVILLE','Adrienne','25 AVENUE LONGE','44000','NANTES','10/02/1985','F');
insert into adherent values (33,'PEREZ','Amapola','10 RUE DE LA POSTE','44100','NANTES','02/05/1948','F');
insert into adherent values (34,'BONNEAU','Jean','31, RUE DES COLOMBES','79000','NIORT','11/04/1969','M');
insert into adherent values (35,'BOSAPIN','Edmond','21, AVENUE DES PEUPLIERS','49000','ANGERS','14/02/1945','M');
insert into adherent values (36,'COMILFO','Juste','39, RUE DES BOULANGERS','44000','NANTES','17/01/1968','M');
insert into adherent values (37,'DABITUDE','Côme','1, RUE CLAUDE FRANÇOIS','44700','ORVAULT','14/09/1967','M');
insert into adherent values (38,'DASSAULT','Richard','12, RUE DE LA GRANDE ARMÉE','49000','ANGERS','13/07/1963','M');
insert into adherent values (39,'DE CAJOU','Benoît','96, RUE DES OLIVIERS','44400','REZE','12/05/1966','M');
insert into adherent values (40,'DE RADIS','Stéphane','72, RUE DES MARAÎCHERS','44980','SAINTE LUCE SUR LOIRE','29/07/1947','M');
insert into adherent values (41,'DE VOUVOIR','Honoré','5, RUE DE LAMITIÉ','44300','NANTES','01/05/1962','M');
insert into adherent values (42,'DINARAVELO','Ferdinand','25, RUE POULIDOR','44700','ORVAULT','14/05/1968','M');
insert into adherent values (43,'GONZOLA','Igor','5, PLACE DES FROMAGERS','49000','ANGERS','13/06/1957','M');
insert into adherent values (47,'HOCHET','Eric','11, RUE DU LAC','49240','AVRILLE','04/09/86','M');
insert into adherent values (50,'MONFILS','Thibault','15, AVENUE DALGÉRIE','49240','AVRILLE','14/10/1967','M');
insert into adherent values (52,'OPOSTE','Fidèle','12, AVENUE DE LA CASERNE','49000','ANGERS','03/04/1969','M');
insert into adherent values (58,'SWITAUME','Guillaume','8, AVENUE DANGLETERRE','44000','NANTES','04/12/1968','M');
insert into adherent values (59,'TACHAMBRE','Béranger','10, AVENUE DU CHÂTEAU','49000','ANGERS','03/07/1967','M');
insert into adherent values (61,'TERRIEUR','Alex','27, IMPASSE DU PONT','49000','ANGERS','21/04/1968','M');
insert into adherent values (62,'TINIQUE','Aymar','45, RUE DES ANTILLES','44980','SAINTE LUCE SUR LOIRE','29/07/1962','M');
insert into adherent values (63,'TINE','Clément','33, RUE DES JARDINS','49240','AVRILLE','24/09/1964','M');
insert into adherent values (64,'TINE','Constant','25, AVENUE LOUIS XVI','49300','CHOLET','30/10/1967','M');
insert into adherent values (65,'TOURNE','Sylvan','12, RUE DES ALIZÉES','44300','NANTES','08/05/1963','M');
insert into adherent values (66,'TOULETEMPS','Isidore','72, ROUTE DE LA PLAGE','44340','BOUGUENAIS','29/06/1961','M');
insert into adherent values (67,'ABONDIEU','Elisabeth','5, PLACE DE LA CATHÉDRALE','44000','NANTES','01/01/1956','F');
insert into adherent values (68,'AIMONE','Anne','3, PLACE DE LA RÉPUBLIQUE','49000','ANGERS','12/02/1932','F');
insert into adherent values (69,'MALALANICHE','Mélanie','14, RUE DU CHENIL','44700','ORVAULT','15/06/1964','F');
insert into adherent values (70,'DE JEU','Odette','45, RUE DU CASINO','44000','NANTES','25/04/1963','F');
insert into adherent values (71,'ENERBE','Eugénie','15, AVENUE DES FACULTÉS','44000','NANTES','10/09/1949','F');
insert into adherent values (1,'MARTIN','Henri','10 RUE DU VELODROME','35000','RENNES','12/10/1959','M');
insert into adherent values (2,'MICHELET','Isabelle','52 RUE DES ORMES','35000','RENNES','05/02/1970','F');
insert into adherent values (3,'ALENVERS','Michel','23 RUE DES PEUPLIERS','44000','NANTES','25/03/1962','M');
insert into adherent values (4,'ROUGER','Rémy','52 RUE LONGUE','44000','NANTES','08/08/1959','M');
insert into adherent values (5,'GERMAIN','Bruno','45 RUE DES FLEURS','35000','RENNES','25/06/1965','M');
insert into adherent values (6,'MICHELIN','André','2 PLACE DES BANCS','44000','NANTES','25/12/1965','M');
insert into adherent values (7,'LAJOINIE','Martine','5 RUE DES ARBRES EN FLEURS','44000','NANTES','10/09/1970','F');
insert into adherent values (8,'LEMERCIER','Valentine','5 RUE DES FEUILLES MORTES','35000','RENNES','10/11/1975','F');
insert into adherent values (9,'PRIN','Renée','6 RUE DES MANGUES','44000','NANTES','05/05/1962','F');
insert into adherent values (10,'VIALLE','Gisèle','65 RUE DES TILLEULS','44000','NANTES','07/08/1969','F');
insert into adherent values (11,'BONNIN','André','10 RUE DU MUGUET','44000','NANTES','24/03/1965','M');
insert into adherent values (12,'BIROT','Marcelle','10 RUE DU REGIMENT','35000','RENNES','12/01/1976','F');
commit;
-- insertion des données dans la table Animateur
alter table animateur disable constraint FK_ANI_ANI;
insert into animateur values                                                    
(1,'BEGUIN','Armel','02.40.25.25.25',4,'Cadre',60);                           
insert into animateur values                                                    
(2,'POIRIER','Jean','02.99.65.65.65',5,'Agent',49);                           
insert into animateur values                                                    
(3,'FOLIOT','Yolande','02.99.45.45.45',4,'Cadre',62);                         
insert into animateur values                                                    
(4,'ADAMI','Sylvie','02.40.85.85.85',null,'Directeur',75);                        
insert into animateur values                                                    
(5,'PARDON','EMILE','02.99.85.36.63',4,'Cadre',65);                           
insert into animateur values                                                    
(6,'LEBORGNE','ALAIN','02.99.52.25.52',7,'Agent',48);                         
insert into animateur values                                                    
(7,'LAVILLE','Marie','02.40.25.25.36',4,'Cadre',64);                          
insert into animateur values                                                    
(8,'LEDLUZ','Michel','02.40.69.96.36',5,'Agent',49);                          
insert into animateur values                                                    
(9,'MERCIER','Alain','02.99.65.65.45',1,'Agent',47);                          
insert into animateur values                                                    
(10,'PLUCHON','Lionel','02.40.25.85.15',7,'Agent',48);                        
insert into animateur values                                                    
(11,'BILLARD','Martin','02.40.58.58.25',3,'Agent',47);                        
insert into animateur values                                                    
(12,'COCHIN','Sylvain','02.99.63.63.52',1,'Agent',45);                        
insert into animateur values                                                    
(13,'MAGNIN','Martine','02.40.25.36.36',5,'Agent',46);                        
insert into animateur values                                                    
(14,'BILLON','Adrien','02.40.52.15.45',7,'Agent',45);                         
insert into animateur values                                                    
(15,'SAULNIER','Luc','02.40.74.47.14',5,'Agent',47);                          
insert into animateur values                                                    
(16,'BUCHER','Mélanie','02.51.58.56.65',7,'Agent',45);                        
insert into animateur values                                                    
(17,'VIVIER','Lucien','02.99.65.65.65',7,'Agent',46);                         
insert into animateur values                                                    
(18,'MICHELET','Jacques','02.51.25.36.36',5,'Agent',48);                      
commit;
alter table animateur enable constraint FK_ANI_ANI;
-- insertion des données dans la table Atelier
insert into atelier values (1,'ASTRONOMIE','SCIENCES', 60, 12);         
insert into atelier values (2,'BADMINTON','SPORT', 35, 8);              
insert into atelier values (3,'BUREAUTIQUE','TNIC', 80, 11);            
insert into atelier values (4,'DANSEJAZZ','CULTURE', 65, 14);           
insert into atelier values (5,'DENTELLE','CULTURE', 30, 16);            
insert into atelier values (6,'DESSIN','CULTURE', 35, 7);               
insert into atelier values (7,'ECHECS','SPORT', 25, 13);                
insert into atelier values (8,'ECOLOGIE','SCIENCES', 50, 1);            
insert into atelier values (9,'ESCRIME MEDIEVAL','SPORT', 80, 18);      
insert into atelier values (10,'GYMNASTIQUE','SPORT', 60, 5);           
insert into atelier values (11,'INTERNET','TNIC', 80, 6);               
insert into atelier values (12,'JUDO','SPORT', 70, 2);                  
insert into atelier values (13,'PEINTURE','CULTURE', 35, 10);           
insert into atelier values (14,'PLANEUR','SCIENCES', 120, 9);            
insert into atelier values (15,'POTERIE','CULTURE', 40, 17);            
insert into atelier values (16,'PROGRAMMATION','TNIC', 80, 11);         
commit;
-- insertion des données dans Activite
insert into activite values (1,'MA',2);
insert into activite values (1,'SA',2);
insert into activite values (1,'VE',2);
insert into activite values (2,'LU',1);
insert into activite values (2,'ME',2);
insert into activite values (2,'SA',2);
insert into activite values (3,'LU',2);
insert into activite values (3,'ME',1);
insert into activite values (3,'VE',2);
insert into activite values (4,'LU',2);
insert into activite values (4,'ME',1);
insert into activite values (4,'VE',2);
insert into activite values (5,'LU',2);
insert into activite values (5,'ME',1);
insert into activite values (5,'VE',2);
insert into activite values (6,'MA',2);
insert into activite values (6,'JE',2);
insert into activite values (7,'MA',2);
insert into activite values (7,'JE',2);
insert into activite values (8,'MA',2);
insert into activite values (8,'JE',2);
insert into activite values (8,'SA',1);
insert into activite values (9,'MA',2);
insert into activite values (9,'JE',2);
insert into activite values (9,'SA',1);
insert into activite values (10,'MA',2);
insert into activite values (10,'ME',2);
insert into activite values (10,'VE',2);
insert into activite values (11,'MA',2);
insert into activite values (11,'SA',1);
insert into activite values (12,'MA',2);
insert into activite values (12,'SA',1);
insert into activite values (13,'MA',2);
insert into activite values (13,'SA',1);
insert into activite values (14,'LU',1);
insert into activite values (14,'DI',2);
insert into activite values (14,'SA',2);
insert into activite values (15,'LU',1);
insert into activite values (15,'DI',2);
insert into activite values (15,'VE',3);
insert into activite values (15,'SA',2);
insert into activite values (16,'LU',1);
insert into activite values (16,'DI',2);
insert into activite values (16,'VE',3);
insert into activite values (16,'SA',2);
commit;
-- insertion des données dans la table Inscription
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (22,16,'VE','01/02/2000',9,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (66,16,'SA','01/02/2000',10,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (62,16,'VE','01/02/2000',6,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (68,16,'VE','01/02/2000',13,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (65,16,'VE','01/02/2000',18,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (67,15,'SA','01/02/2000',16,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (67,13,'MA','01/02/2000',8,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (71,15,'LU','01/02/2000',17,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (23,16,'SA','01/02/2000',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (43,16,'DI','01/02/2000',14,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (61,15,'VE','01/02/2000',15,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (62,2,'LU','01/02/2000',10,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (64,2,'ME','01/02/2000',11,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (68,2,'SA','01/02/2000',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (21,1,'SA','01/02/2000',10,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (24,1,'VE','01/02/2000',11,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (42,2,'LU','01/02/2000',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (63,2,'ME','01/02/2000',13,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (66,2,'SA','01/02/2000',14,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (69,3,'LU','01/02/2000',15,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (25,1,'MA','01/02/2000',7,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (65,1,'VE','01/02/2000',9,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (70,2,'LU','01/02/2000',10,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (22,1,'SA','01/02/2000',8,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (41,16,'LU','01/02/2000',13,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (26,4,'ME','12/01/2000',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (26,10,'ME','12/01/2000',13,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (28,10,'ME','12/01/2000',13,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (28,14,'DI','12/01/2000',13,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (31,7,'MA','15/01/2000',8,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (31,9,'JE','15/01/2000',10,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (34,6,'MA','10/02/2000',10,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (40,9,'JE','09/02/2000',8,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (34,15,'DI','12/03/2000',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (47,5,'ME','10/12/1999',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (47,13,'MA','01/02/2000',7,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (50,11,'SA','12/12/1999',18,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (50,12,'SA','12/02/2000',15,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (50,13,'SA','12/03/2000',16,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (52,3,'VE','01/02/2000',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (52,4,'VE','12/11/1999',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (52,9,'SA','03/02/2000',15,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (59,12,'MA','10/10/1999',13,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (58,10,'MA','12/03/2000',16,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (1,3,'ME','10/12/1999',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (1,5,'VE','15/10/1999',15,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (1,11,'SA','15/01/1999',8,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (2,6,'JE','10/10/1999',11,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (2,13,'SA','25/10/1999',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (3,4,'LU','15/10/1999',18,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (4,8,'JE','10/10/1999',5,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (4,13,'SA','15/10/1999',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (6,5,'ME','01/02/2000',15,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (6,8,'SA','01/02/2000',14,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (6,14,'DI','01/02/2000',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (7,8,'MA','15/09/1999',16,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (7,14,'SA','06/10/1999',10,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (8,6,'MA','10/10/1999',13,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (8,10,'ME','10/10/1999',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (8,13,'SA','10/10/1999',9,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (9,3,'VE','15/12/1999',17,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (10,3,'ME','04/10/1999',12,null);
insert into inscription (no_adher,no_atel,jour,date_inscription,note,date_sortie) values (10,5,'VE','06/11/1999',15,null);
commit;

alter table Adherent add (
  age number(3) as (floor(months_between(to_date('2016-01-01','YYYY-MM-DD'), date_naissance)/12))
);

commit;
