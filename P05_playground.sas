* OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT validvarname = ANY nofmterr;

* ** Technical appendix tables;

* %let program = P05;
* %let prog = SA;

* libname temp "K:\TX-EQRO\Research\Report_Cards_2023\Survey\Data\temp_data\STAR_Adult\";


* proc contents data=temp.P03_df_sa_merge_w;
* run;

* proc freq data=temp.P03_df_sa_merge_w;
* 	where completed = 1;
* 	* table PHI_Plan_Code * cahps20 /nopercent nocol;
* 	table rage health_exc health_vgd health_gd health_fair health_poor 
* 					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll;
* run;


OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT;

libname temp "K:\TX-EQRO\Research\Report_Cards_2023\Survey\Data\temp_data\STAR_Adult";
proc freq data = temp.P03_df_SA_merge_w;
	tables cahps7; 
run; 

proc format;
	value _16t1_
	0 = 0
	1-6 = 1
	-8 = .
	-9 = .
	;
run;

data temp.P05_df_test;
	set temp.P03_df_SA_merge_w;
	r_cahps7 = .;
	if cahps7 = 0 then r_cahps7 = 0;
	if 1 <= cahps7 <= 6 then r_cahps7 = 1;

	f_cahps7 = input(put(cahps7, _16t1_.), 1.);
run;

proc freq data = temp.P05_df_test;
	tables r_cahps7 f_cahps7; 
run; 


%let Full_Path_And_File_Name 	=  K:\TX-EQRO\Research\Report_Cards_2023\Survey\Data\temp_data\STAR_Adult\P05_df_test.SAS7BDAT;
%let QuotaVariable 			 	=  PHI_Plan_Name;
%let Suffix					 	=  _V1;
%let OutputFolder 			 	=  K:\TX-EQRO\Research\Report_Cards_2023\Survey\Program\STAR_Adult;

%include "K:/TX-EQRO/Research/Member_Surveys/Syntax/SAS/Macro_cahps50_launcher_Debug_20240410.sas" ;


%cahps( var		        = f_cahps7,
		name            = cahps7,
        pvalue          = 0.05 ,
	    wgtmean         = CompWeight,
	    wgtdata			= ,
	    low_denominator = 30 ,
		adjuster        = rage health_exc health_vgd health_gd health_fair health_poor 
					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll ,
	    excludeQuotas   = ,
        outname         = cahps7,
        recode = 0,
        vartype = 1 
	   ) ;


/*
** import SPSS data;

%let program = P05;

libname temp "..\..\Data\temp_data\STAR_Adult\";

* proc contents data = temp.P01_df_SA_merge;	
* run;


data temp.P03_df_SA_merge_w; 
	set temp.P03_df_SA_merge_w; 
	cahps999 = cahps11; 
run; 

proc freq data = temp.P03_df_SA_merge_w;
	tables cahps11 cahps999 cahps18; 
run; 



proc format; 
	value invalid_survey_resp
	-9 = .
	-8 = .; 
run; 

data temp.P03_df_SA_merge_w_miss; 
	set temp.P03_df_SA_merge_w; 
	format cahps11 invalid_survey_resp.; 
run; 

proc freq data = temp.P03_df_SA_merge_w_miss;
	tables PHI_Plan_Code * cahps11; 
run; 

data temp.P03_df_SA_merge_w_miss;
	set temp.P03_df_SA_merge_w_miss; 
	if 0 <= cahps11 <= 2 then cahps11_new = 1; 
	else if 3 <= cahps11 <= 4 then cahps11_new = 2; 
	else if 5 <= cahps11 <= 6 then cahps11_new = 3; 
	else cahps11_new = .; 
run; 

proc freq data = temp.P03_df_SA_merge_w_miss;
	tables cahps11 cahps11_new; 
run; 




* data new_quota_dataset; 
* 	set temp.P01_df_SA_merge;

* 	word1 = compress(scan(PHI_Plan_Name, 1), , 'ka'); 
* 	word2 = compress(scan(PHI_Plan_Name, 2), , 'ka'); 
* 	plan_new = catx('_', word1, word2); 

* 	word1 = compress(scan(PHI_SA_Name, 1), , 'ka'); 
* 	word2 = compress(scan(PHI_SA_Name, 2), , 'ka'); 
* 	sa_new = catx('_', word1, word2); 

* 	word1 = compress(scan(Race, 1), , 'ka'); 
* 	word2 = compress(scan(Race, 2), , 'ka'); 
* 	race_new = catx('_', word1, word2); 

* run; 


* data temp.P01_df_SA_merge;
* 	set new_quota_dataset;
* 	quota_noAll = catx('_', plan_new, sa_new, Sex, race_new); 
* run;