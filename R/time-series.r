# Time scale takes standard numeric scale (in seconds since epoch)
# and displays nice time intervals instead
# 
# @keyword internal
# @alias  position_time
# @alias breaks.time
# @alias labels.time
# @alias range.time
# @alias time_scale
pstime <- function(plot = .PLOT, variable="x", name="", transform=trans_none, range=c(NA,NA), expand=c(0.05, 0), by="weeks") {
	add_scale(plot,  position_time(variable=variable, name=name, expand=expand, transform=transform, range=range, by=by) )
}

position_time <- function(variable="x", name="", transform=trans_none, range=c(NA,NA), expand=c(0, 0.5), by="weeks") {
	sc <- scale_continuous(variable=variable, expand=expand, name=name, transform=transform, range=range, by=by)
	class(sc) <- c("time", "position", class(sc))
	sc
}

breaks.time <- function(scale, ...) {
	sdates <- seq.dates(scale$range[1], scale$range[2], by=scale$by)
	scale$transform[[1]](as.numeric(sdates))
}


labels.time <- function(object, ...) {
	as.character(seq.dates(object$range[1], object$range[2], by=object$by))
}

range.time <- function(scale, ...) 
	expand_range(scale$range, scale$expand[1], scale$expand[2])

	# For an time axis (ie. given two dates indicating the start and end of the time series), you want to be able to specify:
	# 
	#   * the interval between ticks.  Should either specificy desired number of tick marks or a string (second, minute, hour, day, week, month, quarter, year + all plurals) and multiplier (usually integer, always positive) giving the interval between ticks.  Default should be 5.  (and needs to use precisely those dates, and not assume that (eg) a month = 31 days) - seq.POSIXct
	# 
	#  * the position of the first tick, as a date/time.  This should default to a round number of intervals, before first the data point if necessary.
	# 
	#  * format string which controls how the date is printed (should default to displaying just enough to distinguish each interval)
	# 
	#  * threshold for displaying last tick mark: if the last date point is > threshold * interval

time_scale <- function(min, max, interval = 5, start=min, threshold) {
	
	if ((max - last) / interval > threshold) last <- last + interval
	
}