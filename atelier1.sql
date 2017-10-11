-- Suppression des tables existantes
drop table Inscription;
drop table Activite;
drop table Atelier;
drop table Animateur;

-- Atelier 1.1
drop table Adherent cascade constraints purge;
create table Adherent (
	no_adher number(4) constraint adherent_pk primary key,
	nom varchar2(25) constraint adherent_nom_nn not null,
	prenom varchar2(25),
	rue varchar2(35),
	cp char(5),
	ville varchar2(25),
	date_naissance date,
	sexe char(1) check(sexe in ('F','M'))
);

create table Animateur (
	no_anim number(4) 
		constraint pk_animateur primary key,
	nom varchar2(25) 
		constraint nn_animateur_nom not null,
	prenom varchar2(25),
	tel char(14),
	cout_heure number(4)
);

create table Atelier (
	no_atel number(4) 
        constraint atelier_pk primary key,
	intitule varchar2(35) 
        constraint atelier_intitule_nn not null,
	genre varchar2(9) 
		constraint atelier_genre_ck check(upper(genre) in ('SCIENCES','TNIC','CULTURE','SPORT')),
	illustration blob,
	vente_heure number(4),
	no_anim number(4),
    constraint atelier_no_anim_fk foreign key (no_anim) 
        references Animateur(no_anim) on delete set null 
-- on conserve l'atelier si l'animateur est supprimé, 
-- l'atelier ne référence plus auncun animateur (no_anim is null)
);

create table Activite (
	no_atel     number(4),
	jour        char(2),
	duree       number(2),
	constraint activite_pk primary key (no_atel, jour),
	constraint activite_atelier_fk
		foreign key (no_atel) references Atelier(no_atel) 
		on delete cascade
-- on supprime toutes les activités si l'atelier est supprimé
);

create table Inscription (
	no_insc number(4),
	no_adher number(4),
	no_atel number(4),
	jour char(2),
	date_inscription date 
		constraint inscription_date_inscr_nn not null,
	note number(2),
	constraint inscription_pk primary key (no_insc),
	constraint inscription_no_adher_fk 
		foreign key (no_adher) references Adherent(no_adher) 
            on delete cascade,
	constraint inscription_no_atel_fk 
        foreign key (no_atel) references Atelier(no_atel) 
            on delete cascade,
	constraint inscription_activite_fk 
		foreign key (no_atel,jour) references Activite(no_atel,jour) 
            on delete cascade
);

-- Atelier 1.2
alter table Animateur add (
	no_resp number(4),
	fonction char(10),
	constraint animateur_fonction_ck check (fonction in ('Agent','Cadre','Directeur')),
	constraint animateur_animateur_fk 
		foreign key (no_resp) references Animateur(no_anim)
);

alter table Inscription add (
	date_sortie date,
	constraint inscription_date_ck check (date_sortie > date_inscription)
);

alter table Atelier drop constraint atelier_genre_ck;
alter table Atelier add constraint atelier_genre_ck 
  check(genre in ('SCIENCES','NTIC','CULTURE','SPORT','MUSIQUE'));

alter table Animateur drop constraint animateur_animateur_fk;
alter table Animateur add constraint animateur_animateur_fk 
    foreign key (no_resp) references Animateur(no_anim) on delete set null;







