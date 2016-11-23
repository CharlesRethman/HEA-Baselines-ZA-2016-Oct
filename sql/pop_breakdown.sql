DROP VIEW IF EXISTS zaf.vw_pop_breakdown;
CREATE VIEW zaf.vw_pop_breakdown AS
   SELECT
      m.lz_code,
      u5::numeric / total_pop::numeric AS "pc_u5",
      "5-19"::numeric / total_pop::numeric AS "pc_5-19",
      adult_m::numeric / total_pop::numeric AS pc_adult_m,
      adult_f::numeric / total_pop::numeric AS pc_adult_f,
      elder::numeric / total_pop::numeric AS pc_elder,
      u5,
      "5-19",
      adult_m,
      adult_f,
      elder,
      total_pop
   FROM
      (
         SELECT
            h.lz_code,
            sum(m_00_04 + f_00_04) AS u5,
            sum(
               m_05_09 +
               f_05_09 +
               m_10_14 +
               f_10_14 +
               m_15_19 +
               f_15_19
            ) AS "5-19",
            sum(
               m_20_24 +
               m_25_29 +
               m_30_34 +
               m_35_39 +
               m_40_44 +
               m_45_49 +
               m_50_54 +
               m_55_59 +
               m_60_64
            ) AS adult_m,
            sum(
               f_20_24 +
               f_25_29 +
               f_30_34 +
               f_35_39 +
               f_40_44 +
               f_45_49 +
               f_50_54 +
               f_55_59
            ) AS adult_f,
            sum(
               f_60_64 +
               m_65_69 +
               f_65_69 +
               m_70_74 +
               f_70_74 +
               m_75_79 +
               f_75_79 +
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
                  lz_code = 59101 OR
                  lz_code = 59104 OR
                  lz_code = 59201 OR
                  lz_code = 59205 OR
                  lz_code = 59303
               )
         GROUP BY
            lz_code
      ) AS n
   WHERE
         m.lz_code = n.lz_code
;

SELECT
   CASE
      WHEN num_hh < 12 THEN lz_code::text
      ELSE '-----'
   END AS lz,
   CASE
      WHEN num_hh < 12 THEN num_hh::text
      ELSE '-------'
   END AS hh_size,
   u5,
   "5-19",
   adult_m,
   adult_f,
   elder
FROM
   (
      SELECT
         lz_code,
         3 AS num_hh,
         (round(pc_u5 * 3, 1))::text || ' (' || (round(pc_u5 * 3, 0))::text || ')' AS "u5",
         (round("pc_5-19" * 3, 1))::text || ' (' || (round("pc_5-19" * 3, 0))::text || ')' AS "5-19",
         (round(pc_adult_m * 3, 1))::text || ' (' || (round(pc_adult_m * 3, 0))::text || ')' AS adult_m,
         (round(pc_adult_f * 3, 1))::text || ' (' || (round(pc_adult_f * 3, 0))::text || ')' AS  adult_f,
         (round(pc_elder * 3, 1))::text || ' (' || (round(pc_elder * 3, 0))::text || ')' AS elder
      FROM
         zaf.vw_pop_breakdown

      UNION SELECT
         lz_code,
         4 AS num_hh,
         (round(pc_u5 * 4, 1))::text || ' (' || (round(pc_u5 * 4, 0))::text || ')' AS "u5",
         (round("pc_5-19" * 4, 1))::text || ' (' || (round("pc_5-19" * 4, 0))::text || ')' AS "5-19",
         (round(pc_adult_m * 4, 1))::text || ' (' || (round(pc_adult_m * 4, 0))::text || ')' AS adult_m,
         (round(pc_adult_f * 4, 1))::text || ' (' || (round(pc_adult_f * 4, 0))::text || ')' AS adult_f,
         (round(pc_elder * 4, 1))::text || ' (' || (round(pc_elder * 4, 0))::text || ')' AS elder
      FROM
         zaf.vw_pop_breakdown

      UNION SELECT
         lz_code,
         5 AS num_hh,
         (round(pc_u5 * 5, 1))::text || ' (' || (round(pc_u5 * 5, 0))::text || ')' AS "u5",
         (round("pc_5-19" * 5, 1))::text || ' (' || (round("pc_5-19" * 5, 0))::text || ')' AS "5-19",
         (round(pc_adult_m * 5, 1))::text || ' (' || (round(pc_adult_m * 5, 0))::text || ')' AS adult_m,
         (round(pc_adult_f * 5, 1))::text || ' (' || (round(pc_adult_f * 5, 0))::text || ')' AS adult_f,
         (round(pc_elder * 5, 1))::text || ' (' || (round(pc_elder * 5, 0))::text || ')' AS elder
      FROM
         zaf.vw_pop_breakdown

      UNION SELECT
         lz_code,
         6 AS num_hh,
         (round(pc_u5 * 6, 1))::text || ' (' || (round(pc_u5 * 6, 0))::text || ')' AS "u5",
         (round("pc_5-19" * 6, 1))::text || ' (' || (round("pc_5-19" * 6, 0))::text || ')' AS "5-19",
         (round(pc_adult_m * 6, 1))::text || ' (' || (round(pc_adult_m * 6, 0))::text || ')' AS adult_m,
         (round(pc_adult_f * 6, 1))::text || ' (' || (round(pc_adult_f * 6, 0))::text || ')' AS adult_f,
         (round(pc_elder * 6, 1))::text || ' (' || (round(pc_elder * 6, 0))::text || ')' AS elder
      FROM
         zaf.vw_pop_breakdown

      UNION SELECT
         lz_code,
         7 AS num_hh,
         (round(pc_u5 * 7, 1))::text || ' (' || (round(pc_u5 * 7, 0))::text || ')' AS "u5",
         (round("pc_5-19" * 7, 1))::text || ' (' || (round("pc_5-19" * 7, 0))::text || ')' AS "5-19",
         (round(pc_adult_m * 7, 1))::text || ' (' || (round(pc_adult_m * 7, 0))::text || ')' AS adult_m,
         (round(pc_adult_f * 7, 1))::text || ' (' || (round(pc_adult_f * 7, 0))::text || ')' AS adult_f,
         (round(pc_elder * 7, 1))::text || ' (' || (round(pc_elder * 7, 0))::text || ')' AS elder
      FROM
         zaf.vw_pop_breakdown

      UNION SELECT
         lz_code,
         8 AS num_hh,
         (round(pc_u5 * 8, 1))::text || ' (' || (round(pc_u5 * 8, 0))::text || ')' AS "u5",
         (round("pc_5-19" * 8, 1))::text || ' (' || (round("pc_5-19" * 8, 0))::text || ')' AS "5-19",
         (round(pc_adult_m * 8, 1))::text || ' (' || (round(pc_adult_m * 8, 0))::text || ')' AS adult_m,
         (round(pc_adult_f * 8, 1))::text || ' (' || (round(pc_adult_f * 8, 0))::text || ')' AS adult_f,
         (round(pc_elder * 8, 1))::text || ' (' || (round(pc_elder * 8, 0))::text || ')' AS elder
      FROM
         zaf.vw_pop_breakdown

      UNION SELECT
         lz_code,
         9 AS num_hh,
         (round(pc_u5 * 9, 1))::text || ' (' || (round(pc_u5 * 9, 0))::text || ')' AS "u5",
         (round("pc_5-19" * 9, 1))::text || ' (' || (round("pc_5-19" * 9, 0))::text || ')' AS "5-19",
         (round(pc_adult_m * 9, 1))::text || ' (' || (round(pc_adult_m * 9, 0))::text || ')' AS adult_m,
         (round(pc_adult_f * 9, 1))::text || ' (' || (round(pc_adult_f * 9, 0))::text || ')' AS adult_f,
         (round(pc_elder * 9, 1))::text || ' (' || (round(pc_elder * 9, 0))::text || ')' AS elder
      FROM
         zaf.vw_pop_breakdown

      UNION SELECT
         lz_code,
         10 AS num_hh,
         (round(pc_u5 * 10, 1))::text || ' (' || (round(pc_u5 * 10, 0))::text || ')' AS "u5",
         (round("pc_5-19" * 10, 1))::text || ' (' || (round("pc_5-19" * 10, 0))::text || ')' AS "5-19",
         (round(pc_adult_m * 10, 1))::text || ' (' || (round(pc_adult_m * 10, 0))::text || ')' AS adult_m,
         (round(pc_adult_f * 10, 1))::text || ' (' || (round(pc_adult_f * 10, 0))::text || ')' AS adult_f,
         (round(pc_elder * 10, 1))::text || ' (' || (round(pc_elder * 10, 0))::text || ')' AS elder
      FROM
         zaf.vw_pop_breakdown

      UNION SELECT
         lz_code,
         11 AS num_hh,
         (round(pc_u5 * 11, 1))::text || ' (' || (round(pc_u5 * 11, 0))::text || ')' AS "u5",
         (round("pc_5-19" * 11, 1))::text || ' (' || (round("pc_5-19" * 11, 0))::text || ')' AS "5-19",
         (round(pc_adult_m * 11, 1))::text || ' (' || (round(pc_adult_m * 11, 0))::text || ')' AS adult_m,
         (round(pc_adult_f * 11, 1))::text || ' (' || (round(pc_adult_f * 11, 0))::text || ')' AS adult_f,
         (round(pc_elder * 11, 1))::text || ' (' || (round(pc_elder * 11, 0))::text || ')' AS elder
      FROM
         zaf.vw_pop_breakdown

      UNION SELECT
         lz_code,
         12 AS num_hh,
         '-------' AS "u5",
         '-------' AS "5-19",
         '-------' AS adult_m,
         '-------' AS adult_f,
         '-------' AS elder
      FROM
         zaf.vw_pop_breakdown

   ) AS f
ORDER BY
   lz_code,
   num_hh
;
