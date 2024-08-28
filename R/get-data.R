#' Importing from s3 bucket
#'
#' This function imports our data from an s3 AWS bucket
#'
#' @param write_to_directory controls whether data is written to local directory. Defaults to `FALSE`
#' @param path name of directory you would like to write the dataset to
#' @param country If you want a subset of the data please provide a string for something coercible to a string.
#' @param file_name when write_directory is `TRUE` please specify a file name. Must be a character
#' @param write_function a function to write the data. can be write.csv or arrow::write_parquet. If no function supplied than we will try to guess the function
#' @param partions if write_to_directory is set to TRUE asnd file_type is parquet this will control the partions. Can be character vector or unquoted column names. Defaults to null
#' @return This function returns a tibble or Arrow Dataset containing the data
#' @export


import_palmer_penguins = \(write_to_directory = FALSE,
  path = NULL,
  country = NULL,
  file_name = NULL, 
  write_function = NULL,
  partions = NULL){

  check_install_aws = arrow::arrow_with_s3()

  validate_inputs(write_to_directory, path, country, file_name, write_function)
  
  
if(checking_install_aws == TRUE && write_to_directory == FALSE){

raw_data = arrow::open_dataset('s3://palmerpenguins/') 
    
  cli::cli_alert_success('Data has been read in to bring data into memory use dplyr::collect()')
  

  }
  if(checking_install_aws == FALSE){

    
piggyback::pb_download(file = 'penguins.parquet',
repo = 'joshuafayallen/testingpackage',
tag = '0.0.1',
dest = tempdir())


    raw_data = arrow::read_parquet(paste0(tempdir(),'/penguins.parquet'))

    cli::cli_alert_success('Downloaded data')
 
  }
  
if(!isTRUE(is.null(country)) && checking_install_aws == TRUE){

  country_string = rlang::ensym(country)

 tryCatch({
   
   raw_data = raw_data |>
     dplyr::filter(island %in% {{country}}) 
   
   if(nrow(raw_data) > 0 ){
     
     cli::cli_alert_success('Successfully subseted by {.val {{country_string}}')
     
     
   }
   else{
     
     cli::cli_alert_warning('Check query for spelling. dataframe has no rows')
     
     
   }
   
 }, error = function(e){
   
   conditionMessage(e)
   
 })
  
  



}
  if(!isTRUE(is.null(country)) && checking_install_aws == FALSE){

  country_string = rlang::ensym(country)

 tryCatch({
   
   raw_data = raw_data |>
     dplyr::filter(island %in% {{country}}) 
   
   if(nrow(raw_data) > 0 ){
     
     cli::cli_alert_success('Successfully subseted by {.val {{country_string}}')
     
     
   }
   else{
     
     cli::cli_alert_warning('Check query for spelling. dataframe has no rows')
     
     
   }
   
 }, error = function(e){
   
   conditionMessage(e)
   
 })


}
  if(write_to_directory == TRUE){

  write_data(data = raw_data, path, file_name, write_function, partions)
}



 
   return(raw_data)
}
  
