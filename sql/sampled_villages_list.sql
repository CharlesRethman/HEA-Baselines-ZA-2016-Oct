SELECT
   g.lz_code,
   pr_name,
   dc_name,
   mn_name,
   village_name,
   village_code,
   survey
FROM
   zaf.tbl_sampled_villages AS g,
   (
      SELECT
         pr_name,
         dc_name,
         mn_name,
         sp_code,
         count(sa_code)
      FROM
         zaf.demog_sas
      GROUP BY
         pr_name,
         dc_name,
         mn_name,
         sp_code
   ) AS f
WHERE
      f.sp_code = g.village_code
   AND
      sampled_date > '2016-10-01'
ORDER BY
   g.lz_code,
   pr_name,
   dc_name,
   mn_name,
   village_name
;
