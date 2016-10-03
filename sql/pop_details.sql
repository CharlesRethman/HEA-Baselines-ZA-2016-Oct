DROP FUNCTION IF EXISTS zaf.list_ages();

CREATE OR REPLACE FUNCTION zaf.list_ages() RETURNS TABLE(tab JSON) AS $aa$
DECLARE
   query_str TEXT := '';
   result TEXT := '';
   r RECORD;
BEGIN
   FOR r IN
      (SELECT DISTINCT age FROM zaf.tbl_pop_proj ORDER BY 1)
   LOOP
      query_str := query_str || '"'  || r.age || '"' || ' integer, ';
   END LOOP;
--   RAISE NOTICE 'Query here is %', query_str;
   result := 'SELECT array_to_json(t) FROM ('
      || 'SELECT * FROM crosstab('
      || '''SELECT year_mid, dc_mdb_code, sex, age, pop FROM zaf.tbl_pop_proj ORDER BY 1,2,3'','
      || '''SELECT DISTINCT age FROM zaf.tbl_pop_proj ORDER BY 1'') '
      || 'AS (year integer, code varchar(6), gender varchar(6), ' || left(query_str, -2) || ')) AS t;';
   RETURN QUERY EXECUTE result;
END;
$aa$ LANGUAGE plpgsql;
/*
CREATE OR REPLACE FUNCTION f_mycross(text, text)
   RETURNS TABLE (
      year integer,
      dc_mdb_code varchar(6),
      sex varchar(6),
      age varchar(6)
   )
   AS '$libdir/tablefunc','crosstab_hash' LANGUAGE C STABLE STRICT;
*/

/*create table zaf.tbl_pop_agegender_proj (
   tid serial primary key,
   dc_code varchar(),
   year_mid integer,
   m_00_04 integer,
   f_00_04 integer,
   m_05_09 integer,
   f_05_09 integer,
   m_10_14 integer,
   f_10_14 integer,
   m_15_19 integer,
   f_15_19 integer,
   m_20_24 integer,
   f_20_24 integer,
   m_25_29 integer,
   f_25_29 integer,
   m_30_34 integer,
   f_30_34 integer,
   m_35_39 integer,
   f_35_39 integer,
   m_40_44 integer,
   f_40_44 integer,
   m_45_49 integer,
   f_45_49 integer,
   m_50_54 integer,
   f_50_54 integer,
   m_55_59 integer,
   f_55_59 integer,
   m_60_64 integer,
   f_60_64 integer,
   m_65_69 integer,
   f_65_69 integer,
   m_70_74 integer,
   f_70_74 integer,
   m_75_79 integer,
   f_75_79 integer,
   m_80_84 integer,
   f_80_84 integer,
   m_85plus integer,
   f_85plus integer,
   total_m integer,
   total_f integer
   )
;

inset into zaf.tbl_pop_agegender_proj (
   dc_code integer,
   year_mid,
   m_00_04 integer,
   f_00_04 integer,
   m_05_09 integer,
   f_05_09 integer,
   m_10_14 integer,
   f_10_14 integer,
   m_15_19 integer,
   f_15_19 integer,
   m_20_24 integer,
   f_20_24 integer,
   m_25_29 integer,
   f_25_29 integer,
   m_30_34 integer,
   f_30_34 integer,
   m_35_39 integer,
   f_35_39 integer,
   m_40_44 integer,
   f_40_44 integer,
   m_45_49 integer,
   f_45_49 integer,
   m_50_54 integer,
   f_50_54 integer,
   m_55_59 integer,
   f_55_59 integer,
   m_60_64 integer,
   f_60_64 integer,
   m_65_69 integer,
   f_65_69 integer,
   m_70_74 integer,
   f_70_74 integer,
   m_75_79 integer,
   f_75_79 integer,
   m_80_84 integer,
   f_80_84 integer,
   m_85plus integer,
   f_85plus integer,
   total_m integer,
   total_f integer
   )

SELECT
   *
FROM
   crosstab(
      'SELECT year_mid, dc_mdb_code, sex, age, pop FROM zaf.tbl_pop_proj ORDER BY 1,2,3',
      'select DISTINCT age FROM zaf.tbl_pop_proj ORDER BY 1'
      )
AS (year integer, code varchar(6), gender varchar(6), );
*/

SELECT zaf.list_ages();
/*
SELECT * FROM f_mycross(
   'SELECT year_mid, dc_mdb_code, sex, age, pop FROM zaf.tbl_pop_proj ORDER BY 1,2,3',
   'SELECT DISTINCT age FROM zaf.tbl_pop_proj ORDER BY 1');
*/
