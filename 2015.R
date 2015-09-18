library(readxl)
library(Rglpk)

# The number of RBs >= 2
# The number of RBs <= 3
# The number of WRs >= 3
# The number of WRs <= 4
# The number of TEs >= 1
# The number of TEs <= 2
# The number of RBs + WRs + TEs == 7

final <- read_excel("/Users/DHadley/Github/Fantasy_Football_Optimization/2015_Week1.xlsx")

final$position <- gsub(".*\\((.*)\\,.*", "\\1", final$layer)


# number of variables
num.players <- length(final$layer) 

# objective:
obj <- final$Value
# the variables are booleans:
# Either yes we select, or no we don't
var.types <- rep("B", num.players)
# the constraints
matrix <- rbind(as.numeric(final$position == "QB"), # num QB
                as.numeric(final$position == "RB"), # num RB
                as.numeric(final$position == "RB"), # num RB
                as.numeric(final$position == "WR"), # num WR
                as.numeric(final$position == "WR"), # num WR
                as.numeric(final$position == "TE"), # num TE
                as.numeric(final$position == "TE"), # num TE
                as.numeric(final$position %in% c("RB", "WR", "TE")),  # Num RB/WR/TE
                # as.numeric(final$position == "DEF"),# num DEF
                final$Cost)                       # total cost

direction <- c("==",
               ">=",
               "<=",
               ">=",
               "<=",
               ">=",
               "<=",
               "==",
               # "==",
               "<=")

rhs <- c(1, # Quartbacks
         2, # RB Min
         3, # RB Max
         3, # WR Min
         4, # WR Max
         1, # TE Min
         2, # TE Max
         7, # RB/WR/TE
         # 1, # Defense
         47000)                # By default, you get 50K to spend, so leave this number alone. 

sol <- Rglpk_solve_LP(obj = obj, mat = matrix, dir = direction, rhs = rhs,
                      types = var.types, max = TRUE)
sol

optimalTeam <- final[sol$solution==1,]
