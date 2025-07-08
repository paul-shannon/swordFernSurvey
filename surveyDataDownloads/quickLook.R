f <- "survey-08jul-2.tsv"
tbl <- read.table(f, sep="\t", comment="", header=TRUE)
print(dim(tbl))

