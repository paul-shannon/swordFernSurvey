f <- "uwObs-14aug.tsv"
tbl <- read.table(f, sep="\t", nrow=-1, header=TRUE, quote="")
dim(tbl)
colnames(tbl)
coi <- c(2:8,11,12,13,14:20)

as.data.frame(t(tbl[3, coi]))

as.data.frame(t(tbl[grep("Larrabee", tbl$site), 1:5]))

