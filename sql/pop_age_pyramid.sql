DROP VIEW IF EXISTS zaf.vw_pop_age_pyramid;
CREATE VIEW zaf.vw_pop_age_pyramid AS
   SELECT
      m.lz_code,
      u5_m::numeric / total_pop::numeric AS "pc_u5_m",
      u5_f::numeric / total_pop::numeric AS "pc_u5_f",
      "5-9_m"::numeric / total_pop::numeric AS "pc_5-9_m",
      "5-9_f"::numeric / total_pop::numeric AS "pc_5-9_f",
      "10-14_m"::numeric / total_pop::numeric AS "pc_10-14_m",
      "10-14_f"::numeric / total_pop::numeric AS "pc_10-14_f",
      "15-19_m"::numeric / total_pop::numeric AS "pc_15-19_m",
      "15-19_f"::numeric / total_pop::numeric AS "pc_15-19_f",
      "20-24_m"::numeric / total_pop::numeric AS "pc_20-24_m",
      "20-24_f"::numeric / total_pop::numeric AS "pc_20-24_f",
      "25-29_m"::numeric / total_pop::numeric AS "pc_25-29_m",
      "25-29_f"::numeric / total_pop::numeric AS "pc_25-29_f",
      "30-34_m"::numeric / total_pop::numeric AS "pc_30-34_m",
      "30-34_f"::numeric / total_pop::numeric AS "pc_30-34_f",
      adult_m::numeric / total_pop::numeric AS pc_adult_m,
      adult_f::numeric / total_pop::numeric AS pc_adult_f,
      "60-64_f"::numeric / total_pop::numeric AS "pc_60-64_f",
      "65-69_m"::numeric / total_pop::numeric AS "pc_65-69_m",
      "65-69_f"::numeric / total_pop::numeric AS "pc_65-69_f",
      "70-74_m"::numeric / total_pop::numeric AS "pc_70-74_m",
      "70-74_f"::numeric / total_pop::numeric AS "pc_70-74_f",
      "75-79_m"::numeric / total_pop::numeric AS "pc_75-79_m",
      "75-79_f"::numeric / total_pop::numeric AS "pc_75-79_f",
      elder::numeric / total_pop::numeric AS pc_elder,
      u5_m,
      u5_f,
      "5-9_m",
      "5-9_f",
      "10-14_m",
      "10-14_f",
      "15-19_m",
      "15-19_f",
      "20-24_m",
      "20-24_f",
      "25-29_m",
      "25-29_f",
      "30-34_m",
      "30-34_f",
      adult_m,
      adult_f,
      "60-64_f",
      "65-69_m",
      "65-69_f",
      "70-74_m",
      "70-74_f",
      "75-79_m",
      "75-79_f",
      elder,
      total_pop
   FROM
      (
         SELECT
            h.lz_code,
            sum(m_00_04) AS u5_m,
            sum(f_00_04) AS u5_f,
            sum(m_05_09) AS "5-9_m",
            sum(f_05_09) AS "5-9_f",
            sum(m_10_14) AS "10-14_m",
            sum(f_10_14) AS "10-14_f",
            sum(m_15_19) AS "15-19_m",
            sum(f_15_19) AS "15-19_f",
            sum(m_20_24) AS "20-24_m",
            sum(m_25_29) AS "25-29_m",
            sum(m_30_34) AS "30-34_m",
            sum(
               m_35_39 +
               m_40_44 +
               m_45_49 +
               m_50_54 +
               m_55_59 +
               m_60_64
            ) AS adult_m,
            sum(f_20_24) AS "20-24_f",
            sum(f_25_29) AS "25-29_f",
            sum(f_30_34) AS "30-34_f",
            sum(
               f_35_39 +
               f_40_44 +
               f_45_49 +
               f_50_54 +
               f_55_59
            ) AS adult_f,
            sum(f_60_64) AS "60-64_f",
            sum(m_65_69) AS "65-69_m",
            sum(f_65_69) AS "65-69_f",
            sum(m_70_74) AS "70-74_m",
            sum(f_70_74) AS "70-74_f",
            sum(m_75_79) AS "75-79_m",
            sum(f_75_79) AS "75-79_f",
            sum(
               m_80_84 +
               f_80_84 +
               m_85plus +
               f_85plus
            ) AS elder
         FROM
            zaf.tbl_pop_agegender_05y AS f,
            zaf.demog_sas AS g,
            zaf.tbl_livezones_list AS h
         WHERE
               f.sa_code = g.sa_code
            AND
               g.lz_code = h.lz_code
            AND
               (
                  h.lz_code = 59101 OR
                  h.lz_code = 59104 OR
                  h.lz_code = 59201 OR
                  h.lz_code = 59205 OR
                  h.lz_code = 59303
               )
         GROUP BY
            h.lz_code
      ) AS m,
      (
         SELECT
            lz_code,
            sum(
               m_00_04 + f_00_04 +
               m_05_09 + f_05_09 +
               m_10_14 + f_10_14 +
               m_15_19 + f_15_19 +
               m_20_24 + f_20_24 +
               m_25_29 + f_25_29 +
               m_30_34 + f_30_34 +
               m_35_39 + f_35_39 +
               m_40_44 + f_40_44 +
               m_45_49 + f_45_49 +
               m_50_54 + f_50_54 +
               m_55_59 + f_55_59 +
               m_60_64 + f_60_64 +
               m_65_69 + f_65_69 +
               m_70_74 + f_70_74 +
               m_75_79 + f_75_79 +
               m_80_84 + f_80_84 +
               m_85plus + f_85plus
            ) AS total_pop
         FROM
            zaf.demog_sas AS i,
            zaf.tbl_pop_agegender_05y AS j
         WHERE
            i.sa_code = j.sa_code
            AND
               (
                  lz_code = 59101
                  OR lz_code = 59104
                  OR lz_code = 59201
                  OR lz_code = 59205
                  OR lz_code = 59303
               )
         GROUP BY
            lz_code
      ) AS n
   WHERE
         m.lz_code = n.lz_code
;

SELECT
   lz_code AS lz,
   'male' AS gender,
   round("pc_u5_m", 6) AS "u5",
   round("pc_10-14_m", 6) AS "10-14",
   round("pc_15-19_m", 6) AS "15-19",
   round("pc_20-24_m", 6) AS "20-24",
   round("pc_25-29_m", 6) AS "25-29",
   round("pc_30-34_m", 6) AS "30-34",
   (round(pc_adult_m * 100, 2))::text || ' (' || (round(pc_adult_m, 5))::text || ')' AS adult,
   round("pc_65-69_m", 6) AS "65-69",
   round("pc_70-74_m", 6) AS "70-74",
   round("pc_75-79_m", 6) AS "75-79"
--   (round(pc_elder * 100, 2))::text || ' (' || (round(pc_elder, 5))::text || ')' AS elder
FROM
   zaf.vw_pop_age_pyramid

UNION SELECT
   lz_code AS lz,
   'female' AS gender,
   round("pc_u5_f", 6) AS "u5",
   round("pc_10-14_f", 6) AS "10-14",
   round("pc_15-19_f", 6) AS "15-19",
   round("pc_20-24_f", 6) AS "20-24",
   round("pc_25-29_f", 6) AS "25-29",
   round("pc_30-34_f", 6) AS "30-34",
   (round(pc_adult_f * 100, 2))::text || ' (' || (round(pc_adult_f, 5))::text || ')' AS  adult,
   round("pc_65-69_f", 6) AS "65-69",
   round("pc_70-74_f", 6) AS "70-74",
   round("pc_75-79_f", 6) AS "75-79"
FROM
   zaf.vw_pop_age_pyramid

ORDER BY
   lz,
   gender
;
