OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT;

** NRA and weight adjust;

%let program = P03;
%let prog = SA;

* libname temp "K:\TX-EQRO\Research\Report_Cards_2023\Survey\Data\temp_data\STAR_Adult\";
libname temp "..\..\Data\temp_data\STAR_Adult\";

%let SA_path = K:\TX-EQRO\Research\Member_Surveys\CY2023\STAR Adult;

** for adult, age difference threshold is 5 years.;
%let age_diff_th = 5;


data df_SA_merge1;
	set temp.P02_df_SA_merge;
run;

* proc sql;
* 	select count(*) as tot_row
* 		,count(distinct su_id) as unique_su_id
* 	from df_SA_merge1
* 	;
* quit;

** bin age;
proc hpbin data=df_SA_merge1 output=df_SA_agebin numbin=5 pseudo_quantile noprint;
	input age;
	id su_id;
run;

*** merge it back to main data;
proc sql;
	create table df_SA_merge as
	select A.*
		,B.BIN_Age
	from df_SA_merge1 A
	join df_SA_agebin B on A.su_id = B.su_id
	;
quit;

** check frequency;
proc freq data=df_SA_merge;
	tables contacted completed sex race4 age BIN_Age/missing list;
run;

** NRA -----------------------------------------------------------------------------------------;

%macro NRA_N(status, threshold);
	proc ttest data=df_SA_merge;
		class &status.;
		var age;
		ods output ttests=&status._t statistics=&status._s;
	run;

	proc sql;
		create table nra_&status._age as
		select distinct
			 "&status. Age" as Test
			,abs(A.Mean) as diff
			,B.probt as Prob
			,case when calculated diff > &threshold. and Prob < 0.05 then 1 else 0 end as significant_nr
		from &status._s A, &status._t B
		where A.Class = 'Diff (1-2)' and B.Method = 'Pooled'
		;
	quit;
%mend NRA_N;

%macro NRA_C(status, strata);

	proc freq data=df_SA_merge;
		tables &status.*&strata./nopercent norow chisq out=&status._&strata._fq totpct outpct;
		ods output chisq=chisq_&strata.;
	run;

	proc sql;
		create table nra_&status._&strata. as
		select distinct 
			 "&status. &strata." as Test
			,(max(A.PCT_COL) - min(A.PCT_COL))/100 as diff
			,B.Prob
			,case when calculated diff > 0.05 and B.Prob < 0.05 then 1 else 0 end as significant_nr
		from &status._&strata._fq A, chisq_&strata. B
		where A.&status. = 1 and B.Statistic = 'Chi-Square'
		;
	quit;
%mend NRA_C;

ods select none;
%NRA_C(Completed, race4);
%NRA_C(Completed, sex);
%NRA_C(Completed, BIN_Age);
%NRA_N(Completed, &age_diff_th.);
%NRA_C(Contacted, race4);
%NRA_C(Contacted, sex);
%NRA_C(Contacted, BIN_Age);
%NRA_N(Contacted, &age_diff_th.);

data nra_result;
	length Test $15;
	set 
		nra_Completed_race4
		nra_Completed_sex
		nra_Completed_age
		nra_Contacted_race4
		nra_Contacted_sex
		nra_Contacted_age
		;
run;

ods select all;
title "NRA results";
proc print data=nra_result;
run;
title;


** create weight for each strata -----------------------------------------------------------; 
proc freq data=df_SA_merge noprint;
	tables race4 /out=sample_race4_fq;
run;

proc freq data=df_SA_merge noprint;
	tables sex /out=sample_sex_fq;
run;

proc freq data=df_SA_merge noprint;
	tables BIN_Age /out=sample_BIN_Age_fq;
run;

proc sql;
	create table df_race_weight as
	select A.race4
		,C.PERCENT as Sample_dist
		,A.PCT_ROW as Contacted_dist
		,B.PCT_ROW as Completed_dist
		,A.PCT_ROW / B.PCT_ROW as CMP_Weight_race
		,C.PERCENT / A.PCT_ROW as CON_Weight_race
	from Contacted_race4_fq A
	join completed_race4_fq B on A.race4 = B.race4
	join sample_race4_fq C on A.race4 = C.race4
	where A.contacted = 1 and B.completed = 1
	;

	create table df_sex_weight as
	select A.sex
		,C.PERCENT as Sample_dist
		,A.PCT_ROW as Contacted_dist
		,B.PCT_ROW as Completed_dist
		,A.PCT_ROW / B.PCT_ROW as CMP_Weight_sex
		,C.PERCENT / A.PCT_ROW as CON_Weight_sex
	from Contacted_sex_fq A
	join completed_sex_fq B on A.sex = B.sex
	join sample_sex_fq C on A.sex = C.sex
	where A.contacted = 1 and B.completed = 1
	;

	create table df_Age_weight as
	select A.BIN_Age
		,C.PERCENT as Sample_dist
		,A.PCT_ROW as Contacted_dist
		,B.PCT_ROW as Completed_dist
		,A.PCT_ROW / B.PCT_ROW as CMP_Weight_Age
		,C.PERCENT / A.PCT_ROW as CON_Weight_Age
	from Contacted_BIN_Age_fq A
	join completed_BIN_Age_fq B on A.BIN_Age = B.BIN_Age
	join sample_BIN_Age_fq C on A.BIN_Age = C.BIN_Age
	where A.contacted = 1 and B.completed = 1
	;
quit;

Title "Weight by strata";
proc print data=df_race_weight noobs;
proc print data=df_sex_weight noobs;
proc print data=df_age_weight noobs;
run;
title;

** weight adjust ------------------------------------------------------------------------------------------;
** import data file with pool sample counts;
proc import out=df_SA_psc
	datafile="&SA_path.\Sample\STAR_Adult_23_samp_cnts_2303.xlsx"
	dbms=xlsx replace;
	sheet='STAR_Adult_2023_Counts';
run;

* proc contents data=df_SA_psc varnum;
* run;

proc sql;
	create table df_SA_weight as
	select distinct
		 A.PHI_Plan_Code
		,count(A.Survey_ID) as completed
		,B.sample_pool_members
		,B.sample_pool_members/count(A.Survey_ID) as BWeight
		,B.eligible_members	
		,B.eligible_members_after_exclusion
	from df_SA_merge A
	left join df_SA_psc B on A.PHI_Plan_Code = B.PLAN_CD
	where A.completed = 1
	group by A.PHI_Plan_Code
	;
quit;

proc print data=df_SA_weight;
run;

proc sql;
	select sum(completed) as tot_completed
	from df_SA_weight
	;
quit;

** output weight;
data temp.&program._df_SA_weight;
	set df_SA_weight;
run;

proc sql;
	create table df_SA_merge_w as
	select A.*
		,B.BWeight
		,C.CMP_Weight_race
		,D.CMP_Weight_sex
		,E.CMP_Weight_Age
		,C.CON_Weight_race
		,D.CON_Weight_sex
		,E.CON_Weight_Age
	from df_SA_merge A
	left join df_SA_weight B on A.PHI_Plan_Code = B.PHI_Plan_Code
	left join df_race_weight C on A.race4 = C.race4
	left join df_sex_weight D on A.sex = D.sex
	left join df_age_weight E on A.BIN_Age = E.BIN_Age
	;
quit;


** apply weight;
proc sql;
	select significant_nr into :sig_nr_CMP_race4 from nra_Completed_race4;
	select significant_nr into :sig_nr_CMP_sex from nra_Completed_sex;
	select significant_nr into :sig_nr_CMP_age from nra_Completed_age;
	select significant_nr into :sig_nr_CON_race4 from nra_Contacted_race4;
	select significant_nr into :sig_nr_CON_sex from nra_Contacted_sex;
	select significant_nr into :sig_nr_CON_age from nra_Contacted_age;
quit;

%put "sig_nr_CMP_race4:" &sig_nr_CMP_race4.;
%put "sig_nr_CMP_sex:" &sig_nr_CMP_sex.;
%put "sig_nr_CMP_age:" &sig_nr_CMP_age.;
%put "sig_nr_CON_race4:" &sig_nr_CON_race4.;
%put "sig_nr_CON_sex:" &sig_nr_CON_sex.;
%put "sig_nr_CON_age:" &sig_nr_CON_age.;

%macro output_df;
	data temp.&program._df_SA_merge_w;
		set df_SA_merge_w;

		compweight = BWeight;

		%if &sig_nr_CMP_race4. = 1 %then %do;
			compweight = compweight * CMP_Weight_race;
		%end;

		%if &sig_nr_CMP_sex. = 1 %then %do;
			compweight = compweight * CMP_Weight_sex;
		%end;

		%if &sig_nr_CMP_Age. = 1 %then %do;
			compweight = compweight * CMP_Weight_Age;
		%end;

		%if &sig_nr_CON_race4. = 1 %then %do;
			compweight = compweight * CON_Weight_race;
		%end;

		%if &sig_nr_CON_sex. = 1 %then %do;
			compweight = compweight * CON_Weight_sex;
		%end;

		%if &sig_nr_CON_Age. = 1 %then %do;
			compweight = compweight * CON_Weight_Age;
		%end;
	run;
%mend output_df;

%output_df;


*Output the dataset for TechApp;
* Create Quotanumb for TechApp (MCO-SA);
* Sort the data by MCO --> SA;

proc sort data=temp.p03_df_SA_merge_w;
	by PHI_SA_Name PHI_Plan_Name;
run;

data temp.&program._df_&prog._merge_final;
	set temp.&program._df_&prog._merge_w;
	by PHI_SA_Name PHI_Plan_Name;

	if first.PHI_Plan_Name or first.PHI_SA_Name then do;
	if not missing(PHI_Plan_Name) and not missing(PHI_SA_Name) then
		count + 1;
	end;

	if not missing(PHI_Plan_Name) and not missing(PHI_SA_Name) then do;
	count_format = put(count, z2.);
	mco_sa = cats(count_format, '-', PHI_Plan_Name, '-', PHI_SA_Name);
	end;
	else
	mco_sa = "";

	label mco_sa = "quota number (alpha by SA then MCO)";
run;

proc freq data=temp.&program._df_&prog._merge_final;
	table mco_sa;
run;

proc sort data=temp.&program._df_&prog._merge_final;
	by PHI_Plan_Name;
run;

proc export data= temp.p03_df_sa_merge_final(where=(completed = 1))
	outfile="K:\TX-EQRO\Research\Report_Cards_2023\Survey\Data\temp_data\STAR_Adult\p03_df_sa_merge_final.sav"
	dbms=spss replace;
run;

/* recode for CAHPS */ 
* proc format; 
* 	value cahps7_f


* * 0.5. copy dataset and rename to _recode.

* * 1. format -8 -9  missing

* * proc format; 
* * 	value cahps6_f
* * 	4 = 1
* * 	other = 0

* * 	value cahps10_f
* * 	1-5 = 1
* * 	other = 0



* * 2. format cahps6 - value 

