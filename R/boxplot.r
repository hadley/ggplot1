# Weighted box plot calculats
# 
# @keyword internal 
# @alias boxplot.weighted
# @alias boxplot_stats_weighted
boxplot.weighted.formula <- function(formula, data = NULL, ..., weights=1, subset, na.action = NULL) {
    if (missing(formula) || (length(formula) != 3)) 
        stop("'formula' missing or incorrect")
    m <- match.call(expand.dots = FALSE)
    m$weights <- NULL
    if (is.matrix(eval(m$data, parent.frame()))) 
        m$data <- as.data.frame(data)
    m$... <- NULL
    m$na.action <- na.action
    m[[1]] <- as.name("model.frame")
    mf <- eval(m, parent.frame())
    response <- attr(attr(mf, "terms"), "response")

    boxplot.weighted(split(mf[[response]], mf[-response]), weights=split(weights, mf[-response]), ...)
}

boxplot.weighted <- 
function (x, weights=1, ..., range = 1.5, width = NULL, varwidth = FALSE, 
    notch = FALSE, outline = TRUE, names, plot = TRUE, border = par("fg"), 
    col = NULL, log = "", pars = list(boxwex = 0.8, staplewex = 0.5, 
        outwex = 0.5), horizontal = FALSE, add = FALSE, at = NULL) 
{

    args <- list(x, ...)
    namedargs <- if (!is.null(attributes(args)$names)) 
        attributes(args)$names != ""
    else rep(FALSE, length.out = length(args))
    pars <- c(args[namedargs], pars)
    groups <- if (is.list(x)) 
        x
    else args[!namedargs]
    if (0 == (n <- length(groups))) 
        stop("invalid first argument")
    if (length(class(groups))) 
        groups <- unclass(groups)
    if (!missing(names)) 
        attr(groups, "names") <- names
    else {
        if (is.null(attr(groups, "names"))) 
            attr(groups, "names") <- 1:n
        names <- attr(groups, "names")
    }
    cls <- sapply(groups, function(x) class(x)[1])
    cl <- if (all(cls == cls[1])) 
        cls[1]
    else NULL

    for (i in 1:n) groups[i] <- list(boxplot_stats_weighted(unclass(groups[[i]]), range, weights=weights[[i]]))
    stats <- matrix(0, nr = 5, nc = n)
    conf <- matrix(0, nr = 2, nc = n)
    ng <- out <- group <- numeric(0)
    ct <- 1
    for (i in groups) {
        stats[, ct] <- i$stats
        conf[, ct] <- i$conf
        ng <- c(ng, i$n)
        if ((lo <- length(i$out))) {
            out <- c(out, i$out)
            group <- c(group, rep.int(ct, lo))
        }
        ct <- ct + 1
    }
    if (length(cl) && cl != "numeric") 
        oldClass(stats) <- cl
    z <- list(stats = stats, n = ng, conf = conf, out = out, 
        group = group, names = names)
    if (plot) {
        bxp(z, width, varwidth = varwidth, notch = notch, log = log, 
            border = border, boxfill = col, pars = pars, outline = outline, 
            horizontal = horizontal, add = add, at = at)
        invisible(z)
    }
    else z
}


boxplot_stats_weighted <- function (x, coef = 1.5, weights=1, do.conf = TRUE, do.out = TRUE) {
	nna <- !is.na(x)

	if (length(unique(weights)) != 1) {
		if (!require(quantreg, quietly=TRUE)) stop("You need to install the quantreg package for weighted boxplots!")
		stats <- as.numeric(coef(rq(x ~ 1, weight = weights, tau=c(0, 0.25, 0.5, 0.75, 1))))
		n <- sum(weights[nna])
	} else {
		stats <- as.numeric(quantile(x, c(0, 0.25, 0.5, 0.75, 1)))
		n <- sum(nna)
	}

	iqr <- diff(stats[c(2, 4)])
	if (coef < 0) stop("'coef' must not be negative")
	if (coef == 0) {
		do.out <- FALSE
	} else {
		out <- x < (stats[2] - coef * iqr) | x > (stats[4] + coef * iqr)
		if (any(out[nna])) stats[c(1, 5)] <- range(x[!out], na.rm = TRUE)
	}
	conf <- if (do.conf) stats[3] + c(-1.58, 1.58) * iqr/sqrt(n)
	list(stats = stats, n = n, conf = conf, out = if (do.out) x[out & nna] else numeric(0))
}