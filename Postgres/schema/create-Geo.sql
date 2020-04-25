set search_path to Geo, public;

create table Country_ISO
(
    Iso_2 char(2) not null primary key,
    Iso_3 char(3) not null unique,
    Iso_Num smallint not null unique,
    Name varchar(48) not null,
    Name_Prefix varchar(26),
    Name_Suffix varchar(26),
    Name_Alias varchar(26),
    Global_Region_Code smallint not null,
    Global_SubRegion_Code smallint
);

create index Country_ISO_Name_i on Country_ISO (Name);
create index Country_ISO_Name_Prefix_i on Country_ISO (Name_Prefix);
create index Country_ISO_Name_Suffix_i on Country_ISO (Name_Suffix);
create index Country_ISO_Name_Alias_i on Country_ISO (Name_Alias);


create view Country_ISO_FN as
select Iso_2, Iso_3, Iso_Num,
       Name, Name_Prefix, Name_Suffix,
       (case when Name_Prefix is not null then Name_Prefix||' ' else '' end) || Name || (case when Name_Suffix is not null then ' ('||Name_Suffix||')' else '' end) as Name_Full,
       Name_Alias,
       Global_Region_Code, Global_SubRegion_Code
from Country_ISO
with check option;
