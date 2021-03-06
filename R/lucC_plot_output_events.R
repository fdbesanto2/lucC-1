#################################################################
##                                                             ##
##   (c) Adeline Marinho <adelsud6@gmail.com>                  ##
##                                                             ##
##       Image Processing Division                             ##
##       National Institute for Space Research (INPE), Brazil  ##
##                                                             ##
##                                                             ##
##  R script to plot events: sequence, area, frequency and bar ##
##                                                             ##  
##                                             2017-08-11      ##
##                                                             ##
##                                                             ##
#################################################################


#' @title Plot Sequence Maps with lucC Events
#' @name lucC_plot_sequence_events
#' @aliases lucC_plot_sequence_events
#' @author Adeline M. Maciel
#' @docType data
#' 
#' @description Plot time series as sequence of lines over time 
#' 
#' @usage lucC_plot_sequence_events (data_tb = NULL, custom_palette = FALSE, 
#' RGB_color = NULL, show_y_index = TRUE, start_date = "2000-01-01", 
#' end_date = "2016-12-31", relabel = FALSE, original_labels = NULL, 
#' new_labels = NULL)
#' 
#' @param data_tb         Tibble. A tibble with values longitude and latitude and other values
#' @param custom_palette  Boolean. A TRUE or FALSE value. If TRUE, user will provide its own color palette setting! Default is FALSE
#' @param RGB_color       Character. A vector with color names to sequence legend, for example, c("Green","Blue"). Default is setting scale_colour_hue
#' @param show_y_index    Boolean. TRUE/FALSE to show the index values in the axis y of the graphic
#' @param start_date      Date. A start date to plot in sequence in format (ymd), '2011-01-01'
#' @param end_date        Date. A end date to plot in sequence in format (ymd), '2013-01-01'
#' @param relabel         Boolean. A TRUE or FALSE value. If TRUE, user will provide its own legend text setting! Default is FALSE
#' @param original_labels Character. A vector with original labels from legend text, for example, c("Forest","Pasture").
#' @param new_labels      Character. A vector with new labels to legend text, for example, c("Mature_Forest","Pasture1").
#' 
#' @keywords datasets
#' @return Plot sequence time series as lines
#' @import ggplot2
#' @importFrom ensurer ensure_that 
#' @importFrom scales hue_pal
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # open a JSON file example
#' file_json = "./inst/extdata/patterns/example_TWDTW.json"
#' 
#' # open file JSON
#' input_tb_raw_json <- file_json %>%
#'   lucC_fromJSON()
#' input_tb_raw_json
#' 
#' # plot maps input data
#' lucC_plot_maps_input(input_tb_raw_json, EPSG_WGS84 = TRUE, 
#' custom_palette = TRUE, RGB_color = c("#FFB266", "#1b791f", 
#' "#929e6e", "#f5e7a1"))
#' 
#' # define interval
#' time_ex1 <- lucC_interval("2002-01-01", "2014-01-01")
#' 
#' # apply predicate occur
#' ts_occur1 <- lucC_predicate_holds(geo_objects = input_tb_raw_json, 
#' object_properties = "Forest", event_time_intervals = time_ex1)
#' ts_occur1
#' 
#' # events over input map
#' lucC_plot_maps_events(ts_occur1, EPSG_WGS84 = TRUE, 
#' custom_palette = TRUE, RGB_color = c("#FFB266", "#1b791f", 
#' "#929e6e", "#f5e7a1"), shape_point = 0, colour_point = "black", 
#' size_point = 2.3)
#' 
#' lucC_plot_sequence_events(ts_occur1, show_y_index = FALSE, 
#' end_date = "2017-03-01", custom_palette = TRUE, RGB_color = "#929e6e") 
#' 
#'}
#'

lucC_plot_sequence_events <- function(data_tb = NULL, custom_palette = FALSE, RGB_color = NULL, show_y_index = TRUE, start_date = "2000-01-01", end_date = "2016-12-31", relabel = FALSE, original_labels = NULL, new_labels = NULL){ 
  
  # Ensure if parameters exists
  ensurer::ensure_that(data_tb, !is.null(data_tb), 
                       err_desc = "data_tb tibble, file must be defined!\nThis data can be obtained using lucC_plot_maps_events().")
  ensurer::ensure_that(custom_palette, !is.null(custom_palette), 
                       err_desc = "custom_palette must be defined, if wants use its own color palette setting! Default is FALSE")
  ensurer::ensure_that(show_y_index, !is.null(show_y_index), 
                       err_desc = "Show y index label must be defined! Default is 'TRUE'")
  ensurer::ensure_that(start_date, !is.null(start_date), 
                       err_desc = "Start date must be defined! Default is '2000-01-01'")
  ensurer::ensure_that(end_date, !is.null(end_date), 
                       err_desc = "End date must be defined! Default is '2016-12-31'!")
  
  mapSeq <- data_tb
  mapSeq <- mapSeq[order(mapSeq$index),] # order by index
  
  mapSeq$start_date <- as.Date(mapSeq$start_date, format = '%Y-%m-%d')
  mapSeq$end_date <- as.Date(mapSeq$end_date, format = '%Y-%m-%d')
  
  data <- as.data.frame(mapSeq) # data from package datasets
  data$Category <- as.character(mapSeq$index) # this makes things simpler later
  
  # insert own colors palette
  if(custom_palette == TRUE){
    if(is.null(RGB_color) | length(RGB_color) != length(unique(mapSeq$label))){
      cat("\nIf custom_palette = TRUE, a RGB_color vector with colors must be defined!")
      cat("\nProvide a list of colors with the same length of the number of legend!\n") 
    } else {
      my_palette = RGB_color  
    }
  } else {
    # more colors
    colour_count = length(unique(mapSeq$label))
    my_palette = scales::hue_pal()(colour_count)
  } 
  
  original_leg_lab <- unique(mapSeq$label)
  cat("Original legend labels: \n", original_leg_lab, "\n")
  
  # insert own legend text
  if(relabel == TRUE){
    if(is.null(original_labels) | length(new_labels) != length(unique(mapSeq$label)) | 
       all(original_labels %in% original_leg_lab) == FALSE){
      cat("\nIf relabel = TRUE, a vector with original labels must be defined!")
      cat("\nProvide a list of original labels and new labels with the same length of the legend!\n") 
    } else {
      my_original_label = original_labels
      my_new_labels = new_labels
    }
  } else {
    # my legend text
    my_original_label = unique(mapSeq$label)
    my_new_labels = unique(mapSeq$label)
  }   
  
  g <- ggplot2::ggplot(data, aes(y = data$Category)) +
    labs(x = "Time", y = "Locations") +
    theme_bw()+
    geom_segment(aes(x = data$"start_date", y = data$Category,
                     xend = data$"end_date", yend = data$Category,
                     color = data$"label"), size = 1.25) +
    
    geom_point(aes(x = data$"start_date", color =  data$"label"), size = 3, shape = 19) +
    geom_point(aes(x = data$"end_date", color = data$"label"), size = 3, shape = 19) +
    
    # define time period
    scale_x_date(limits=as.Date(c(start_date, end_date))) +
    scale_color_manual(name="Legend:", values = my_palette, breaks = my_original_label, labels = my_new_labels)
  #scale_color_grey(name = "Legend:", start = 0, end = 0.8)
  
  # shows axis y label with index values from tibble
  if(show_y_index == TRUE){
    g <- g + theme(legend.position = "bottom", 
                   legend.text=element_text(size=11), ###
                   legend.key = element_blank())  
  } else {
    g <- g + theme(legend.position = "bottom", 
                   legend.text=element_text(size=11), ###
                   axis.text.y=element_blank(),
                   legend.key = element_blank())  
  } 
  
  print(g)
  
}



#' @title Plot Barplot Maps with lucC Events
#' @name lucC_plot_bar_events
#' @aliases lucC_plot_bar_events
#' @author Adeline M. Maciel
#' @docType data
#' 
#' @description Plot barplot over time 
#' 
#' @usage lucC_plot_bar_events (data_tb = NULL, 
#' custom_palette = FALSE, RGB_color = NULL, pixel_resolution = 250, 
#' relabel = FALSE, original_labels = NULL, new_labels = NULL,
#' side_by_side = FALSE)
#' 
#' @param data_tb          Tibble. A tibble with values longitude and latitude and other values
#' @param custom_palette   Boolean. A TRUE or FALSE value. If TRUE, user will provide its own color palette setting! Default is FALSE
#' @param RGB_color        Character. A vector with color names to map legend, for example, c("Green","Blue"). Default is setting scale_colour_hue
#' @param pixel_resolution Numeric. Is a spatial resolution of the pixel. Default is 250 meters considering MODIS 250 m. See more at \url{https://modis.gsfc.nasa.gov/about/specifications.php}.
#' @param relabel          Boolean. A TRUE or FALSE value. If TRUE, user will provide its own legend text setting! Default is FALSE
#' @param original_labels  Character. A vector with original labels from legend text, for example, c("Forest","Pasture").
#' @param new_labels       Character. A vector with new labels to legend text, for example, c("Mature_Forest","Pasture1").
#' @param side_by_side     Boolean. Make bar of a barplot a side-by-side plot. Default is FALSE.
#' 
#' @keywords datasets
#' @return Plot a barplot in Y axis in square kilometers (Area km^2) = (Number of pixel *(pixel_resolution*pixel_resolution))/(1000*1000)
#' @import ggplot2
#' @importFrom ensurer ensure_that 
#' @importFrom lubridate year 
#' @importFrom scales hue_pal
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # open a JSON file example
#' file_json = "./inst/extdata/patterns/example_TWDTW.json"
#' 
#' # open file JSON
#' input_tb_raw_json <- file_json %>%
#'   lucC_fromJSON()
#' input_tb_raw_json
#' 
#' # plot maps input data
#' lucC_plot_maps_input(input_tb_raw_json, EPSG_WGS84 = TRUE, 
#' custom_palette = TRUE, RGB_color = c("#FFB266", "#1b791f", 
#' "#929e6e", "#f5e7a1"))
#' 
#' # define interval
#' time_ex1 <- lucC_interval("2002-01-01", "2014-01-01")
#' 
#' # apply predicate occur
#' ts_occur1 <- lucC_predicate_holds(geo_objects = input_tb_raw_json, 
#' object_properties = "Forest", event_time_intervals = time_ex1)
#' ts_occur1
#' 
#' # events over input map
#' lucC_plot_maps_events(ts_occur1, EPSG_WGS84 = TRUE, 
#' custom_palette = TRUE, RGB_color = c("#FFB266", "#1b791f", 
#' "#929e6e", "#f5e7a1"), shape_point = 0, colour_point = "black", 
#' size_point = 2.3)
#' 
#' lucC_plot_bar_events(ts_occur1, custom_palette = TRUE, 
#' RGB_color = "#929e6e", pixel_resolution = 250) 
#' 
#'}
#'

lucC_plot_bar_events <- function(data_tb = NULL, custom_palette = FALSE, RGB_color = NULL, pixel_resolution = 250, relabel = FALSE, original_labels = NULL, new_labels = NULL, side_by_side = FALSE){ 
  
  # Ensure if parameters exists
  ensurer::ensure_that(data_tb, !is.null(data_tb), 
                       err_desc = "data_tb tibble, file must be defined!\nThis data can be obtained using lucC_plot_maps_events().")
  ensurer::ensure_that(custom_palette, !is.null(custom_palette), 
                       err_desc = "custom_palette must be defined, if wants use its own color palette setting! Default is FALSE")
  ensurer::ensure_that(pixel_resolution, !is.null(pixel_resolution), 
                       err_desc = "pixel_resolution must be defined! Default is 250 meters on basis of MODIS image")  
  
  input_data <- data_tb
  input_data <- input_data[order(input_data$index),] # order by index
  
  #mapBar <- data.frame(table(input_data$w, input_data$z))
  mapBar <- data.frame(table(lubridate::year(input_data$end_date), input_data$label))
  
  # insert own colors palette
  if(custom_palette == TRUE){
    if(is.null(RGB_color) | length(RGB_color) != length(unique(mapBar$Var2))){
      cat("\nIf custom_palette = TRUE, a RGB_color vector with colors must be defined!")
      cat("\nProvide a list of colors with the same length of the number of legend!\n") 
    } else {
      my_palette = RGB_color  
    }
  } else {
    # more colors
    colour_count = length(unique(mapBar$Var2))
    my_palette = scales::hue_pal()(colour_count)
  } 
  
  original_leg_lab <- levels(droplevels(mapBar$Var2))
  cat("Original legend labels: \n", original_leg_lab, "\n")
  
  # insert own legend text
  if(relabel == TRUE){
    if(is.null(original_labels) | length(new_labels) != length(unique(mapBar$Var2)) | 
       all(original_labels %in% original_leg_lab) == FALSE){
      cat("\nIf relabel = TRUE, a vector with original labels must be defined!")
      cat("\nProvide a list of original labels and new labels with the same length of the legend!\n") 
    } else {
      my_original_label = original_labels
      my_new_labels = new_labels
    }
  } else {
    # my legend text
    my_original_label = unique(mapBar$Var2)
    my_new_labels = unique(mapBar$Var2)
  } 
  
  # make side-by-side bar plot
  if (side_by_side == TRUE){
    bar_position = "dodge"
  } else { 
    bar_position = "stack"
  }
  
  g <- ggplot2::ggplot(mapBar,aes(x=mapBar$Var1, y=(mapBar$Freq*(pixel_resolution*pixel_resolution))/(1000*1000), fill=mapBar$Var2))+
    geom_bar(width = 0.7, stat="identity", position = bar_position)+
    theme_bw()+
    ylab(expression(paste("Area ",km^{2}," = ((pixels number x pixel ", resolution^{2},")/",1000^{2},")")))+
    xlab("Time")+
    scale_fill_manual(name="Legend:", values = my_palette, breaks = my_original_label, labels = my_new_labels) +
    #scale_fill_grey(name = "Legend:", start = 0, end = 0.8) +
    theme(legend.position = "bottom", 
          legend.text=element_text(size=11),  ###
          legend.key = element_blank())
  
  print(g)
  
}



#' @title Plot Frequency Polygon with lucC Events
#' @name lucC_plot_frequency_events
#' @aliases lucC_plot_frequency_events
#' @author Adeline M. Maciel
#' @docType data
#' 
#' @description Plot frequency polygon over time 
#' 
#' @usage lucC_plot_frequency_events (data_tb = NULL, 
#' custom_palette = FALSE, RGB_color = NULL, pixel_resolution = 250, 
#' relabel = FALSE, original_labels = NULL, new_labels = NULL)
#' 
#' @param data_tb          Tibble. A tibble with values longitude and latitude and other values
#' @param custom_palette   Boolean. A TRUE or FALSE value. If TRUE, user will provide its own color palette setting! Default is FALSE
#' @param RGB_color        Character. A vector with color names to map legend, for example, c("Green","Blue"). Default is setting scale_colour_hue
#' @param pixel_resolution Numeric. Is a spatial resolution of the pixel. Default is 250 meters considering MODIS 250 m. See more at \url{https://modis.gsfc.nasa.gov/about/specifications.php}.
#' @param relabel          Boolean. A TRUE or FALSE value. If TRUE, user will provide its own legend text setting! Default is FALSE
#' @param original_labels  Character. A vector with original labels from legend text, for example, c("Forest","Pasture").
#' @param new_labels       Character. A vector with new labels to legend text, for example, c("Mature_Forest","Pasture1").
#' 
#' @keywords datasets
#' @return Plot a frequency polygon in Y axis in square kilometers (Area km^2) = (Number of pixel *(pixel_resolution*pixel_resolution))/(1000*1000)
#' @import ggplot2
#' @importFrom ensurer ensure_that 
#' @importFrom lubridate year 
#' @importFrom scales hue_pal
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # open a JSON file example
#' file_json = "./inst/extdata/patterns/example_TWDTW.json"
#' 
#' # open file JSON
#' input_tb_raw_json <- file_json %>%
#'   lucC_fromJSON()
#' input_tb_raw_json
#' 
#' # plot maps input data
#' lucC_plot_frequency_events(input_tb_raw_json, EPSG_WGS84 = TRUE, 
#' custom_palette = TRUE, RGB_color = c("#FFB266", "#1b791f", 
#' "#929e6e", "#f5e7a1"))
#' 
#' # define interval
#' time_ex1 <- lucC_interval("2002-01-01", "2014-01-01")
#' 
#' # apply predicate occur
#' ts_occur1 <- lucC_predicate_holds(geo_objects = input_tb_raw_json, 
#' object_properties = "Forest", event_time_intervals = time_ex1)
#' ts_occur1
#' 
#' # events over input map
#' lucC_plot_maps_events(ts_occur1, EPSG_WGS84 = TRUE, 
#' custom_palette = TRUE, RGB_color = c("#FFB266", "#1b791f", 
#' "#929e6e", "#f5e7a1"), shape_point = 0, colour_point = "black", 
#' size_point = 2.3)
#' 
#' lucC_plot_frequency_events(ts_occur1, custom_palette = TRUE, 
#' RGB_color = "#929e6e", pixel_resolution = 250) 
#' 
#'}
#'

lucC_plot_frequency_events <- function(data_tb = NULL, custom_palette = FALSE, RGB_color = NULL, pixel_resolution = 250, relabel = FALSE, original_labels = NULL, new_labels = NULL){ 
  
  # Ensure if parameters exists
  ensurer::ensure_that(data_tb, !is.null(data_tb), 
                       err_desc = "data_tb tibble, file must be defined!\nThis data can be obtained using lucC_plot_maps_events().")
  ensurer::ensure_that(custom_palette, !is.null(custom_palette), 
                       err_desc = "custom_palette must be defined, if wants use its own color palette setting! Default is FALSE")
  ensurer::ensure_that(pixel_resolution, !is.null(pixel_resolution), 
                       err_desc = "pixel_resolution must be defined! Default is 250 meters on basis of MODIS image")  
  
  input_data <- data_tb
  input_data <- input_data[order(input_data$index),] # order by index
  
  #mapFreq <- data.frame(table(input_data$w, input_data$z))
  mapFreq <- data.frame(table(lubridate::year(input_data$end_date), input_data$label))
  
  # insert own colors palette
  if(custom_palette == TRUE){
    if(is.null(RGB_color) | length(RGB_color) != length(unique(mapFreq$Var2))){
      cat("\nIf custom_palette = TRUE, a RGB_color vector with colors must be defined!")
      cat("\nProvide a list of colors with the same length of the number of legend!\n") 
    } else {
      my_palette = RGB_color  
    }
  } else {
    # more colors
    colour_count = length(unique(mapFreq$Var2))
    my_palette = scales::hue_pal()(colour_count)
  } 
  
  original_leg_lab <- levels(droplevels(mapFreq$Var2))
  cat("Original legend labels: \n", original_leg_lab, "\n")
  
  # insert own legend text
  if(relabel == TRUE){
    if(is.null(original_labels) | length(new_labels) != length(unique(mapFreq$Var2)) | 
       all(original_labels %in% original_leg_lab) == FALSE){
      cat("\nIf relabel = TRUE, a vector with original labels must be defined!")
      cat("\nProvide a list of original labels and new labels with the same length of the legend!\n") 
    } else {
      my_original_label = original_labels
      my_new_labels = new_labels
    }
  } else {
    # my legend text
    my_original_label = unique(mapFreq$Var2)
    my_new_labels = unique(mapFreq$Var2)
  } 
  
  g <- ggplot2::ggplot(mapFreq,aes(x=mapFreq$Var1, y=(mapFreq$Freq*(pixel_resolution*pixel_resolution))/(1000*1000), group = mapFreq$Var2, color = mapFreq$Var2))+
    geom_freqpoly(stat = "identity", size = 1)+
    geom_point( size = 2, shape = 16) +
    theme_bw()+
    ylab(expression(paste("Area ",km^{2}," = ((pixels number x pixel ", resolution^{2},")/",1000^{2},")")))+
    xlab("Time")+
    scale_color_manual(name="Legend:", values = my_palette, breaks = my_original_label, labels = my_new_labels) +
    #scale_fill_grey(name = "Legend:", start = 0, end = 0.8) +
    theme(legend.position = "bottom", 
          legend.text=element_text(size=11), ##
          legend.key = element_blank())
  
  print(g)
  
}



#' @title Plot Area Graphic with lucC Events
#' @name lucC_plot_area_events
#' @aliases lucC_plot_area_events
#' @author Adeline M. Maciel
#' @docType data
#' 
#' @description Plot area with percentages over time 
#' 
#' @usage lucC_plot_area_events (data_tb = NULL, 
#' custom_palette = FALSE, RGB_color = NULL, pixel_resolution = 250, 
#' relabel = FALSE, original_labels = NULL, new_labels = NULL,
#' perc_area = TRUE)
#' 
#' @param data_tb          Tibble. A tibble with values longitude and latitude and other values
#' @param custom_palette   Boolean. A TRUE or FALSE value. If TRUE, user will provide its own color palette setting! Default is FALSE
#' @param RGB_color        Character. A vector with color names to map legend, for example, c("Green","Blue"). Default is setting scale_colour_hue
#' @param pixel_resolution Numeric. Is a spatial resolution of the pixel. Default is 250 meters considering MODIS 250 m. See more at \url{https://modis.gsfc.nasa.gov/about/specifications.php}.
#' @param relabel          Boolean. A TRUE or FALSE value. If TRUE, user will provide its own legend text setting! Default is FALSE
#' @param original_labels  Character. A vector with original labels from legend text, for example, c("Forest","Pasture").
#' @param new_labels       Character. A vector with new labels to legend text, for example, c("Mature_Forest","Pasture1").
#' @param perc_area        Boolean. Show the y axis in percentage values. Default is TRUE. FALSE will show in Area square kilometers
#' 
#' @keywords datasets
#' @return Plot a area with percentage in Y axis or in square kilometers (Area km^2) = (Number of pixel *(pixel_resolution*pixel_resolution))/(1000*1000)
#' @import ggplot2
#' @importFrom ensurer ensure_that 
#' @importFrom lubridate year 
#' @importFrom scales hue_pal percent
#' @export
#'
#' @examples \dontrun{
#' 
#' library(lucC)
#' 
#' lucC_starting_point()
#' 
#' # open a JSON file example
#' file_json = "./inst/extdata/patterns/example_TWDTW.json"
#' 
#' # open file JSON
#' input_tb_raw_json <- file_json %>%
#'   lucC_fromJSON()
#' input_tb_raw_json
#' 
#' # plot maps input data
#' lucC_plot_area_events(input_tb_raw_json, EPSG_WGS84 = TRUE, 
#' custom_palette = TRUE, RGB_color = c("#FFB266", "#1b791f", 
#' "#929e6e", "#f5e7a1"))
#' 
#' # define interval
#' time_ex1 <- lucC_interval("2002-01-01", "2014-01-01")
#' 
#' # apply predicate occur
#' ts_occur1 <- lucC_predicate_holds(geo_objects = input_tb_raw_json, 
#' object_properties = "Forest", event_time_intervals = time_ex1)
#' ts_occur1
#' 
#' # events over input map
#' lucC_plot_maps_events(ts_occur1, EPSG_WGS84 = TRUE, 
#' custom_palette = TRUE, RGB_color = c("#FFB266", "#1b791f", 
#' "#929e6e", "#f5e7a1"), shape_point = 0, colour_point = "black", 
#' size_point = 2.3)
#' 
#' lucC_plot_area_events(ts_occur1, custom_palette = TRUE, 
#' RGB_color = "#929e6e", pixel_resolution = 250) 
#' 
#'}
#'

lucC_plot_area_events <- function(data_tb = NULL, custom_palette = FALSE, RGB_color = NULL, pixel_resolution = 250, relabel = FALSE, original_labels = NULL, new_labels = NULL, perc_area = TRUE){ 
  
  # Ensure if parameters exists
  ensurer::ensure_that(data_tb, !is.null(data_tb), 
                       err_desc = "data_tb tibble, file must be defined!\nThis data can be obtained using lucC_plot_maps_events().")
  ensurer::ensure_that(custom_palette, !is.null(custom_palette), 
                       err_desc = "custom_palette must be defined, if wants use its own color palette setting! Default is FALSE")
  ensurer::ensure_that(pixel_resolution, !is.null(pixel_resolution), 
                       err_desc = "pixel_resolution must be defined! Default is 250 meters on basis of MODIS image")  
  
  input_data <- data_tb 
  input_data <- input_data[order(input_data$index),] # order by index
  
  #mapArea <- data.frame(table(input_data$w, input_data$z))
  mapArea <- data.frame(table(lubridate::year(input_data$end_date), input_data$label))
  mapArea$Year <- as.numeric(as.character(mapArea$Var1))
  
  # insert own colors palette
  if(custom_palette == TRUE){
    if(is.null(RGB_color) | length(RGB_color) != length(unique(mapArea$Var2))){
      cat("\nIf custom_palette = TRUE, a RGB_color vector with colors must be defined!")
      cat("\nProvide a list of colors with the same length of the number of legend!\n") 
    } else {
      my_palette = RGB_color  
    }
  } else {
    # more colors
    colour_count = length(unique(mapArea$Var2))
    my_palette = scales::hue_pal()(colour_count)
  } 
  
  original_leg_lab <- levels(droplevels(mapArea$Var2))
  cat("Original legend labels: \n", original_leg_lab, "\n")
  
  # insert own legend text
  if(relabel == TRUE){
    if(is.null(original_labels) | length(new_labels) != length(unique(mapArea$Var2)) | 
       all(original_labels %in% original_leg_lab) == FALSE){
      cat("\nIf relabel = TRUE, a vector with original labels must be defined!")
      cat("\nProvide a list of original labels and new labels with the same length of the legend!\n") 
    } else {
      my_original_label = original_labels
      my_new_labels = new_labels
    }
  } else {
    # my legend text
    my_original_label = unique(mapArea$Var2)
    my_new_labels = unique(mapArea$Var2)
  } 
  
  # show y axis in percentage or area square kilometers
  if (perc_area == TRUE){
    mapArea$Freq1 <- mapArea$Freq/100  
  } else { 
    mapArea$Freq1 <- (mapArea$Freq*(pixel_resolution*pixel_resolution))/(1000*1000)
  }
  
  x_axis = unique(mapArea$Year)
  
  g <- ggplot2::ggplot(mapArea,aes(x=mapArea$Year, y=mapArea$Freq1))+
    geom_area(aes(fill=mapArea$Var2), stat="identity", position = "stack")+
    theme_bw()+
    xlab("Time")+
    scale_fill_manual(name="Legend:", values = my_palette, breaks = my_original_label, labels = my_new_labels) +
    scale_x_continuous(breaks = x_axis) +
    #scale_fill_grey(name = "Legend:", start = 0, end = 0.8) +
    theme(legend.position = "bottom", 
          legend.text=element_text(size=11), 
          legend.key = element_blank())
  
  if(perc_area == TRUE){
    g = g + scale_y_continuous(expand = c(0, 0), labels = scales::percent) 
    g = g + ylab("Percentage of area")
  } else {
    g = g + scale_y_continuous(expand = c(0, 0))
    g = g + ylab(expression(paste("Area ",km^{2}," = ((pixels number x pixel ", resolution^{2},")/",1000^{2},")")))
  }
  
  print(g)
  
}
