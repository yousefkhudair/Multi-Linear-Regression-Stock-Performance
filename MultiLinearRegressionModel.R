
#Needed Packages
library(MASS)
library(readxl)
library(leaps)
library(caret)

#Reading File
allperiods <- read_excel("stock portfolio performance data set.xlsx", sheet = "all period", col_names = TRUE, skip = 1)

########### Model 1 ############
attributes(allperiods)

#Variables for Linear Regression
y1= allperiods$`Annual Return...8`
x1= allperiods$`Large Market Value`
x2= allperiods$`Total Risk...17` 
x3= allperiods$`Large S/P`
x4= allperiods$`Excess Return...9` # Offers an R-Squared of .9736 vs ##the current .4635 

#Part 1 & 2 - Linear Regression Model
model1 <- lm(y1~x1+x2+x3)

summary(model1) #(Figure 2.1)

#Checking Assumptions for linear Regression (Figure 2.2)
par(mfrow = c(2,2)) 
plot(model1)


# Part 3 - ANOVA Table
anova(model1)

anova(lm(y1~1,data=allperiods),model1) #Gives us the SSE SSR and SST 
#SSE = 0.02235 SSR = 0.025841 SST= (SSE+SSR)= 0.048191

#Part 4 
# F critical value given alpha=0.05
qf(0.95,3,59)
# output: 2.760767

# p-value of F test
1-pf(16.99,df1= 3,df2=59)
# output: 4.533282e-08

#Part 5
#Does Removing Large S/P increase error in the model and hence a decrease in the predictive power of the model?

#Original Model (Model 1): lm(y1~x1+x2+x3)
#Reduced Model (Model 2): lm(y1~x1+x2)

model2 <- lm(y1~x1+x2)

anova(model2, model1)

########### Model 2 ############

attach(allperiods)
names(allperiods)
class(`Abs. Win Rate...12`)
`Abs. Win Rate...12`[1:10]

# Creating categories of A=<.57 B= .57-.64 C= .64-.71 D=.71+

CatWin.Rate <- cut(`Abs. Win Rate...12`, breaks=c(0,.57,.64,.71,1), labels=c("A","B","C","D"))

CatWin.Rate[1-10]

y1= allperiods$`Annual Return...8`
x1= CatWin.Rate
x2= allperiods$`Excess Return...9`
mod1 <- lm(y1~x1 + x2 + x1:x2)
summary(mod1)

mod2 <- lm(y1~x1 + x2)
summary(mod2)

# ANOVA
anova(mod2)
anova(update(mod2,~1),mod2)
