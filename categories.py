control_flow = [
    'else',
    'end',
    'ereturn',
    'for',
    'foreach',
    'forval',
    'forvalues',
    'if',
    'return',
    'while',
]

identification = [
    'stset',
    'svy',
    'xtset',
]

loading = [
    'append',
    'backup',
    'do',
    'erase',
    'export',
    'file',
    'include',
    'insheet',
    'joinby',
    'odbc',
    'outsheet',
    'parmest',
    'post',
    'postclose',
    'postfile',
    'postutil',
    'putexcel',
    'reclink',
    'save',
    'saveold',
    'savesome',
    'use13',
]

meta = [
    'args',
    'cap',
    'capture',
    'cd',
    'exit',
    'findit'
    'format',
    'fvset',
    'log',
    'more',
    'name',
    'net',
    'noisily',
    'pause',
    'preserve',
    'prog',
    'program',
    'r',
    'restore',
    'qui',
    'quietly',
    'ssc',
    'tempfile',
    'version',
    'view',
    'winow',
]

# by commands and commands like it manipulation?

manipulation = [
    'aorder',
    'bootstrap',
    'bs',
    'by',
    'bysort',
    'carryforward',
    'clonevar',
    'collapse',
    'compress',
    'decode',
    'destring',
    'drawnorm',
    'dropmiss',
    'duplicates',
    'encode',
    'expand',
    'g',
    'ge',
    'gen',
    'gl',
    'global',
    'gsort',
    'input',
    'ipolate',
    'iskoegp',
    'la',
    'lab',
    'label',
    'local',
    'macro',
    'mat',
    'matmap',
    'matrix',
    'mi',
    'mkmat',
    'moreobs',
    'move',
    'mvdecode',
    'mvencode',
    'notes',
    'numlabel',
    'omscore',
    'order',
    'recast',
    'recode',
    'recode01',
    'ren',
    'rename',
    'renvars',
    'replace',
    'reshape',
    'revrs',
    'scalar',
    'sencode',
    'set',
    'setx',
    'sort',
    'split',
    'svmat',
    'tempname',
    'tempvar',
    'tostring',
    'tsfill',
    'wls0',
    'xi',
    'xpose',
    'ztp',
]

# is something like fitstat regression or summarize?

regression = [
    'anova',
    'biprobit',
    'boottest',
    'brant',
    'btscs',
    'clogit',
    'cmp',
    'constraint',
    'countfit',
    'DCdensity',
    'edvreg',
    'estsimp',
    'fitstat',
    'gllamm',
    'glm',
    'gologit2',
    'hettest',
    'impute',
    'indireff',
    'indireffhat',
    'interflex',
    'ivprobit',
    'ivreg',
    'ivreg2',
    'lincom',
    'listcoef',
    'lrtest',
    'melogit',
    'mixed',
    'ml',
    'mleval',
    'mlogit',
    'mlogtest',
    'mlsum',
    'mprobit',
    'nbreg',
    'neologit',
    'nestreg',
    'ologit',
    'omodel',
    'oprobit',
    'poisson',
    'pre',
    'probit',
    'prgen',
    'prvalue',
    'psmatch2',
    'pscore',
    'pstest',
    'rc_spline',
    'rd',
    'rdrobust',
    'reghdfe',
    'regsave',
    'relogit',
    'relogitll'
    'rivtest',
    'rollreg',
    'sartsel', #?
    'simqi',
    'stcox',
    'sumqi',
    'suest',
    'test',
    'testparm',
    'two_side',
    'var',
    'varganger',
    'varsoc',
    'vif',
    'xtbond2',
    'xtgee',
    'xtivreg2',
    'xtlogit',
    'xtmelogit',
    'xtmixed',
    'xtnbreg',
    'xtprobit',
    'zinb',
]

# dfuller, gcause as identification?

summarize = [
    'adjust',
    'alpha',
    'bsample',
    'cem',
    'centfile',
    'codebook',
    'codebookout',
    'corr',
    'correl',
    'correlate',
    'count',
    'cumul',
    'des',
    'desc',
    'dfuller',
    'diff',
    'est',
    'estadd',
    'estat',
    'estimates',
    'estpost',
    'eststo',
    'factor',
    'factormat',
    'fprank',
    'gcause',
    'genmatch',
    'hist',
    'kap',
    'kpss',
    'levelsof',
    'margins',
    'mcc',
    'mchange',
    'mean',
    'mfx',
    'mkcorr',
    'nlcom',
    '_pctile',
    'pctile',
    'permute',
    'polychoric',
    'predict',
    'prop',
    'proportion'
    'prtest',
    'prtesti',
    'pwcorr',
    'ranksum',
    'roctab',
    'robvar',
    'rotate',
    'signrank',
    'signtest',
    'stci',
    'sts',
    'su',
    'sum',
    'summ',
    'summarize',
    'survwgt',
    'tab1',
    'tabi',
    'table',
    'tabstat',
    'tabstatmat',
    'tetrachoric',
    'tssmooth',
    'ttest',
    'ttesti',
    'unique',
    'univar',
    'vallist',
    'wntestq',
    'xtfisher',
    'xtile',
    'xtsum',
    'xttab',
    'zandrews',
]

# what is the difference between summarize and visualization?

visualization = [
    'catplot',
    'ciplot',
    'coefplot',
    'combomarginsplot',
    'di',
    'disp',
    'display',
    'eclplot',
    'esta',
    'esttab',
    'estout',
    'grc1leg',
    'histogram',
    'line',
    'list',
    'loadingplot',
    'lply',
    'marginsplot',
    'mdesc',
    'gr',
    'gr_edit',
    'graph',
    'grinter',
    'outreg,',
    'outtable',
    'outtex,'
    'plotfds',
    'psgraph',
    'rdplot',
    'scatter',
    'screeplot',
    'serbarr',
    'spmap',
    'stcurve',
    'sutex',
    'sutex2',
    'tabout',
    'title',
]