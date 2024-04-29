OPTIONS PS=MAX FORMCHAR="|----|+|---+=|-/\<>*" MPRINT nofmterr;

%let program = P051;
%let prog = SA;

libname temp "K:\TX-EQRO\Research\Report_Cards_2023\Survey\Data\temp_data\STAR_Adult\";

proc freq data=temp.p02_df_&prog._merge;
	table disposition *located /missing nopercent norow nocol;
	table located non_eligilbe_resp refused;
run;

* data df_&prog._located;
* 	set temp.p02_df_&prog._merge;
* 	keep disposition contacted completed located;
* 	located = 0;
* 	if ('1100' <= disposition <= '1200') 
* 		or ('2100' <= disposition <= '2399')
* 		or ('4700' <= disposition <= '4799')
* 		or ('5100' <= disposition <= '5200')

* 		then located=1;

* run;

* *since no respondent and refusal are based on "located" - aka eligible, we create another dataset;
* data df_&prog._located_1;
* 	set df_&prog._located;
* 	where located = 1;

* 	noResp =.;
* 	if located = 1 then do;
* 		if disposition = '4700'
* 		then noResp = 1;
* 		else noResp = 0;
* 	end;

* 	refuse =.;
* 		if located = 1 then do;
* 		if disposition = '2110' or disposition = '2120'
* 		then refuse = 1;
* 		else refuse = 0;
* 	end;
* run;


* *To calculate the percentage of complete and contacted among total attempt, we create another dataset, 
* which disposition not equal to missing; 
* data df_&prog._attempt;
* 	set temp.p02_df_&prog._merge;
* 	if disposition ne .;
* run;

* proc freq data=df_&prog._attempt;
* 	table disposition;
* 	title "All attempted - disposition table";
* run;


* proc freq data = df_&prog._attempt;
* 	table contacted /missing nocol norow;
* 	table completed /missing nocol norow;
* 	title "Contacted and Complete FREQ and Rate Table";
* run;

* proc freq data=df_&prog._located;
* 	table located / missing;
* 	title "Located Rate Table";
* run;

* proc freq data=df_&prog._located_1;
* 	table located / missing;
* 	table noResp / missing;
* 	table refuse / missing;
* 	title "Not eligible respondent found/ refusal Rate Table";
* run;
