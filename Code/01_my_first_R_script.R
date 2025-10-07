# in "Name your file" I just type /newname und es wird direkt übernommen
# Now this is an R document (not md like the first one)

-------------------------------------------------------------------------

## Introduction to R

# define first objects
naza <- 2+3
marco <- 7+4
naza + marco

# vale counted leopards in Mongolia
vale <- c(5,10,13,20,30)  # c for concatenate

# elia counted plants
elia <- c(2,5,10,40,70)

plot(elia, vale,          # x,y  (leopards dependent on plants)
     pch=19, col="blue",  # pch = symbol full circle = "point character"
     cex = 2)             # cex = size of symbol
                          

plot(elia, vale,          
     pch=19, col="blue",  
     cex = 2,
     xlab = "Forest biomass", ylab = "Leopard abundance") 


