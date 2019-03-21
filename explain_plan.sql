-- explain plan
explain plan for 
  select * from adherent
    where ville = 'NANTES';
    
select plan_table_output from table(dbms_xplan.display());

-- explain plan nomm�
explain plan
  set statement_id = 'adh_nantes'
for 
  select nom, prenom, ville, intitule, genre 
    from adherent
      inner join inscription using (no_adher)
      inner join atelier using (no_atel)
    where ville = 'ANGERS';
    
select plan_table_output 
  from table(dbms_xplan.display(null,'adh_nantes','TYPICAL'));
  
  
-- explain plan nomm�  
explain plan
  set statement_id = 'adh_poirier'
for
select no_adher, adherent.nom, adherent.prenom
  from adherent
    inner join inscription using (no_adher)
    inner join atelier using (no_atel)
    inner join animateur using (no_anim)
  where
    upper(animateur.nom) = 'POIRIER'
  order by nom, prenom;
  
select plan_table_output 
  from table(dbms_xplan.display(null,'adh_poirier','TYPICAL'));

--  --
explain plan
  set statement_id = 'adh_poirier_sr'
for
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
  
select plan_table_output 
  from table(dbms_xplan.display(null,'adh_poirier_sr','TYPICAL'));
