INSERT INTO zaf.tbl_sampled_villages (
	village_name,
	village_code,
--	main_place_name,
--	main_place_code,
--	municipality_name,
--	municipality_code,
--	municipality_mdb_c,
--	district_name,
--	district_code,
--	district_mdb_c,
--	province_name,
--	province_code,
--	province_mdb_c,
	lz_code, 
	survey,
	sampled_date
	)
	SELECT DISTINCT
		sp_name,
		sp_code,
--		mp_name,
--		mp_code,
--		mn_name,
--		mn_code,
--		mn_mdb_c,
--		dc_name,
--		dc_code,
--		dc_mdb_c,
--		pr_name,
--		pr_code,
--		pr_mdb_c,
		lz_code,
		'hea' AS survey,
		date '2016-10-04' AS sampled_date
	FROM
		zaf.demog_sas 
	WHERE 
			lz_code = 59104
		AND 
			(sp_code = 860008001 OR sp_code = 860009002 OR sp_code = 860012001 OR sp_code = 860021001 OR sp_code = 860022001 OR sp_code = 860026001 OR sp_code = 860031001 OR sp_code = 860035001 OR sp_code = 860038001 OR sp_code = 860039001 OR sp_code = 860041001 OR sp_code = 860050001 ) 
;
