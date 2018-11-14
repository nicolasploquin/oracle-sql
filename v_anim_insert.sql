create or replace trigger v_anim_insert
  instead of insert
  on v_anim
  for each row
  -- when new.nom is not null
declare
  v_no_atel atelier.no_atel%type;
  v_no_anim atelier.no_anim%type;

begin

  select c_no.nextval into v_no_atel from dual;
  select c_no.nextval into v_no_anim from dual;
  
  insert into animateur (no_anim, nom, prenom, tel)
    values (v_no_anim, :new.nom, :new.prenom, :new.tel);

  insert into atelier (no_atel, intitule, genre, vente_heure, no_anim)
    values (v_no_atel, :new.intitule, :new.genre, :new.vente_heure, v_no_anim);


end;
