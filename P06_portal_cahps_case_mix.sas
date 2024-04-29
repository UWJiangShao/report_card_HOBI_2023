OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT;

** CAHPS;

proc format; 
	value invalid_survey_resp
	-9 = 0
	-8 = 0; 
run; 

%let program = P04;

%let Full_Path_And_File_Name 	=  K:\TX-EQRO\Research\Report_Cards_2023\Survey\Data\temp_data\STAR_Adult\P03_df_SA_merge_w_miss.SAS7BDAT;
%let QuotaVariable 			 	=  PHI_Plan_Code;
%let Suffix					 	=  _by_plancode;
%let OutputFolder 			 	=  K:\TX-EQRO\Research\Report_Cards_2023\Survey\Output\STAR_Adult\CAHPS_result_apr-5; 

%include "K:/TX-EQRO/Research/Member_Surveys/Syntax/SAS/Macro_cahps50_launcher.sas" ;

%let adjuster = rage health_exc health_vgd health_gd health_fair health_poor 
					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll; 






* %cahps(var = cahps3,  name = out_CAHPS3,  Vartype = 1, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS3); 
* * %cahps(var = cahps4,  name = out_CAHPS4,  Vartype = 3, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS4); 
* * %cahps(var = cahps5,  name = out_CAHPS5,  Vartype = 1, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS5); 
* * %cahps(var = cahps6,  name = out_CAHPS6,  Vartype = 3, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS6); 
* * %cahps(var = cahps7,  name = out_CAHPS7,  Vartype = 5, min_resp = 1, max_resp = 6, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS7); 
* * %cahps(var = cahps9,  name = out_CAHPS9,  Vartype = 3, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS9); 
* * %cahps(var = cahps10, name = out_CAHPS10, Vartype = 1, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS10); 


* * %cahps(var = cahps12, name = out_CAHPS12, Vartype = 3, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS12); 
* * %cahps(var = cahps13, name = out_CAHPS13, Vartype = 3, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS13); 
* * %cahps(var = cahps14, name = out_CAHPS14, Vartype = 3, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS14); 
* * %cahps(var = cahps15, name = out_CAHPS15, Vartype = 3, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS15); 
* %cahps(var = cahps18, name = out_CAHPS18, Vartype = 5, min_resp = 0, max_resp = 5, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS18); 

%cahps(var = cahps11_new, 
		name = out_CAHPS11, 
		pvalue = 0.05, 
		wgtmean = CompWeight, 
		low_denominator = 5, 
		adjuster = , 
		wgtdata = , 
		excludeQuotas = , 
		outname = out_CAHPS11, 
		vartype = 4); 


* %cahps(var = cahps19, name = out_CAHPS19, Vartype = 1, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS19); 
* %cahps(var = cahps20, name = out_CAHPS20, Vartype = 3, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS20); 
* %cahps(var = cahps28, name = out_CAHPS28, Vartype = 2, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS28); 


* %cahps(var = cahps29, name = out_CAHPS29, Vartype = 5, min_resp = 5, max_resp = 1,pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS29); 
* %cahps(var = cahps38, name = out_CAHPS38, Vartype = 5, pvalue = 0.05, wgtmean = CompWeight, low_denominator = 30, adjuster = &adjuster., wgtdata = , excludeQuotas = , outname = out_CAHPS38); 

* %cahps( var		        = cahps4 cahps6,
* 		name            = Getting Care Quickly,
*         pvalue          = 0.05 ,
* 	    wgtmean         = CompWeight,
* 	    wgtdata			= ,
* 	    low_denominator = 30 ,
* 		adjuster        = rage health_exc health_vgd health_gd health_fair health_poor 
* 					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll ,
* 	    excludeQuotas   = ,
*         outname         = GCQ
* 	   ) ;


*----------------------------------------------------------------------------*
| No edits are required below this line -- the lines below are for cleanup   |
| and logging. A new Excel file </OutputFolder/datasetname_out.xlsx> 	 	 |
| will have the fields you will need for your next analysis/reporting steps. |
*----------------------------------------------------------------------------*;
%nowbox (logtext = End &FileName version &Version ) ;
*----------------------------------------------------------------------------*
|  Reset the log and output files back to the defaults                       |
*----------------------------------------------------------------------------*;
proc printto ;
run ;
filename _all_ clear ;
quit; 

