-- Drop Geo schema

drop view Geo.Country_ISO_F;
drop view Geo.Country_ISO_FN;

drop materialized view Geo.Country_ISO_Population_Last;
drop materialized view Geo.Country_ISO_Area_Last;

drop table Geo.Country_ISO_Population;
drop table Geo.Country_ISO_Area;
drop table Geo.Country_ISO;

