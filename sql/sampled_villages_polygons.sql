DROP VIEW IF EXISTS zaf.vw_sampled_villages;

CREATE VIEW zaf.vw_sampled_villages AS
	SELECT
		f.gid,
		f.the_geom,
		f.sa_code,
		sp_name AS village_name,
		village_code,
		mp_name AS main_place_name,
		mp_code AS main_place_code,
		mn_name AS municipality_name,
		mn_code AS municipality_code,
		dc_name AS district_name,
		dc_code AS district_code,
		pr_name AS province_name,
		pr_code AS province_code,
		f.lz_code,
		j.pop,
		survey,
		sampled_date
	FROM
		zaf.demog_sas AS f
	INNER JOIN (
		zaf.tbl_sampled_villages AS g
	INNER JOIN (
		SELECT
			i.sp_code,
			SUM(total) AS pop
		FROM
			zaf.tbl_pop_agegender_12y AS h,
			zaf.demog_sas AS i
		WHERE
				i.sa_code = h.sa_code
		GROUP BY
			i.sp_code
	) AS j
	ON
		g.village_code = j.sp_code
	)
	ON
		f.sp_code = village_code AND g.lz_code = f.lz_code
	WHERE g.sampled_date = (
		SELECT
			MAX(sampled_date)
		FROM
			zaf.tbl_sampled_villages
	)
	ORDER BY
		f.lz_code, f.sa_code
;

SELECT
	gid,
	sa_code,
	village_name,
	main_place_name,
	municipality_name,
	district_name,
	province_name
FROM
	zaf.vw_sampled_villages
ORDER BY
	province_name, district_name, municipality_name, main_place_name, village_name
;
