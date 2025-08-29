tbl <- read.table("ferns.tsv", sep="\t", header=TRUE)
# chi-square test needs a contingency table like this:
#       alive dead
#  east     3   18
#  west    18    0
xtab <- table(tbl$sector, tbl$status)
chisq.test(xtab)$p.value  # 4.88710579479e-07




