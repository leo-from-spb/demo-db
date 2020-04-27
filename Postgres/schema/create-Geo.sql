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


create table Country_ISO_Area
(
    Iso_Num smallint not null,
    Year smallint not null,
    Area numeric(11) not null,
    primary key (Iso_Num, Year),
    foreign key (Iso_Num) references Country_ISO(Iso_Num)
);


create materialized view Country_ISO_Area_Last as
select distinct Iso_Num,
                first_value(Year) over C as Area_Year,
                first_value(Area) over C as Area
from Country_ISO_Area
window C as (partition by Iso_Num order by Year desc);

refresh materialized view Country_ISO_Area_Last;

create unique index Country_ISO_Area_Last_Iso_ui on Country_ISO_Area_Last (Iso_Num);


create table Country_ISO_Population
(
    Iso_Num smallint not null,
    Year smallint not null,
    Population bigint not null,
    primary key (Iso_Num, Year),
    foreign key (Iso_Num) references Country_ISO(Iso_Num)
);


create materialized view Country_ISO_Population_Last as
select distinct Iso_Num,
                first_value(Year) over C as Population_Year,
                first_value(Population) over C as Population
from Country_ISO_Population
window C as (partition by Iso_Num order by Year desc);

refresh materialized view Country_ISO_Population_Last;

create unique index Country_ISO_Population_Last_Iso_ui on Country_ISO_Population_Last (Iso_Num);


create view Country_ISO_F as
select C.*,
       A.Area, A.Area_Year,
       P.Population, P.Population_Year,
       round(case when A.Area > 0 and P.Population > 0
                  then P.Population * 1.0 / A.Area
                  end::numeric, 3) as Population_Density
from Country_ISO_FN C
    left join Country_ISO_Area_Last A using (Iso_Num)
    left join Country_ISO_Population_Last P using (Iso_Num);


        