OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT;

** NRA and weight adjust;

%let program = P03;
%let prog = SA;

libname temp "K:\TX-EQRO\Research\Report_Cards_2023\Survey\Data\temp_data\STAR_Adult\";


/* For portal */ 
proc format; 

/* this is the most basic format, Yes = 1 and No = 0. All response should be this type */ 
/* verified range */ 
	value _1to1_short
	1 = '1'
	2 = '0'
	-9 = .
	-8 = .
	other = .; 

/* verified range */ 
	value _1to1_long
	1 = '1'
	other = '0'
	-9 = .
	-8 = .
	. = '.'; 

	value _1to2_
	1-2 = '1'
	3 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _1to3_short
	1-3 = '1'
	4 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _1to3_long
	1-3 = '1'
	4-5 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _1to5_long
	1-5 = '1'
	6-9 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _1to5_short
	1-5 = '1'
	6 = '0'
		-9 = .
	-8 = .
	other = .; 

/* verified range */ 
	value _10to11_
	9-10 = '1'
	0-8 = '0'
		-9 = .
	-8 = .
	other = .;

/* this format is for response1 and response2 set of (No, Yes) */ 
	value _2to2_
	2 = '1'
	1 = '0'
		-9 = .
	-8 = .
	other = '.' ;

	value _2to3_ 
	2-3 = '1'
	1 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _2to4_
	2-4 = '1'
	1 = '0'
		-9 = .
	-8 = .
	other = .;

	value _2to5_
	2-5 = '1'
	1 = '0'
		-9 = .
	-8 = .
	other = .;

	value _2to6_
	2-6 = '1'
	1 = '0'
		-9 = .
	-8 = .
	other = .;

/* this question is for "1 or more time", resp1 is 0, and resp7 is 10 or more time */ 
/* verified range */ 
	value _2to7_
	1-6 = '0'
	0 = '1'
	-8 = .
	-9 = .
	other = .;

	value _3to5_
	3-5 = '1'
	1-2 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _3to6_
	3-6 = '1'
	1-2 = '0'
		-9 = .
	-8 = .
	other = .; 

	value _4to4_
	4 = '1'
	1-3 = '0'
	-9 = .
	-8 = .
	other = .; 

	value _5to5_
	5 = '1'
	1-4 = '0'
		-9 = .
	-8 = .
	other = .; 
run; 



/* output the recoded dataset for CAHPS case mix */ 

libname thlc "K:\TX-EQRO\Research\Member_Surveys\THLC\STARAdult_2023\case_mix_output"; 

data &program._df_&prog._merge_w_recoded; 
	set temp.&program._df_&prog._merge_w; 
run;

ods pdf file="K:\TX-EQRO\Research\Member_Surveys\THLC\STARAdult_2023\SA_question_dist.pdf";

proc freq data = &program._df_&prog._merge_w_recoded; 
	tables  intro -- EXITCB1C / list; 
run; 

ods pdf close; 


/* import two indicator files */ 
proc import out=cahps_list
	datafile = "K:\TX-EQRO\Inbound\thlc_working_dir\cahps_list_by_program.xlsx"
	dbms = xlsx replace;
	sheet = 'SA_2023_CAHPS'; 
run;

proc import out=itemID_vs
	datafile = "K:\TX-EQRO\Inbound\thlc_working_dir\THLC_Surveys - item ID table_v6.xlsx"
	dbms = xlsx replace;
run;

data thlc_vs; 	
	set itemID_vs (keep=ItemID low_box high_box combination_box format_sas); 
run; 

proc freq data=thlc_vs; 
	tables format_sas; 
run; 

proc sql; 
	create table cahps_info as 
	select a.*, b.*
	from cahps_list as a
	inner join thlc_vs as b
	on a.itemID = b.itemID; 
quit; 

data cahps_info; 
	set cahps_info; 
	var = upcase(var); 
	outname = upcase(outname); 
run; 


data df_format; 
	set &program._df_&prog._merge_w_recoded; 
					cahps4 = input(put(cahps4,  	_4to4_.), 1.); 
					cahps6 = input(put(cahps6,       _4to4_.), 1.); 
					cahps9 =  input( put(cahps9,   _4to4_.), 1.); 
					cahps20 =  input( put(cahps20,       _4to4_.), 1.); 
					cahps12 =  input( put(cahps12,    _4to4_. ), 1.); 
					cahps13 =  input( put(cahps13,    _4to4_. ), 1.); 
					cahps14 =  input( put(cahps14,    _4to4_. ), 1.); 
					cahps15 =  input( put(cahps15,       _4to4_.), 1.); 
					cahps3 =  input( put(cahps3,       _1to1_short.), 1.); 
					cahps5 =  input( put(cahps5,       _1to1_short.), 1.); 
					cahps7 =  input( put(cahps7,       _2to7_.), 1.); 

					cahps10 =  input( put(cahps10,       _1to1_short.), 1.); 
					cahps11 =  input( put(cahps11,       _2to7_.), 1.); 

					cahps18 =  input( put(cahps18,       _10to11_.), 1.); 
					cahps19 =  input( put(cahps19,       _1to1_short.), 1.); 

					cahps28 =  input( put(cahps28,       _10to11_.), 1.); 
					cahps29 =  input( put(cahps29,       _1to1_long.), 1.); 
					cahps38 =  input( put(cahps38,       _3to6_.), 1.); 
	
run; 
proc freq data = df_format; 
	tables cahps9 
cahps20
cahps12
cahps13
cahps14
cahps15
cahps3 
cahps5 
cahps7 
cahps10
cahps11
cahps18
cahps19
cahps28
cahps29
cahps38 
			/ list; 
run; 

proc freq data=df_format; 
	tables PHI_Plan_Name PHI_SA_Name Race; 
run; 

data df_format_all_quota;
	set df_format;

	if Race =  "White, Non-Hispanic" then race_new = 1; 
	if Race =  "Black, Non-Hispanic" then race_new = 2; 
	if Race =  "Hispanic" then race_new = 3; 
	if Race =  "American Indian or Alaskan" then race_new = 4; 
	if Race =  "Asian, Pacific Islander" then race_new = 5; 
	if Race =  "Unknown / Other" then race_new = 6; 

	if PHI_Plan_Name =  "Aetna Better Health" then plan_new = 'A_'; 
	if PHI_Plan_Name =  "Amerigroup" then plan_new = 'B_'; 
	if PHI_Plan_Name =  "Blue Cross Blue Shield of Texas" then plan_new = 'C_'; 
	if PHI_Plan_Name =  "Community First Health Plans" then plan_new = 'D_'; 
	if PHI_Plan_Name =  "Community Health Choice" then plan_new = 'E_'; 
	if PHI_Plan_Name =  "Cook Children's Health Plan" then plan_new = 'F_'; 
	if PHI_Plan_Name =  "Dell Children's Health Plan (formerly Seton)" then plan_new = 'G_'; 
	if PHI_Plan_Name =  "Driscoll Health Plan" then plan_new = 'H_'; 
	if PHI_Plan_Name =  "El Paso Health" then plan_new = 'I_'; 
	if PHI_Plan_Name =  "FirstCare Health Plans" then plan_new = 'J_'; 
	if PHI_Plan_Name =  "Molina Healthcare of Texas" then plan_new = 'K_'; 
	if PHI_Plan_Name =  "Parkland Community Health Plan" then plan_new = 'L_'; 
	if PHI_Plan_Name =  "RightCare from Scott & White Health Plan" then plan_new = 'M_'; 
	if PHI_Plan_Name =  "Superior HealthPlan" then plan_new = 'N_'; 
	if PHI_Plan_Name =  "Texas Children's Health Plan" then plan_new = 'O_'; 
	if PHI_Plan_Name =  "UnitedHealthCare Community Plan" then plan_new = 'P_'; 

	quota_01 = cats("", plan_new, PHI_SA_Name, Sex, race_new); 

	quota_02 = cats("", 'ALL', PHI_SA_Name, Sex, race_new); 
	quota_03 = cats("", plan_new, 'ALL', Sex, race_new); 
	quota_04 = cats("", plan_new, PHI_SA_Name, 'ALL', race_new); 
	quota_05 = cats("", plan_new, PHI_SA_Name, Sex, 'ALL'); 

	quota_06 = cats("", 'ALL', 'ALL', Sex, race_new); 
	quota_07 = cats("", 'ALL', PHI_SA_Name, 'ALL', race_new); 
	quota_08 = cats("", 'ALL', PHI_SA_Name, Sex, 'ALL'); 
	quota_09 = cats("", plan_new, 'ALL', 'ALL', race_new); 
	quota_10 = cats("", plan_new, 'ALL', Sex, 'ALL'); 
	quota_11 = cats("", plan_new, PHI_SA_Name, 'ALL', 'ALL'); 

	quota_12 = cats("", 'ALL', 'ALL', 'ALL', race_new); 
	quota_13 = cats("", 'ALL', 'ALL', Sex, 'ALL'); 
	quota_14 = cats("", 'ALL', PHI_SA_Name, 'ALL', 'ALL'); 
	quota_15 = cats("", plan_new, 'ALL', 'ALL', 'ALL'); 
	quota_16 = cats("", 'ALL', 'ALL', 'ALL', 'ALL'); 
run;

proc freq data=df_format_all_quota; 
tables quota_01 quota_16;
run; 



/* save the recoded data */ 
data thlc.df_format_all_quota_sa; 
	set df_format_all_quota; 
run; 

proc freq data=thlc.df_format_all_quota_sa; 
tables quota_01 quota_16;
run; 

