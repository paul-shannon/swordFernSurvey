tbl <- read.table(f, sep="\t", header=TRUE, comment="", quote="")
dim(tbl)
colnames(tbl)
fernCount <- tbl$healthyFernCount +  tbl$sickOrDeadFernCount
tbl$fernCount <- fernCount

#----------------------------------------
# create new variable, north
#----------------------------------------

x <- tbl$aspect
length(x)
west <- which(x>180)
east <- which(x <= 180)
length(west)
length(east)
north <- x
north[west] <- x[west] - 180
north[east] <- 180 - north[east]
tbl$northerly <- north

# take a look
data.frame(orig=x, fixed = north)
coi <- c("slope", "elevation", "northerly", "aspect", "area", "canopyDensity",  "healthyFernCount", "sickOrDeadFernCount", "dead.Class.1", "dead.Class.2", "dead.Class.3", "dead.Class.4", "mortality", "fernCount")
coi <- c("slope", "elevation", "northerly", "mortality", "aspect", "area", "canopyDensity",  "fernCount", "healthyFernCount", "sickOrDeadFernCount")
plot(tbl[, coi])


library(ggplot2)
data(mtcars)

r <- round(cor(mtcars$wt, mtcars$mpg), 2)
p <- cor.test(mtcars$wt, mtcars$mpg)$p.value
ggplot(mtcars, aes(y=wt, x=mpg)) +
  geom_point() +
  geom_smooth(method="lm", col="black") +
  annotate("text", x=20, y=4.5, label=paste0("r = ", r), hjust=0) +
  annotate("text", x=20, y=4.25, label=paste0("p = ", round(p, 3)), hjust=0) +
    theme_classic()

tbl2 <- subset(tbl, mortality > 0 & slope > 15)
tbl3 <- tbl2[, c("northerly", "elevation", "mortality")]


r <- round(cor(tbl3$northerly, tbl3$mortality), 2)
p <- cor.test(tbl3$northerly, tbl3$mortality)$p.value


ggplot(tbl3, aes(y=mortality, x=northerly)) +
  geom_point() +
  geom_smooth(method="lm", col="black") +
  annotate("text", x=20, y=1.03, label=paste0("r = ", r), hjust=0) +
  annotate("text", x=20, y=1.0, label=paste0("p = ", round(p, 3)), hjust=0) +
  annotate("text", x=100, y=1.03, label="mortality > 0.1 & slope > 15 degrees") +
  annotate("text", x=100, y=1.0, label="11/41 observations") +
    theme_classic() + ggtitle("Northerly Aspect & Mortality: a weak association")

