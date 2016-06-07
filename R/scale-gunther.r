# Create blue-yellow colour scheme
# Create a colour scheme that varies continuousy along one ray of a colour space
# 
# @arguments number of colours to produce
# @keyword hplot 
# @keyword internal 
# @references Contrbuted by Günther Sawitzki, \url{http://www.statlab.uni-heidelberg.de/people/gs}
blueyellow2 <- function(n) {
	q  <- ((0:n)/n - 0.5) *2
	qq <- (q*q*sign(q) + 1)/2
	q1 <- 1 - (q*q + 1)/2
	rgb(qq+q1,qq + q1, 1 - qq + q1)
}


# Tail colour
# Colour scheme that emphasizes differences in tails.
# 
# @references Contrbuted by Günther Sawitzki, \url{http://www.statlab.uni-heidelberg.de/people/gs}
# @arguments number of colours to produce
# @arguments quantile for first colour
# @arguments quantile for second colour
# @arguments quantile for third colour, defaults to symmetric
# @arguments quantile for fourth colour, defaults to symmetric
# @keyword hplot 
# @keyword internal
tailcolor <- function(n=100, q1=0.10, q2=0.25, q3 = 1-q2,q4 = 1-q1) {
	cut(1:n, n*c(q1,q2,q3,q4), labels=FALSE)
	colours <- c(rgb(0, 1, 0), rgb(0.8, 1, 0), rgb(0.95, 0.95, 0.95), rgb(1, 0.8, 0), rgb(1, 0, 0))
	colours[cut]
	
	#for (i in 1:n) {
	#	
	#	if (i<n1) g[i]<-1 #green
	#	else
	#       if (i<n2) {r[i]<-0.8; g[i]<-1} #yellow green
	#       else
	#               if (i<n3) {r[i]<-0.95; b[i]<-0.95; g[i]<-0.95} #lt grey
	#               else
	#               if (i<n4) {r[i]<-1; g[i]<-0.8} #yellow red
	#               else r[i]<- 1 #red
	#}
	#rgb(r,g,b)
}
