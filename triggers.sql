create or replace trigger auto_inc
    before insert
    on atelier for each row
    -- when :new.no_atel is null
begin

    select c_id.nextval into :new.no_atel from dual;

end;
