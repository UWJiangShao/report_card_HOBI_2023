OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT;

** CAHPS;

%let program = P04;

%let Full_Path_And_File_Name 	=  K:\TX-EQRO\Research\Report_Cards_2023\Survey\Data\temp_data\STAR_Adult\P03_df_SA_merge_w.SAS7BDAT;
%let QuotaVariable 			 	=  quota_noAll;
%let Suffix					 	=  _V1;
%let OutputFolder 			 	=  K:\TX-EQRO\Research\Report_Cards_2023\Survey\Output\STAR_Adult\CAHPS_Result;

%include "K:/TX-EQRO/Research/Member_Surveys/Syntax/SAS/Macro_cahps50_launcher.sas" ;


%cahps( var		        = cahps4 cahps6,
		name            = Getting Care Quickly,
        pvalue          = 0.05 ,
	    wgtmean         = CompWeight,
	    wgtdata			= ,
	    low_denominator = 30 ,
		adjuster        = rage health_exc health_vgd health_gd health_fair health_poor 
					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll ,
	    excludeQuotas   = ,
        outname         = GCQ
	   ) ;

%cahps( var		        = cahps4 cahps6,
		name            = Getting Care Quickly,
        pvalue          = 0.05 ,
	    wgtmean         = CompWeight,
	    wgtdata			= ,
	    low_denominator = 30 ,
		adjuster        = ,
	    excludeQuotas   = ,
        outname         = GCQ_no_adj
	   ) ;

%cahps( var		        = cahps18,
		name            = Rating-Personal Doctor,
        pvalue          = 0.05 ,
	    wgtmean         = CompWeight,
	    wgtdata			= ,
	    low_denominator = 30,
		adjuster        = rage health_exc health_vgd health_gd health_fair health_poor 
					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll ,
	    excludeQuotas   = ,
        outname         = PDRat
	   ) ;

%cahps( var		        = cahps18,
		name            = Rating-Personal Doctor,
        pvalue          = 0.05 ,
	    wgtmean         = CompWeight,
	    wgtdata			= ,
	    low_denominator = 30,
		adjuster        = ,
	    excludeQuotas   = ,
        outname         = PDRat_no_adj
	   ) ;



%cahps( var		        = cahps9 cahps20,
		name            = Getting Needed Care,
        pvalue          = 0.05 ,
	    wgtmean         = CompWeight,
	    wgtdata			=  ,
	    low_denominator = 30,
		adjuster        = rage health_exc health_vgd health_gd health_fair health_poor 
					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll ,
	    excludeQuotas   = ,
        outname         = GNC
	   ) ;

%cahps( var		        = cahps12 cahps13 cahps14 cahps15,
		name            = How Well Doctors Communicate,
        pvalue          = 0.05 ,
	    wgtmean         = CompWeight,
	    wgtdata			=  ,
	    low_denominator = 30 ,
		adjuster        = rage health_exc health_vgd health_gd health_fair health_poor 
					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll ,
	    excludeQuotas   = ,
        outname         = HWDC
	   ) ;


%cahps( var		        = cahps18,
		name            = Rating-Personal Doctor,
        pvalue          = 0.05 ,
	    wgtmean         = CompWeight,
	    wgtdata			= ,
	    low_denominator = 30,
		adjuster        = rage health_exc health_vgd health_gd health_fair health_poor 
					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll ,
	    excludeQuotas   = ,
        outname         = PDRat
	   ) ;


%cahps( var		        = cahps28,
		name            = Rating-Health Plan,
        pvalue          = 0.05 ,
	    wgtmean         = CompWeight,
	    wgtdata			=  ,
	    low_denominator = 30,
		adjuster        = rage health_exc health_vgd health_gd health_fair health_poor 
					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll ,
	    excludeQuotas   = ,
        outname         = HPRat
	   ) ;

%cahps( var		        = cahps20,
		name            = Percent access to specialist appointment,
        pvalue          = 0.05 ,
	    wgtmean         = CompWeight,
	    wgtdata			=  ,
	    low_denominator = 30 ,
		adjuster        = rage health_exc health_vgd health_gd health_fair health_poor 
					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll ,
	    excludeQuotas   = ,
        outname         = SpecAppt
	   ) ;


%cahps( var		        = cahps4,
		name            = Percent access to urgent care,
        pvalue          = 0.05 ,
	    wgtmean         = CompWeight,
	    wgtdata			=  ,
	    low_denominator = 30 ,
		adjuster        = rage health_exc health_vgd health_gd health_fair health_poor 
					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll ,
	    excludeQuotas   = ,
        outname         = UrgCare
	   ) ;

%cahps( var		        = cahps6,
		name            = Percent access to routine care,
        pvalue          = 0.05 ,
	    wgtmean         = CompWeight,
	    wgtdata			=  ,
	    low_denominator = 30 ,
		adjuster        = rage health_exc health_vgd health_gd health_fair health_poor 
					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll ,
	    excludeQuotas   = ,
        outname         = RoutCare
	   ) ;

%cahps( var		        = cahps4 cahps6 cahps9 cahps20,
		name            = Access to Care,
        pvalue          = 0.05 ,
	    wgtmean         = CompWeight,
	    wgtdata			=  ,
	    low_denominator = 30 ,
		adjuster        = rage health_exc health_vgd health_gd health_fair health_poor 
					edu_8th edu_somehs edu_hs edu_somecoll edu_collgrad edu_morecoll ,
	    excludeQuotas   = ,
        outname         = AtC	   ) ;

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
