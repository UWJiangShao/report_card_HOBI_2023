OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT;

** data processing;

%let program = P02;

libname temp "..\..\Data\temp_data\STAR_Adult\";

data df_SA_merge;
	set temp.P01_df_SA_merge;
	** AAPOR actually have 4 decimal places; 
	format aapor 8.4;

	disposition = compress(put(aapor*1000, 5.), '. ');

	contacted = .;
	if ('1100' <= disposition <= '1200') 
		or ('2100' <= disposition <= '2199') 
		or ('2300' <= disposition <= '2399') 
		then contacted=1;
	if disposition = '2900'
		or ('2200' <= disposition <= '2299') 
		then contacted=0;

	completed = .;
	if ('1100' <= disposition < '1200') then completed=1;
	if disposition = '2900' 
		or disposition = '1200'
		or ('2100' <= disposition <= '2399') then completed=0;



	* add located, Non-eligible respondent, and refusal rate:;
	located = .; 
		if compress(disposition, ' ') ne ''  then do;
			if ('1100' <= disposition <= '1200') 
				or ('2100' <= disposition <= '2399')
				or ('4700' <= disposition <= '4799')
				or ('5100' <= disposition <= '5200') then located = 1;
			else located = 0;
		end;

	non_eligilbe_resp = .;
		if located = 1 then do;
			if disposition = '4700' then non_eligilbe_resp = 1;
			else non_eligilbe_resp = 0;
		end;

	refused = .;
		if located = 1 then do;
			if '2100' <= disposition <= '2199' then refused = 1;
			else refused = 0;
		end;	



	race4=race;
	if strip(race)='American Indian or Alaskan' then race4='Unknown / Other';
	if strip(race)='Asian, Pacific Islander' then race4='Unknown / Other';

	*calculate case-mix dummies;
	*general health status;
	* if cahps29>0 then health_exc=0;
	* if cahps29>0 then health_vgd=0;
	* if cahps29>0 then health_gd=0;
	* if cahps29>0 then health_fair=0;
	* if cahps29>0 then health_poor=0;

	* if cahps29=1 then health_exc=1;
	* if cahps29=2 then health_vgd=1;
	* if cahps29=3 then health_gd=1;
	* if cahps29=4 then health_fair=1;
	* if cahps29=5 then health_poor=1;

	* *education;
	* if cahps38>0 then edu_8th=0;
	* if cahps38>0 then edu_somehs=0;
	* if cahps38>0 then edu_hs=0;
	* if cahps38>0 then edu_somecoll=0;
	* if cahps38>0 then edu_collgrad=0;
	* if cahps38>0 then edu_morecoll=0;

	* if cahps38=1 then edu_8th=1;
	* if cahps38=2 then edu_somehs=1;
	* if cahps38=3 then edu_hs=1;
	* if cahps38=4 then edu_somecoll=1;
	* if cahps38=5 then edu_collgrad=1;
	* if cahps38=6 then edu_morecoll=1;

	health_exc = .;
		if cahps29 > 0 then health_exc = 0;
		if cahps29 = 1 then health_exc = 1;
	health_vgd = .;
		if cahps29 >0 then health_vgd = 0;
		if cahps29 = 2 then health_vgd = 1;
	health_gd = .;
		if cahps29 >0 then health_gd = 0;
		if cahps29 = 3 then health_gd = 1;
	health_fair = .;
		if cahps29 >0 then health_fair = 0;
		if cahps29 = 4 then health_fair = 1;
	health_poor = .;
		if cahps29 >0 then health_poor = 0;
		if cahps29 = 5 then health_poor = 1;

	*education;
	edu_8th = .;
		if cahps38 > 0 then edu_8th = 0;
		if cahps38 = 1 then edu_8th = 1;
	edu_somehs = .;
		if cahps38 > 0 then edu_somehs=0;
		if cahps38 = 2 then edu_somehs=1;
	edu_hs = .;
		if cahps38 > 0 then edu_hs=0;
		if cahps38 = 3 then edu_hs=1;
	edu_somecoll = .;
		if cahps38 > 0 then edu_somecoll=0;
		if cahps38 = 4 then edu_somecoll=1;
	edu_collgrad = .;
		if cahps38 > 0 then edu_collgrad=0;
		if cahps38 = 5 then edu_collgrad=1;
	edu_morecoll = .;
		if cahps38 > 0 then edu_morecoll=0;
		if cahps38 = 6 then edu_morecoll=1;

run;

proc freq data=df_SA_merge;
	table aapor disposition /missing;
	table disposition*(contacted completed) /missing nopercent nocol;
	table contacted*completed /missing nopercent nocol norow;
	table race race4 /missing;
	table cahps29 cahps38 /missing;
run;
** AAPOR codebook "K:\TX-EQRO\Research\Member_Surveys\AAPOR Response-Rate-Calculator-4-0-Clean-18-May-2016.xlsx";

** output the processed df for later use;
data temp.&program._df_SA_merge;
	set df_SA_merge;
run;