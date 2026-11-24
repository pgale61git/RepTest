DROP TABLE IF EXISTS mcr_acctg_trans_summ
\p\g
CREATE TABLE mcr_acctg_trans_summ (
	transno		integer not null not default,
	br_code		varchar(5) not null not default,
	acct_code	char(8)	not null not default,
	amount		money not null not default,
	drcr		char(1) not null not default )
\p\g
MODIFY mcr_acctg_trans_summ TO BTREE UNIQUE ON transno, br_code, acct_code, drcr 
\p\g
ALTER TABLE mcr_acctg_trans_summ ADD CONSTRAINT mcr_acctg_trans_summ_pk PRIMARY KEY (transno, br_code, acct_code, drcr)
\p\g

