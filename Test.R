# We are going to solve:
# maximize f'x subject to A*x <dir> b
# where:
#   x is the variable to solve for: a vector of 0 or 1:
#     1 when the player is selected, 0 otherwise,
#   f is your objective vector,
#   A is a matrix, b a vector, and <dir> a vector of "<=", "==", or ">=",
#   defining your linear constraints.

name <- c("Aaron Rodgers","Tom Brady","Arian Foster","Ray Rice","LeSean McCoy","Calvin Johnson","Larry Fitzgerald","Wes Welker","Rob Gronkowski","Jimmy Graham")

pos <- c("QB","QB","RB","RB","RB","WR","WR","WR","TE","TE")

pts <- c(167, 136, 195, 174, 144, 135, 89, 81, 114, 111) 

risk <- c(2.9, 3.4, 0.7, 1.1, 3.5, 5.0, 6.7, 4.7, 3.7, 8.8) 

cost <- c(60, 47, 63, 62, 40, 60, 50, 35, 40, 40) 

mydata <- data.frame(name, pos, pts, risk, cost) 

# number of variables
num.players <- length(name)
# objective:
f <- pts
# the variable are booleans
var.types <- rep("B", num.players)
# the constraints
A <- rbind(as.numeric(pos == "QB"), # num QB
           as.numeric(pos == "RB"), # num RB
           as.numeric(pos == "WR"), # num WR
           as.numeric(pos == "TE"), # num TE
           diag(risk),              # player's risk
           cost)                    # total cost

dir <- c("==",
         "==",
         "==",
         "==",
         rep("<=", num.players),
         "<=")

b <- c(1,
       2,
       2,
       1,
       rep(6, num.players),
       300)

library(Rglpk)
sol <- Rglpk_solve_LP(obj = f, mat = A, dir = dir, rhs = b,
                      types = var.types, max = TRUE)
sol

name[sol$solution == 1]
