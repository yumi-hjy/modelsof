clearuse "CO10p_ToDrawSample.dta", clear*This is the model for the Democratic Primary*Only include Democrats and Unaffiliatedlogit p08 prim prim_dem gen gen_dem odd odd_dem age age2 orig_regdate recent_regdate dem female competitive_dem_unaf competitive_dem_dem ///if ((eligible_p08==1 & dem==1) | (eligible_p08==1 & unaf==1))predict D_PTOP_10 if rep != 1 & eligible_p08 == 1*This is the model for the Republican Primary*Only include Republicans and Unaffiliatedlogit p08 prim prim_rep gen gen_rep odd odd_rep age age2 orig_regdate recent_regdate rep female competitive_rep_unaf competitive_rep_rep ///if ((eligible_p08==1 & rep==1) | (eligible_p08==1 & unaf==1))predict R_PTOP_10 if dem != 1 & eligible_p08 == 1hist D_PTOP_10
hist R_PTOP_10hist D_PTOP_10 if sample_dem == 1hist R_PTOP_10 if sample_rep == 1
