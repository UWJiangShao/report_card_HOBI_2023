OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT;

** import SPSS data;

%let program = P01;

libname temp "..\..\Data\temp_data\STAR_Adult\";

%let SA_path = K:\TX-EQRO\Research\Member_Surveys\CY2023\STAR Adult;
%let SA_survey_data = STAR Adult Data_090823.sav;
%let SA_sample_data = STAR_Adult_23_2303.xlsx;

proc import out=df_SA_survey
	datafile = "&SA_path.\Data\&SA_survey_data."
	dbms = SAV replace;
run;

proc import out=df_SA_sample
	datafile = "&SA_path.\Sample\&SA_sample_data."
	dbms = xlsx replace;
run;

ods excel file = "&program..xlsx";
proc contents data=df_SA_survey varnum;
proc contents data=df_SA_sample varnum;
run;
ods excel close;




proc sql;
	create table df_SA_merge as
	select 
		 A.Survey_ID
		,A.sex
		,A.race
		,A.age
		,A.PHI_SA_Name
		,A.PHI_Plan_Code
		,A.PHI_Plan_Name
		,B.*
	from df_SA_sample A
	join df_SA_survey B on A.Survey_ID = B.P_SURVEYID
	;

	select count(*) as SA_sample_tot_row
		,count(distinct Survey_ID) as SA_sample_uni_sid
	from df_SA_sample
	;

	select count(*) as SA_survey_tot_row
		,count(distinct P_SURVEYID) as SA_survey_uni_sid
	from df_SA_survey
	;

	select count(*) as SA_merge_tot_row
		,count(distinct Survey_ID) as SA_merge_uni_sid
	from df_SA_merge
	;	
quit;

* data temp.&program._df_SA_merge;
* 	set df_SA_merge;
* run;

data df_SA_merge; 
	set df_SA_merge;

	word1 = compress(scan(PHI_Plan_Name, 1), , 'ka'); 
	word2 = compress(scan(PHI_Plan_Name, 2), , 'ka'); 
	plan_new = catx('', word1, word2);
	plan_new = compress(plan_new); 

	word1 = compress(scan(PHI_SA_Name, 1), , 'ka'); 
	word2 = compress(scan(PHI_SA_Name, 2), , 'ka'); 
	sa_new = catx('_', word1, word2); 

	word1 = compress(scan(Race, 1), , 'ka'); 
	word2 = compress(scan(Race, 2), , 'ka'); 
	race_new = catx('_', word1, word2); 

run; 

data temp.P01_df_SA_merge;
	set df_SA_merge;

	quota_01 = catx('_', plan_new, sa_new, Sex, race_new); 

	quota_02 = catx('_', 'ALL', sa_new, Sex, race_new); 
	quota_03 = catx('_', plan_new, 'ALL', Sex, race_new); 
	quota_04 = catx('_', plan_new, sa_new, 'ALL', race_new); 
	quota_05 = catx('_', plan_new, sa_new, Sex, 'ALL'); 

	quota_06 = catx('_', 'ALL', 'ALL', Sex, race_new); 
	quota_07 = catx('_', 'ALL', sa_new, 'ALL', race_new); 
	quota_08 = catx('_', 'ALL', sa_new, Sex, 'ALL'); 
	quota_09 = catx('_', plan_new, 'ALL', 'ALL', race_new); 
	quota_10 = catx('_', plan_new, 'ALL', Sex, 'ALL'); 
	quota_11 = catx('_', plan_new, sa_new, 'ALL', 'ALL'); 

	quota_12 = catx('_', 'ALL', 'ALL', 'ALL', race_new); 
	quota_13 = catx('_', 'ALL', 'ALL', Sex, 'ALL'); 
	quota_14 = catx('_', 'ALL', sa_new, 'ALL', 'ALL'); 
	quota_15 = catx('_', plan_new, 'ALL', 'ALL', 'ALL'); 
	quota_16 = catx('_', 'ALL', 'ALL', 'ALL', 'ALL'); 

run;


proc freq data = temp.P01_df_SA_merge;
	tables quota_01 - quota_16; 
run; 






