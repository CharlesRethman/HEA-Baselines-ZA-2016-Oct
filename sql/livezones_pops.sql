SELECT
	'''' || pr_name || '''' AS pr_name,
	pr_code,
	'''' || dc_name || '''' AS dc_name,
	dc_code,
	'''' || mn_name || '''' AS mn_name,
	mn_code,
	'''' || mp_name || '''' AS mp_name,
	mp_code,
	'''' || sp_name || '''' AS sp_name,
	sp_code, 
	zaf.demog_sas.sa_code AS sa_code,
	total_m + total_f AS pop,
	zaf.demog_sas.lz_code AS lz_code,
	'''' || lz_name || '''' AS lz_name,
	'''' || lz_abbrev || '''' AS lz_abbrev,
	'''' || zaf.demog_sas.lz_code || ': ' || lz_name || ' (' || lz_abbrev || ')''' AS lz
FROM
	zaf.demog_sas,
	zaf.tbl_pop_agegender_05y,
	zaf.tbl_livezones_list
WHERE
	zaf.demog_sas.sa_code = zaf.tbl_pop_agegender_05y.sa_code AND
	zaf.demog_sas.lz_code = zaf.tbl_livezones_list.lz_code
ORDER BY
	pr_name, dc_name, mn_name, mp_name, sp_name, zaf.demog_sas.sa_code
;
