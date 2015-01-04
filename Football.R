library(Rglpk)
# http://stackoverflow.com/questions/15147398/optimize-value-with-linear-or-non-linear-constraints-in-r

setwd("/Users/dphnrome/Documents/Git/Fantasy_Football_Optimization")

d <- read.csv("./Projected Points.csv") # load data
#d <- d[which(d$Position != "DST"),] # Filter out teams

# number of variables
num.players <- length(d$Player) 

# objective:
f <- d$Projected.Points
# the variable are booleans
var.types <- rep("B", num.players)
# the constraints
# Leaving out flex for now
A <- rbind(as.numeric(d$Position == "QB"), # num QB
           as.numeric(d$Position == "RB"), # num RB
           as.numeric(d$Position == "WR"), # num WR
           as.numeric(d$Position == "TE"), # num TE
           as.numeric(d$Position == "DST"), # num DST
           d$Salary)                    # total cost

dir <- c("==",
         "==",
         "==",
         "==",
         "==",
         "<=")

b <- c(1,
       2,
       3,
       2, #Added a TE as "flex" player
       1,
       50000)


sol <- Rglpk_solve_LP(obj = f, mat = A, dir = dir, rhs = b,
                      types = var.types, max = TRUE)
sol

d$Player[sol$solution == 1]

myTeam <- d[which(sol$solution == 1),]