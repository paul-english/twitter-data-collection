# Used for the subspaceplot on our covariance matrix
# install.packages('MCMCglmm')

Tweets = read.csv("twitter_data.csv", col.names= c("created_at", "id", "user_id", "followers_count", "friends_count", "listed_count", "favourites_count", "statuses_count", "retweet_count", "latitude", "longitude"))

finite_values = tweets[c("followers_count", "friends_count", "listed_count", "favourites_count", "statuses_count", "retweet_count", "latitude", "longitude")]

# Find followers and tweets by id
boxplot(split(tweets$followers_count,tweets$user_id),main='Followers per user')
boxplot(split(tweets$statuses_count,tweets$user_id),main='Tweets per user')

# Boxplot for all columns
png('twitter-full-boxplot.png')
boxplot(finite_values)
dev.off()

# Create a scatterplot matrix of the entire data frame
png('twitter-scatterplot-matrix.png')
plot(finite_values)
abline(lm(finite_values))
dev.off()

# Remove retweet_count, all zeros
finite_values = tweets[c("followers_count", "friends_count", "listed_count", "favourites_count", "statuses_count", "latitude", "longitude")]

# Remove outliers temporarily so we can see a bit closer
# There's no reason to remove outliers other than to look closer at the boxplot
remove_outliers <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
  H <- 1.5 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}

# All of our columns together, with outliers removed
finite_values.no_outliers <- lapply(finite_values, FUN=remove_outliers)
png('twitter-no-outliers-boxplot.png')
boxplot(finite_values.no_outliers)
dev.off()

# Finding the covariances of our data frame
# http://stat.ethz.ch/R-manual/R-patched/library/stats/html/cor.html
finite_values.covariance <- cov(finite_values)

#                  followers_count friends_count listed_count favourites_count
# followers_count     2.139340e+07  9.829743e+05 6.104582e+04     3.323989e+05
# friends_count       9.829743e+05  9.444754e+05 1.987711e+04     1.273757e+05
# listed_count        6.104582e+04  1.987711e+04 1.809905e+03     1.421300e+03
# favourites_count    3.323989e+05  1.273757e+05 1.421300e+03     8.980851e+06
# statuses_count      2.153423e+07  2.243561e+07 3.678569e+05     2.396113e+07
# retweet_count       0.000000e+00  0.000000e+00 0.000000e+00     0.000000e+00
# latitude            2.043679e+01  7.519972e+00 2.421415e-01     2.041955e+01
# longitude           1.269277e+01  3.330558e+00 1.964359e-01    -9.829240e+00
#                  statuses_count retweet_count     latitude   longitude
# followers_count    2.153423e+07             0  20.43678561 12.69276512
# friends_count      2.243561e+07             0   7.51997204  3.33055814
# listed_count       3.678569e+05             0   0.24214145  0.19643594
# favourites_count   2.396113e+07             0  20.41955040 -9.82924043
# statuses_count     8.297425e+08             0 253.86287390 98.66483063
# retweet_count      0.000000e+00             0   0.00000000  0.00000000
# latitude           2.538629e+02             0   0.08942453  0.01814188
# longitude          9.866483e+01             0   0.01814188  0.04083157

# Covariance plot
# make sure you install the 'MCMCglmm' package
#library(rgl)
#plotsubspace(finite_values.covariance)
#snapshot3d('twitter-covariance-subspace.png')

# Eigenvectors & Values
eigen(finite_values.covariance)

# Principal Component Analysis
# http://stat.ethz.ch/R-manual/R-patched/library/stats/html/princomp.html
finite_values.pca <- princomp(finite_values, cor = FALSE)

# Call:
# princomp(x = finite_values)
# 
# Standard deviations:
#       Comp.1       Comp.2       Comp.3       Comp.4       Comp.5       Comp.6 
# 2.883664e+04 4.564396e+03 2.882324e+03 5.447960e+02 3.566943e+01 3.087365e-01 
#       Comp.7       Comp.8 
# 1.864445e-01 0.000000e+00 
# 
#  8  variables and  11994 observations.


# Creating a basic plot
png('twitter-pca-plot.png')
plot(finite_values.pca)
dev.off()

# Creating a biplot
png('twitter-pca-biplot.png')
biplot(finite_values.pca)
dev.off()


