#################################################################
##                                                             ##
##   (c) Adeline Marinho <adelsud6@gmail.com>                  ##
##                                                             ##
##       Image Processing Division                             ##
##       National Institute for Space Research (INPE), Brazil  ##
##                                                             ##
##                                                             ##
##   R script with thirteen Allen's relationships              ##
##                                                             ##
##                                             2017-06-23      ##
##                                                             ##
##  J. F. Allen.  Towards a general theory of action and       ##
##  time. Artificial Intelligence, 23(2): 123--154, 1984.      ##
##                                                             ##
#################################################################


# ALLEN'S INTERVAL ALGEBRA
# Thirteen basic relation
#
# before        (end_I < start_J) -> precedes
# after         (start_I > end_J) -> preceded by
# meets         (end_I == start_J)
# met by        (end_J == start_I)
# overlaps      (start_I < start_J) & (end_I > start_J) & (end_I < end_J)
# overlapped by (end_I > start_J) & (start_I < end_J) & (end_I > end_J)
# starts        (start_I == start_J) & (end_I < end_J)
# started by    (start_I == start_J) & (end_I > end_J)
# during        (start_I > start_J) & (end_I < end_J))
# contains      (start_I < start_J) & (end_I > end_J)
# finishes      (start_I > start_J) & (end_I == end_J)
# finished by   (start_I < start_J) & (end_I == end_J)
# equals        (start_I == start_J) & (end_I == end_J)

# Derivates relations
# in            (during(first_interval, second_interval) | starts(first_interval, second_interval) 
#                   | finishes(first_interval, second_interval))
# follows       (meets(first_interval, second_interval) | before(first_interval, second_interval))
# precedes      (met_by(first_interval, second_interval) | after(first_interval, second_interval))


#' @title Allen Relation Before
#' @name lucC_relation_before
#' @aliases lucC_relation_before
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Provide an Allen's interval relation to classified time series data. 
#' And return a logical value if an interval is TRUE or FALSE
#' 
#' @usage lucC_relation_before(first_interval , second_interval)
#'  
#' @param first_interval  lucC_interval. An interval between two dates.
#' @param second_interval lucC_interval. An interval between two dates.
#' 
#' @keywords datasets
#' @return Logical value if interval are TRUE or FALSE
#' @importFrom lubridate is.interval int_standardize int_end int_start
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # create some examples of intervals
#' time1 <- lucC_interval("2011-09-01","2011-10-01")
#' time4 <- lucC_interval("2011-10-01","2011-11-01")
#' 
#' # Two interval I and J, with:
#' # I <- ("2011-08-15","2011-08-29")
#' # J <- ("2011-09-01","2011-10-01")
#' # end_I equals to the final value of the interval, I == "2011-08-29"
#' # start_I equals to the begin value of the interval, I == "2011-08-15"
#' # end_J equals to the final value of the interval, J == "2011-10-01"
#' # start_J equals to the begin value of the interval, J == "2011-09-01"
#' 
#' # Apply a relation 'before' (end_I < start_J)
#' lucC_relation_before(time1,time4)
#' 
#'            
#'}
#'

# 1. The '<' relation = lucC_relation_before
lucC_relation_before <- function (first_interval, second_interval) {
  # checking if first or second interval values are correct 
  stopifnot(c(lubridate::is.interval(first_interval), 
              lubridate::is.interval(second_interval)))
  
  first_interval <- lubridate::int_standardize(first_interval)
  
  second_interval <- lubridate::int_standardize(second_interval)
  
  lubridate::int_end(first_interval) < lubridate::int_start(second_interval)
}


#' @title Allen Relation After
#' @name lucC_relation_after
#' @aliases lucC_relation_after
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Provide an Allen's interval relation to classified time series data. And return a logical value if an interval is TRUE or FALSE
#' 
#' @usage lucC_relation_after(first_interval , second_interval)
#'  
#' @param first_interval  lucC_interval. An interval between two dates.
#' @param second_interval lucC_interval. An interval between two dates.
#' 
#' @keywords datasets
#' @return Logical value if interval are TRUE or FALSE
#' @importFrom lubridate is.interval int_standardize int_end int_start
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # create some examples of intervals
#' time1 <- lucC_interval("2011-09-01","2011-10-01")
#' time4 <- lucC_interval("2011-10-01","2011-11-01")
#' 
#' # Apply a relation 'after' (start_I > end_J)
#' lucC_relation_after(time4,time1)
#' 
#'}
#'

# 2. The '>' relation = lucC_relation_before
lucC_relation_after <- function (first_interval, second_interval) {
  stopifnot(c(lubridate::is.interval(first_interval), 
              lubridate::is.interval(second_interval)))
  
  first_interval <- lubridate::int_standardize(first_interval)
  
  second_interval <- lubridate::int_standardize(second_interval)
  
  lubridate::int_end(first_interval) > lubridate::int_start(second_interval)
}


#' @title Allen Relation Meets
#' @name lucC_relation_meets
#' @aliases lucC_relation_meets
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Provide an Allen's interval relation to classified time series data. And return a logical value if an interval is TRUE or FALSE
#' 
#' @usage lucC_relation_meets(first_interval , second_interval)
#'  
#' @param first_interval  lucC_interval. An interval between two dates.
#' @param second_interval lucC_interval. An interval between two dates.
#' 
#' @keywords datasets
#' @return Logical value if interval are TRUE or FALSE
#' @importFrom lubridate is.interval int_standardize int_end int_start
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # create some examples of intervals
#' time1 <- lucC_interval("2011-09-01","2011-10-01")
#' time3 <- lucC_interval("2011-10-01","2011-11-01")
#' 
#' # Apply a relation 'meets' (end_I == start_J)
#' lucC_relation_meets(time1,time3)
#' 
#'}
#'

# 3. The 'm' relation = lucC_relation_meets
lucC_relation_meets <- function (first_interval, second_interval) {
  stopifnot(c(lubridate::is.interval(first_interval), 
              lubridate::is.interval(second_interval)))
  
  first_interval <- lubridate::int_standardize(first_interval)
  
  second_interval <- lubridate::int_standardize(second_interval)
  
  lubridate::int_end(first_interval) == lubridate::int_start(second_interval)
}


#' @title Allen Relation Met By
#' @name lucC_relation_met_by
#' @aliases lucC_relation_met_by
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Provide an Allen's interval relation to classified time series data. And return a logical value if an interval is TRUE or FALSE
#' 
#' @usage lucC_relation_met_by(first_interval , second_interval)
#'  
#' @param first_interval  lucC_interval. An interval between two dates.
#' @param second_interval lucC_interval. An interval between two dates.
#' 
#' @keywords datasets
#' @return Logical value if interval are TRUE or FALSE
#' @importFrom lubridate is.interval int_standardize int_end int_start
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # create some examples of intervals
#' time1 <- lucC_interval("2011-09-01","2011-10-01")
#' time5 <- lucC_interval("2011-08-01","2011-09-01")
#' 
#' # Apply a relation 'met by' (end_J == start_I)
#' lucC_relation_met_by(time1,time5)
#' 
#'}
#'

# 4. The 'mi' relation = lucC_relation_met_by
lucC_relation_met_by <- function (first_interval, second_interval) {
  stopifnot(c(lubridate::is.interval(first_interval), 
              lubridate::is.interval(second_interval)))
  
  first_interval <- lubridate::int_standardize(first_interval)
  
  second_interval <- lubridate::int_standardize(second_interval)
  
  lubridate::int_end(second_interval) == lubridate::int_start(first_interval)
}



#' @title Allen Relation Overlaps
#' @name lucC_relation_overlaps
#' @aliases lucC_relation_overlaps
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Provide an Allen's interval relation to classified time series data. And return a logical value if an interval is TRUE or FALSE
#' 
#' @usage lucC_relation_overlaps(first_interval , second_interval)
#'  
#' @param first_interval  lucC_interval. An interval between two dates.
#' @param second_interval lucC_interval. An interval between two dates.
#' 
#' @keywords datasets
#' @return Logical value if interval are TRUE or FALSE
#' @importFrom lubridate is.interval int_standardize int_end int_start
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # create some examples of intervals
#' time1 <- lucC_interval("2011-09-01","2011-10-01")
#' time2 <- lucC_interval("2011-09-15","2011-11-01")
#' 
#' # Apply a relation 'overlaps' (start_I < start_J) & (end_I > start_J) & (end_I < end_J)
#' lucC_relation_overlaps(time1,time2)
#' 
#'}
#'

# 5. The 'o' relation = lucC_relation_overlaps
lucC_relation_overlaps <- function (first_interval, second_interval) {
  stopifnot(c(lubridate::is.interval(first_interval), 
              lubridate::is.interval(second_interval)))
  
  first_interval <- lubridate::int_standardize(first_interval)
  
  second_interval <- lubridate::int_standardize(second_interval)
  
  lubridate::int_start(first_interval) < lubridate::int_start(second_interval) & 
    lubridate::int_end(first_interval) > lubridate::int_start(second_interval) & 
    lubridate::int_end(first_interval) < lubridate::int_end(second_interval)
}


#' @title Allen Relation Overlapped By
#' @name lucC_relation_overlapped_by
#' @aliases lucC_relation_overlapped_by
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Provide an Allen's interval relation to classified time series data. And return a logical value if an interval is TRUE or FALSE
#' 
#' @usage lucC_relation_overlapped_by(first_interval , second_interval)
#'  
#' @param first_interval  lucC_interval. An interval between two dates.
#' @param second_interval lucC_interval. An interval between two dates.
#' 
#' @keywords datasets
#' @return Logical value if interval are TRUE or FALSE
#' @importFrom lubridate is.interval int_standardize int_end int_start
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # create some examples of intervals
#' time1 <- lucC_interval("2011-09-01","2011-10-01")
#' time6 <- lucC_interval("2011-08-15","2011-09-15")
#' 
#' # Apply a relation 'overlapped by' (end_I > start_J) & (start_I < end_J) & (end_I > end_J)
#' lucC_relation_overlapped_by(time1,time6)
#' 
#'}
#'

# 6. The 'oi' relation = lucC_relation_overlapped_by
lucC_relation_overlapped_by <- function (first_interval, second_interval) {
  stopifnot(c(lubridate::is.interval(first_interval), 
              lubridate::is.interval(second_interval)))
  
  first_interval <- lubridate::int_standardize(first_interval)
  
  second_interval <- lubridate::int_standardize(second_interval)
  
  lubridate::int_end(first_interval) > lubridate::int_start(second_interval) & 
    lubridate::int_start(first_interval) < lubridate::int_end(second_interval) & 
    lubridate::int_end(first_interval) > lubridate::int_end(second_interval)
}


#' @title Allen Relation Starts
#' @name lucC_relation_starts
#' @aliases lucC_relation_starts
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Provide an Allen's interval relation to classified time series data. And return a logical value if an interval is TRUE or FALSE
#' 
#' @usage lucC_relation_starts(first_interval , second_interval)
#'  
#' @param first_interval  lucC_interval. An interval between two dates.
#' @param second_interval lucC_interval. An interval between two dates.
#' 
#' @keywords datasets
#' @return Logical value if interval are TRUE or FALSE
#' @importFrom lubridate is.interval int_standardize int_end int_start
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # create some examples of intervals
#' time5 <- lucC_interval("2011-08-01","2011-09-01")
#' time7 <- lucC_interval("2011-08-01","2011-09-15")
#' 
#' # Apply a relation 'starts' (start_I == start_J) & (end_I < end_J)
#' lucC_relation_starts(time5,time7)
#' 
#'}
#'

# 7. The 's' relation = lucC_relation_starts
lucC_relation_starts <- function (first_interval, second_interval) {
  stopifnot(c(lubridate::is.interval(first_interval), 
              lubridate::is.interval(second_interval)))
  
  first_interval <- lubridate::int_standardize(first_interval)
  
  second_interval <- lubridate::int_standardize(second_interval)
  
  lubridate::int_start(first_interval) == lubridate::int_start(second_interval) & 
    lubridate::int_end(first_interval) < lubridate::int_end(second_interval)
}


#' @title Allen Relation Started By
#' @name lucC_relation_started_by
#' @aliases lucC_relation_started_by
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Provide an Allen's interval relation to classified time series data. And return a logical value if an interval is TRUE or FALSE
#' 
#' @usage lucC_relation_started_by(first_interval , second_interval)
#'  
#' @param first_interval  lucC_interval. An interval between two dates.
#' @param second_interval lucC_interval. An interval between two dates.
#' 
#' @keywords datasets
#' @return Logical value if interval are TRUE or FALSE
#' @importFrom lubridate is.interval int_standardize int_end int_start
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # create some examples of intervals
#' time5 <- lucC_interval("2011-08-01","2011-09-01")
#' time7 <- lucC_interval("2011-08-01","2011-09-15")
#' 
#' # Apply a relation 'started by' (start_I == start_J) & (end_I > end_J)
#' lucC_relation_started_by(time7,time5)
#' 
#'            
#'}
#'


# 8. The 'si' relation = lucC_relation_started_by
lucC_relation_started_by <- function (first_interval, second_interval) {
  stopifnot(c(lubridate::is.interval(first_interval), 
              lubridate::is.interval(second_interval)))
  
  first_interval <- lubridate::int_standardize(first_interval)
  
  second_interval <- lubridate::int_standardize(second_interval)
  
  lubridate::int_start(first_interval) == lubridate::int_start(second_interval) & 
    lubridate::int_end(first_interval) > lubridate::int_end(second_interval)
}


#' @title Allen Relation During
#' @name lucC_relation_during
#' @aliases lucC_relation_during
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Provide an Allen's interval relation to classified time series data. And return a logical value if an interval is TRUE or FALSE
#' 
#' @usage lucC_relation_during(first_interval , second_interval)
#'  
#' @param first_interval  lucC_interval. An interval between two dates.
#' @param second_interval lucC_interval. An interval between two dates.
#' 
#' @keywords datasets
#' @return Logical value if interval are TRUE or FALSE
#' @importFrom lubridate is.interval int_standardize int_end int_start
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # create some examples of intervals
#' time7 <- lucC_interval("2011-08-01","2011-09-15")
#' time8 <- lucC_interval("2011-08-15","2011-08-29")
#' 
#' # Apply a relation 'during' (start_I > start_J) & (end_I < end_J))
#' lucC_relation_during(time8,time7)
#'            
#'}
#'

# 9. The 'd' relation = lucC_relation_during
lucC_relation_during <- function (first_interval, second_interval) {
  stopifnot(c(lubridate::is.interval(first_interval), 
              lubridate::is.interval(second_interval)))
  
  first_interval <- lubridate::int_standardize(first_interval)
  
  second_interval <- lubridate::int_standardize(second_interval)
  
  lubridate::int_start(first_interval) > lubridate::int_start(second_interval) & 
    lubridate::int_end(first_interval) < lubridate::int_end(second_interval)
}


#' @title Allen Relation Contains
#' @name lucC_relation_contains
#' @aliases lucC_relation_contains
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Provide an Allen's interval relation to classified time series data. And return a logical value if an interval is TRUE or FALSE
#' 
#' @usage lucC_relation_contains(first_interval , second_interval)
#'  
#' @param first_interval  lucC_interval. An interval between two dates.
#' @param second_interval lucC_interval. An interval between two dates.
#' 
#' @keywords datasets
#' @return Logical value if interval are TRUE or FALSE
#' @importFrom lubridate is.interval int_standardize int_end int_start
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # create some examples of intervals
#' time7 <- lucC_interval("2011-08-01","2011-09-15")
#' time8 <- lucC_interval("2011-08-15","2011-08-29")
#' 
#' # Apply a relation 'contains' (start_I < start_J) & (end_I > end_J)
#' lucC_relation_contains(time7,time8)
#' 
#'}
#'

# 10. The 'di' relation = lucC_relation_contains
lucC_relation_contains <- function (first_interval, second_interval) {
  stopifnot(c(lubridate::is.interval(first_interval), 
              lubridate::is.interval(second_interval)))
  
  first_interval <- lubridate::int_standardize(first_interval)
  
  second_interval <- lubridate::int_standardize(second_interval)
  
  lubridate::int_start(first_interval) < lubridate::int_start(second_interval) & 
    lubridate::int_end(first_interval) > lubridate::int_end(second_interval)
}


#' @title Allen Relation Finishes
#' @name lucC_relation_finishes
#' @aliases lucC_relation_finishes
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Provide an Allen's interval relation to classified time series data. And return a logical value if an interval is TRUE or FALSE
#' 
#' @usage lucC_relation_finishes(first_interval , second_interval)
#'  
#' @param first_interval  lucC_interval. An interval between two dates.
#' @param second_interval lucC_interval. An interval between two dates.
#' 
#' @keywords datasets
#' @return Logical value if interval are TRUE or FALSE
#' @importFrom lubridate is.interval int_standardize int_end int_start
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # create some examples of intervals
#' time3 <- lucC_interval("2011-10-01","2011-11-01")
#' time4 <- lucC_interval("2011-10-01","2011-11-01")
#' 
#' # Apply a relation 'finishes' (start_I > start_J) & (end_I == end_J)
#' lucC_relation_finishes(time4,time3)
#' 
#'}
#'

# 11. The 'f' relation = lucC_relation_finishes
lucC_relation_finishes <- function (first_interval, second_interval) {
  stopifnot(c(lubridate::is.interval(first_interval), 
              lubridate::is.interval(second_interval)))
  
  first_interval <- lubridate::int_standardize(first_interval)
  
  second_interval <- lubridate::int_standardize(second_interval)
  
  lubridate::int_start(first_interval) > lubridate::int_start(second_interval) & 
    lubridate::int_end(first_interval) == lubridate::int_end(second_interval)
}


#' @title Allen Relation Finished By
#' @name lucC_relation_finished_by
#' @aliases lucC_relation_finished_by
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Provide an Allen's interval relation to classified time series data. And return a logical value if an interval is TRUE or FALSE
#' 
#' @usage lucC_relation_finished_by(first_interval , second_interval)
#'  
#' @param first_interval  lucC_interval. An interval between two dates.
#' @param second_interval lucC_interval. An interval between two dates.
#' 
#' @keywords datasets
#' @return Logical value if interval are TRUE or FALSE
#' @importFrom lubridate is.interval int_standardize int_end int_start
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # create some examples of intervals
#' time3 <- lucC_interval("2011-10-01","2011-11-01")
#' time4 <- lucC_interval("2011-10-01","2011-11-01")
#' 
#' # Apply a relation 'finished by' (start_I < start_J) & (end_I == end_J)
#' lucC_relation_finished_by(time3,time4)
#' 
#'}
#'

# 12. The 'fi' relation = lucC_relation_finished_by
lucC_relation_finished_by <- function (first_interval, second_interval) {
  stopifnot(c(lubridate::is.interval(first_interval), 
              lubridate::is.interval(second_interval)))
  
  first_interval <- lubridate::int_standardize(first_interval)
  
  second_interval <- lubridate::int_standardize(second_interval)
  
  lubridate::int_start(first_interval) < lubridate::int_start(second_interval) & 
    lubridate::int_end(first_interval) == lubridate::int_end(second_interval)
}


#' @title Allen Relation Equals
#' @name lucC_relation_equals
#' @aliases lucC_relation_equals
#' @author Adeline M. Maciel
#' @docType data
#'
#' @description Provide an Allen's interval relation to classified time series data. And return a logical value if an interval is TRUE or FALSE
#' 
#' @usage lucC_relation_equals(first_interval , second_interval)
#'  
#' @param first_interval  lucC_interval. An interval between two dates.
#' @param second_interval lucC_interval. An interval between two dates.
#' 
#' @keywords datasets
#' @return Logical value if interval are TRUE or FALSE
#' @importFrom lubridate is.interval int_standardize int_end int_start
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # create some examples of intervals
#' time3 <- lucC_interval("2011-10-01","2011-11-01")
#' time4 <- lucC_interval("2011-10-01","2011-11-01")
#' 
#' # Apply a relation 'equals' (start_I == start_J) & (end_I == end_J)
#' lucC_relation_equals(time3,time4)
#'            
#'}
#'

# 13. The 'e' relation = lucC_relation_equals
lucC_relation_equals <- function (first_interval, second_interval) {
  stopifnot(c(lubridate::is.interval(first_interval), 
              lubridate::is.interval(second_interval)))
  
  first_interval <- lubridate::int_standardize(first_interval)
  
  second_interval <- lubridate::int_standardize(second_interval)
  
  lubridate::int_start(first_interval) == lubridate::int_start(second_interval) & 
    lubridate::int_end(first_interval) == lubridate::int_end(second_interval)
}

