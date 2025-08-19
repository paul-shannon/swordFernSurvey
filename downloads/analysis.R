tbl <- read.table("uwObs.tsv", sep="\t", comment="", header=TRUE)
tbl$fernCount <- fernCount
tbl$northSlope <- (tbl$aspect > 300  | tbl$aspect < 60) & tbl$slope > 20
tbl$northXslope <- with(tbl, northerly * slope^2)
tbl$northPslope <- with(tbl, northerly + slope)
tbl2 <- subset(tbl, mortality > 0.4)
dim(tbl2)  # 31 27
fit <- lm(mortality ~ 0 + northXslope, data=tbl2)
summary(fit)

#                 Estimate   Std. Error t value   Pr(>|t|)
# northXslope 0.0002104271 0.0000439301 4.79004 4.2124e-05 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
# Residual standard error: 0.4857107 on 30 degrees of freedom
# Multiple R-squared:  0.433369,	Adjusted R-squared:  0.4144813
# F-statistic: 22.94451 on 1 and 30 DF,  p-value: 4.212448e-05

