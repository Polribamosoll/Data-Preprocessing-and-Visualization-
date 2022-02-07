
############################## Learning Diary 2 - Basic Data Analysis and Visualization ##############################

### We will work with the default iris dataset
iris
head(iris, 10)


### Summary

summary(iris)
str(iris)


### Graphical representation

plot(iris)


### Correlation matrix

#install.packages("stats")
library("stats")
#install.packages("ggcorrplot")
library(ggcorrplot) 

corr_matrix_iris <- cor(iris[,1:4], use = "complete.obs") # We will only use complete observations
round(corr_matrix_iris, 2)


### We can also represent the correlation matrix graphically

ggcorrplot(corr_matrix_iris, method = 'circle', type = 'lower', lab = TRUE) +
  ggtitle("Iris's database correlogram for the numeric variables") +
  labs(x = "", y = "", color = "") +
  theme(plot.title = element_text(hjust = 0.24))

#install.packages("psych")
library(psych)
pairs.panels(iris[,1:5], method = "pearson", 
             hist.col = "#00AFBB", density = TRUE, # show density plots 
             ellipses = TRUE # show correlation ellipses 
             )


### We can check if there is NA's in our data
colSums(is.na(iris))
any(is.na(iris)) # There are few NA's in our data, but we will create some more in order to treat them.


# We will now create some missings in order to impute them with their mean value.

#install.packages("missForest")
library("missForest")
iris.mis <- prodNA(iris[,1:4], noNA = 0.15) # Now we have a 15% of missing data in iris.mis dataframe, let's impute them.
colSums(is.na(iris.mis))
means <-  colMeans(iris.mis[1:4], na.rm=T) #The last variable is a factor, so we will not introduce any NA.

for(j in 1:4){
 for(i in 1:150){
  if(is.na(iris.mis[i,j])){
    iris.mis[i,j] <- means[j]
    }
  }
}
colSums(is.na(iris.mis)) # No missings in our data.

### Outliers

titles <- c("Sepal Length", "Sepal Width", "Petal Length", "Petal Width", "Species")
par(mfrow=c(2,3))
for(j in 1:5){
  boxplot(iris[,j], col=23, main = titles[j])
}

# Our dataframe doesn't seem to have outliers in any of the variables.
quantile(iris$Sepal.Length)
quantile(iris$Sepal.Width)
quantile(iris$Petal.Length)
quantile(iris$Petal.Width)


### Mean removal

column_means <- colMeans(iris[,1:4])
center_matrix <- matrix(rep(column_means, nrow(iris)), nrow=nrow(iris),ncol=ncol(iris), byrow = TRUE)
centered_iris <- iris[,1:4] - center_matrix     # Subtract column means

print(head(centered_iris))


### Data scaling

column_sds <- apply(centered_iris, MARGIN = 2, FUN = sd)
print(column_sds) 
scale_matrix <- matrix( rep(column_sds, nrow(iris)), nrow=nrow(iris), ncol=ncol(iris), byrow = TRUE)    
centered_scaled_iris <- centered_iris/scale_matrix
summary(centered_scaled_iris)


### Data scaling and mean removal with a function

auto_scaled_iris <- scale(iris[,1:4],              # Numeric data object
                          center=TRUE,        # Center the data?
                          scale=TRUE)         # Scale the data?

summary(auto_scaled_iris)


# Useful graphical tools
auto_scaled_iris <- as.data.frame(auto_scaled_iris)

plot(auto_scaled_iris$Sepal.Length, auto_scaled_iris$Petal.Length, pch = auto_scaled_iris$speciesID, col = rainbow(3)[iris$Species], main="Sepal Length vs Petal Length", xlab = "Sepal Length", ylab = " Petal Length")

plot(auto_scaled_iris$Sepal.Width, auto_scaled_iris$Petal.Width, pch = auto_scaled_iris$speciesID, col = rainbow(3)[iris$Species], main="Sepal Width vs Petal Width", xlab = "Sepal Width", ylab = " Petal Width")

ggplot(data = iris) +
  aes(x = Species, y = Sepal.Length, color = Species) +
  geom_boxplot() +
  geom_jitter(position = position_jitter(0.2))

ggplot(data = iris) +
  aes(x = Petal.Length, fill = Species) + 
  geom_density( alpha = 0.3)

ggplot(data = iris, aes(x=Sepal.Length, y=Sepal.Width)) +          # Initialize plot 
  geom_point(aes(color = Species), alpha = 0.9) 




