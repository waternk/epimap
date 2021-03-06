#' Quickly generate an interactive map
#' 
#' This function can be used to quickly generate interactive maps
#' from a \code{SpatialPointsDataFrame} or a \code{SpatialPolygonsDataFrame}.
#' 
#' @param x a \code{SpatialPointsDataFrame} or a \code{SpatialPolygonsDataFrame}.
#' @param col.by a column name of x giving colors for points or polygons.
#' @param size.by a column name of x giving the size for the circles.
#' Only relevant with \code{SpatialPointsDataFrame}
#' @param alpha a numeric to control the transparency.
#' @param popup a character vector providing popup content.
#' @param ... other arguments to be passed to \code{\link[rleafmap]{writeMap}}
#' 
#' @examples
#' \dontrun{
#' data(cholera)
#' quickMap(cholera$deaths, col.by = "Count", size.by = "Count")
#' }
#' 
#' @export
quickMap <- function(x, col.by = "", size.by = "", alpha = 1, popup = "", ...){
  if(!class(x) %in% c("SpatialPointsDataFrame",
                      "SpatialPolygonsDataFrame")){
    stop("x must be a SpatialPointsDataFrame or a SpatialPolygonsDataFrame")
  }
  
  if(col.by %in% names(x)){
    col <- x[[col.by]]
    if(is.numeric(col)){
      gcut <- cut(col, breaks = 12)
      col <- heat.colors(12)[as.numeric(gcut)]
    } else {
      col <- as.numeric(col)
    }
  } else {
    col <- rep("darkgrey", times = dim(x)[1])
  }
  
  if(size.by %in% names(x)){
    size <- x[[size.by]]
    size <- as.numeric(size) + 2
    size[is.na(size)] <- 1
    size <- (size/max(size))*20
    
  } else {
    size <- 5
  }
  
  bbm <- basemap("stamen.toner.lite")
  
  if (class(x) == "SpatialPointsDataFrame"){
    x.map <- spLayer(x, size = size,
                     fill.col = col, fill.alpha = alpha,
                     stroke = FALSE, popup = popup)  
  }
  if (class(x) == "SpatialPolygonsDataFrame"){
    x.map <- spLayer(x, fill.col = col, fill.alpha = alpha,
                     popup = popup)
  }
  
  writeMap(bbm, x.map, ...)
}
