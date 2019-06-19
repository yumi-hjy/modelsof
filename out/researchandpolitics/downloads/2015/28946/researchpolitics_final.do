/*Research & Politics do-file*/

/* demographics*/

gen region = q1
gen pid = f1
gen educ = d12
/*is it occurring?*/

/*subjective*/
gen c_feltknow = ccn10

/*objective*/
recode coal 1/2=0 3/4=1

/*1 is definitely not true, 2 is probably not true, 3 is probably true, 4 is definitely true*/
recode greenhouse 1/2=1 3/4=0
recode kyoto 1=0 2=1 3/4=0

/*knowledge scale, and dichotomous measure - the majority of our analysis relies on the dichotomous measure*/
gen knowtot = coal + greenhouse + kyoto

gen knowdi = knowtot
recode knowdi 0/1=0  2/3=1

/*knowledge correlates*/

tab educ knowtot, row chi2
tab female knowtot, row chi2
tab pid knowtot, row chi2

/*agreement with persuasive message*/

/*ccc1, ccc2, ccc3a, ccc3b - agreement with ad*/
/*creating agree variable for everyone*/

gen ccc1_n = ccc1
recode ccc1_n .=0
gen ccc2_n = ccc2
recode ccc2_n .=0
gen ccc3a_n = ccc3a
recode ccc3a_n .=0
gen agree = ccc1_n + ccc2_n + ccc3a_n
recode agree 0=.

/* agree by condition*/

anova agree cond
anova agree cond knowdi cond#knowdi

/* worry by condition*/

/*worry by condition, moderated by knowledge*/
mean c_worry if knowdi==0, over(cond)
mean c_worry if knowdi==1, over(cond)

/*behaviors by condition, moderated by knowledge*/
anova c_behav1 cond knowdi cond#knowdi
anova c_behav2 cond knowdi cond#knowdi
anova c_behav3 cond knowdi cond#knowdi
anova c_behav4 cond knowdi cond#knowdi
anova c_behav5 cond knowdi cond#knowdi
anova c_behav6 cond knowdi cond#knowdi

/*talk is c_behav4, petition is c_behav1*/
mean c_behav4 if knowdi==1, over(cond)

/*for figure 4, sign a petition*/
mean c_behav1 if knowdi==0, over(cond)
mean c_behav1 if knowdi==1, over(cond)

anova c_imp cond knowdi cond#knowdi

mean c_imp if knowdi==0, over(cond)
mean c_imp if knowdi==1, over(cond)

/*supplimental partisan analysis*/

/*100 republicans, 118 democrats*/

anova agree cond demrep cond#demrep

anova c_behav1 cond demrep cond#demrep
anova c_behav4 cond demrep cond#demrep



