create or replace procedure InsertPropertyRecord(PROPERTY_ID in number,AV_START_DATE in date,AV_END_DATE in date, PLINTH_AREA in number,NO_FLOORS in number,YEAR_CONSTRUCTION in number,TOTAL_AREA in number,state_loc in varchar2,CITY in varchar2,STREET in varchar2,PIN in number,DOOR_NO in number,OWNER_ID in number,TENANT_ID in number,propertyAvail in number,isResidential in varchar2,bed_rooms in number ) as
begin
insert into property values(PROPERTY_ID,AV_START_DATE,AV_END_DATE,PLINTH_AREA,NO_FLOORS,YEAR_CONSTRUCTION,TOTAL_AREA,state_loc,CITY,STREET,PIN,DOOR_NO,OWNER_ID,TENANT_ID,propertyAvail,isResidential,bed_rooms);
if bed_rooms<>0 then
insert into residential values (PROPERTY_ID,bed_rooms);
else 
insert into commercial values(PROPERTY_ID);
dbms_output.put_line('data is inserted into property');
end if;
end;
/




create or replace procedure GetPropertyRecords( Owner1_ID in number) as 
propertyID number;
startDate date;
endDate date;
plinthArea number;
noFloors number;
yearConstruction number;
totalArea number;
stateLoc varchar(30);
city varchar(30);
street varchar(30);
pin number;
doorNo number;
tenantID number;
propertyAvail number;
is_Residential varchar2(100);
bedrooms number;


cursor property_cursor is
select PROPERTY_ID,AV_START_DATE,AV_END_DATE,PLINTH_AREA,NO_FLOORS,YEAR_CONSTRUCTION,TOTAL_AREA,STATE,CITY,STREET,PIN,DOOR_NO,TENANT_ID,AVAIL,is_Residential1,bed_rooms from property where property.OWNER_ID = Owner1_ID; 
begin
open property_cursor;
loop
fetch property_cursor into propertyID,startDate,endDate,plinthArea,noFloors,yearConstruction,totalArea,stateLoc,city,street,pin,doorNo,tenantID,propertyAvail,is_Residential,bedrooms;
exit when property_cursor%notfound;
dbms_output.put_line('Property details '||' Property ID is '||propertyID||' Property start date is '||startDate||' Property end date is '||endDate||' Property Plinth area is '||plinthArea||' Property no of floors is '||noFloors||' property year of construction is  '||yearConstruction||'property total area is '||totalArea||' property state is  '||stateLoc||' property cit is '||city||' property street is '||street||' property pin is '||pin||' property number of doors is '||doorNo||' property owern id is'||Owner1_ID||'property tenant id is '||tenantID||' propertyAvail is '||propertyAvail||'if its residential or commercial '||is_Residential||'Number of bedrooms '||bedrooms );
end loop;
close property_cursor;
end;
/

create or replace procedure GetTenantDetails(propertyID in number) as
aadharID number;
userName varchar(30);
userAge number;
pin number;
doorNo number;
stateLoc varchar(20);
street varchar(20);
city varchar(20);
begin
-- select AADHAR_ID,USER_NAME,USER_AGE,PIN,DOOR_NO,STATE,CITY,STREET into aadharID,userName,userAge,pin,doorNo,stateLoc,street,city from property,db_user where propertyID = PROPERTY_ID and AADHAR_ID = TENANT_ID
select AADHAR_ID,USER_NAME,USER_AGE,PIN,DOOR_NO,STATE,CITY,STREET into aadharID,userName,userAge,pin,doorNo,stateLoc,city,street from db_user where AADHAR_ID in (select TENANT_ID from property where PROPERTY_ID = propertyID);
dbms_output.put_line(' Tenant ID is '||aadharID||' Tenant username is '||userName||' Tenant age is  '||userAge||' Tenant  Door number is '||doorNo||' Tenant state  is '||stateLoc||' Tenant street is  '||street||' tenant city is '||city );
end;
/

create or replace procedure CreateNewUser(aadharID in number,userName in varchar2,userAge in varchar2,pin in number,doorNo in number,stateLoc in varchar2,street in varchar2,city in varchar2,pass in varchar2,role in number) as
temp varchar(1000);
begin
insert into db_user values(aadharID,userName,userAge,pin,doorNo,stateLoc,street,city);
if role = 1 then
insert into tenant  values(aadharID,userName,pass);
temp := 'create user ' || userName || ' identified by ' || pass;
execute immediate (temp);
temp := 'GRANT ' || 'tenants_role' || ' TO ' || userName;
execute immediate (temp);
temp:='GRANT ALTER SESSION,
                      CREATE ANY TABLE,
                      CREATE CLUSTER,
                      CREATE DATABASE LINK,
                      CREATE MATERIALIZED VIEW,
                      CREATE SYNONYM,
                      CREATE TABLE,
                      CREATE VIEW,
                      CREATE SESSION,
                      UNLIMITED TABLESPACE
                   TO ' || ' tenants_role';
     execute immediate (temp);

elsif role = 2 then
insert into owner values(aadharID,userName,pass);
temp := 'create user ' || userName || ' identified by ' || pass;
execute immediate (temp);
temp := 'GRANT ' || 'owner_role' || ' TO ' || userName;
execute immediate (temp);
temp:='GRANT ALTER SESSION,
                      CREATE ANY TABLE,
                      CREATE CLUSTER,
                      CREATE DATABASE LINK,
                      CREATE MATERIALIZED VIEW,
                      CREATE SYNONYM,
                      CREATE TABLE,
                      CREATE VIEW,
                      CREATE SESSION,
                      UNLIMITED TABLESPACE
                   TO ' || ' owner_role';
    execute immediate (temp);


elsif role = 3 then
insert into manager values(aadharID,userName,pass);


temp := 'create user ' || userName || ' identified by ' || pass;
execute immediate (temp);

-- temp := 'grant  session  to '|| userName;
-- execute immediate (temp);

temp := 'GRANT ' || 'manager_role' || ' TO ' || userName;
execute immediate (temp);

temp:='GRANT ALTER SESSION,
                      CREATE ANY TABLE,
                      CREATE CLUSTER,
                      CREATE DATABASE LINK,
                      CREATE MATERIALIZED VIEW,
                      CREATE SYNONYM,
                      CREATE TABLE,
                      CREATE VIEW,
                      CREATE SESSION,
                      UNLIMITED TABLESPACE
                   TO ' || ' manager_role';

execute immediate (temp);

elsif role = 4 then
insert into dba values(aadharID,userName,pass);



else
dbms_output.put_line('Wrong role');

dbms_output.put_line('data is inserted into db_user table');
end if;
end;
/

-- 5

create or replace procedure SearchProperyForRent( city1 in varchar2) as 
propertyID number;
startDate date;
endDate date;
plinthArea number;
noFloors number;
yearConstruction number;
totalArea number;
stateLoc varchar(30);
street varchar(30);
pin number;
doorNo number;
owner1ID number;
tenant1ID number;
propertyAvail number;
is_Residential varchar2(100);
bedrooms number;

cursor property_cursor is
select PROPERTY_ID,AV_START_DATE,AV_END_DATE,PLINTH_AREA,NO_FLOORS,YEAR_CONSTRUCTION,TOTAL_AREA,STATE,STREET,PIN,DOOR_NO,OWNER_ID,TENANT_ID,AVAIL,is_Residential1,bed_rooms from property where CITY=city1; 
begin
open property_cursor;
loop
fetch property_cursor into propertyID,startDate,endDate,plinthArea,noFloors,yearConstruction,totalArea,stateLoc,street,pin,doorNo,owner1ID,tenant1ID,propertyAvail,is_Residential,bedrooms;
exit when property_cursor%notfound;
if propertyAvail = 1  then
dbms_output.put_line('Property details '||' Property ID is '||propertyID||' Property start date is '||startDate||' Property end date is '||endDate||' Property Plinth area is '||plinthArea||' Property no of floors is '||noFloors||' property year of construction is  '||yearConstruction||' property state is  '||stateLoc||' property cit is '||city1||' property street is '||street||' property pin is '||pin||' property number of doors is '||doorNo||' property owern id is'||owner1ID||'property tenant id is '||tenant1ID||'property avail is '||propertyAvail||'if its residential or commercial '||is_Residential||'Number of bedrooms '||bedrooms );
end if;
end loop;
close property_cursor;
end;
/
-- 6
create or replace procedure GetRentHistory(propertyID in number) as
rentstart date;
rentend date;
percentHike number;
rentPerMonth number;
agencyCommission number;
tenantID number;
cursor rent_cursor is
select RENT_START_DATE,RENT_END_DATE,PERCENT_HIKE,RENT_PER_MONTH,AGENCY_COMMISSION,TENENT_ID  from history where  PROPERTY_ID=propertyID;

begin
open rent_cursor;
loop
fetch rent_cursor into rentstart,rentend,percentHike,rentPerMonth,agencyCommission,tenantID;
exit when rent_cursor%notfound;
dbms_output.put_line('History details '||' Property ID is '||propertyID||' rent start date is '||rentstart||' rent end date is '||rentend||' rent percentage hike  is '||percentHike||' rent per month '||rentPerMonth||' tenanID  '||tenantID );
-- dbms_output.put_line('fadshu');
end loop;
close rent_cursor;
end;
/

create or replace procedure DeleteProperty(id in number) as
n1 number;
n2 number;
begin
select count(*) into n1 from commercial where PROPERTY_ID = id;
select count(*) into n2 from residential where PROPERTY_ID = id;
if n1<>0 then
delete from commercial where PROPERTY_ID  = id;
else
delete from residential where PROPERTY_ID  = id;
end if;
delete from rent_details where PROPERTY_ID = id;
delete from history where PROPERTY_ID = id;
delete from property where PROPERTY_ID = id ;

end;
/


create or replace procedure RentProperty (id in number,startdate in date,endDate in date,percentHike in number,rentPerMonth in number,agencyCommission in number,tenantID in number) as
propertyAvail number;
begin
select AVAIL into propertyAvail from property where PROPERTY_ID = id;
if propertyAvail = 1 then
update property set AVAIL = 0 where PROPERTY_ID = id;
insert into rent_details values(id,startdate,endDate,percentHike,rentPerMonth,agencyCommission);
insert into history values(id,startdate,endDate,percentHike,rentPerMonth,agencyCommission,tenantID);
else
dbms_output.put_line('Property is not avialable ');
end if;
end;
/


--  CREATE OR REPLACE PROCEDURE CreateNewUser(
--   aadharID IN NUMBER,
--   userName IN VARCHAR2,
--   userAge IN VARCHAR2,
--   pin IN NUMBER,
--   doorNo IN NUMBER,
--   stateLoc IN VARCHAR2,
--   street IN VARCHAR2,
--   city IN VARCHAR2,
--   pass IN VARCHAR2,
--   role IN NUMBER
-- )
-- AS
--   temp VARCHAR(1000);
-- BEGIN
--   INSERT INTO db_user VALUES(aadharID, userName, userAge, pin, doorNo, stateLoc, street, city);
  
--   IF role = 1 THEN
--     INSERT INTO tenant VALUES(aadharID, userName, pass);
--     temp := 'GRANT tenant_role TO ' || userName;
--     EXECUTE IMMEDIATE (temp);
--   ELSIF role = 2 THEN
--     INSERT INTO owner VALUES(aadharID, userName, pass);
--     temp := 'GRANT owner_role TO ' || userName;
--     EXECUTE IMMEDIATE (temp);
--   ELSIF role = 3 THEN
--     INSERT INTO manager VALUES(aadharID, userName, pass);
--     temp := 'GRANT manager_role TO ' || userName;
--     EXECUTE IMMEDIATE (temp);
--   ELSIF role = 4 THEN
--     INSERT INTO dba VALUES(aadharID, userName, pass);
--     temp := 'GRANT dba_role TO ' || userName;
--     EXECUTE IMMEDIATE (temp);
--   ELSE
--     DBMS_OUTPUT.PUT_LINE('Wrong role');
--   END IF;
  
--   DBMS_OUTPUT.PUT_LINE('Data is inserted into db_user table');
-- END;
-- /