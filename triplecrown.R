
require(RColorBrewer)
palette(brewer.pal(6, "Set1"))
options(stringsAsFactors=FALSE)

belmont <- read.delim("belmont.tsv")
kentucky <- read.delim("kentucky.tsv")
preakness <- read.delim("preakness.tsv")

win <- c(1919, 1930, 1935, 1937, 1941,
         1943, 1946, 1948, 1973, 1977,
         1978)
fail <- c(1944, 1958, 1961, 1964, 1966,
          1968, 1969, 1971, 1979, 1981,
          1987, 1989, 1997, 1998, 1999,
          2002, 2003, 2004, 2008)
attempt <- c(win, fail, 2014)
y <- c(rep(1, length(win)), rep(0, length(fail)), NA)

ix <- attempt > 1950
y <- y[ix]
attempt <- attempt[ix]


msecs <- function(str) {
    x <- sapply(strsplit(str, "[:.]"), function(l) {
            l <- as.numeric(l)
            l[1] * 60 * 100 + l[2] * 100 + l[3]
        })
    x
}

msecs.str <- function(x, msecs = FALSE) {
    mins <- floor(x / 100 / 60)
    secs <- floor(x / 100 - 60 * mins)
    ms <- x - 100 * (secs + 60 * mins)

    if (msecs) {
        sprintf("%d:%02d.%02d", mins, secs, ms)
    } else {
        sprintf("%d:%02d", mins, secs)
    }
}

kentucky.time <- msecs(kentucky[match(attempt, kentucky$Year), "Time"])
preakness.time <- msecs(preakness[match(attempt, preakness$Year), "Time"])
belmont.time <- msecs(belmont[match(attempt, belmont$Year), "Time"])
name <- kentucky[match(attempt, kentucky$Year), "Winner"]
year <- attempt


png("triplecrown.png")
par(las=1, mar=c(5, 5, 2, 2) + .1, xpd=FALSE)
plot(kentucky.time, preakness.time, t="n", axes=FALSE,
     xlab="Kentucky Derby Time",
     ylab="Preakness Stakes Time")
axis(1, at=axTicks(1), labels=msecs.str(axTicks(1)))
axis(2, at=axTicks(2), labels=msecs.str(axTicks(2)))
axis(3, at=axTicks(3), labels=FALSE)
axis(4, at=axTicks(4), labels=FALSE)
usr <- par("usr")
abline(v=seq(usr[1], usr[2], length.out=4)[2:3], col="gray")
abline(h=seq(usr[3], usr[4], length.out=4)[2:3], col="gray")
box()

points(kentucky.time[y == 1], preakness.time[y == 1], col=2, pch=16)
points(kentucky.time[y == 0], preakness.time[y == 0], col=1, pch=16)
points(kentucky.time[is.na(y)], preakness.time[is.na(y)], col=3, pch=16)

ix <- y == 1 | is.na(y)
par(xpd=TRUE)
#text(kentucky.time[ix], preakness.time[ix],
#     name[ix], adj=c(0.5, -0.25), cex=.8)
text(kentucky.time[ix], preakness.time[ix],
     year[ix], adj=c(-0.25, 0), cex=.8)
par(xpd=FALSE)

legend("topleft", legend=c("Triple Crown Winner", "Failed Attempt"), col=c(2,1), pch=16,
       horiz=FALSE, inset=.025, bty="o", bg="white")
dev.off()


#x <- 0.5 * (kentucky.time + preakness.time)
#o <- order(x)
#col <- rep(1, length(x))
#col[y == 1] <- 2
#col[y == 0] <- 1
#col[is.na(y)] <- 3
#plot(seq_along(o), x[o], col=col, pch=16)
