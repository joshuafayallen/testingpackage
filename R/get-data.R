#' Importing from s3 bucket
#'
#' This function imports our data from an s3 AWS bucket
#'
#'  @param country a character vector to subset the data by 
#' @return This function returns a tibble or Arrow Dataset containing the data
#' @export


import_palmer_penguins <- \(
  country = NULL){

  checking_install_aws = arrow::arrow_with_s3()

if(!isTRUE(is.character(country))){

  type_of_country = typeof(country)

 cli::cli_abort('Country should be a character vector of countries but is {type_of_country}')

}
  
if(checking_install_aws == TRUE){

raw_data = arrow::open_dataset('s3://palmerpenguins/')   
  cli::cli_alert_success('Data has been read in to bring data into memory use dplyr::collect()')
  
raw_data
  }
  if(checking_install_aws == FALSE){

    
piggyback::pb_download(file = 'penguins.parquet',
repo = 'joshuafayallen/testingpackage',
tag = '0.0.1',
dest = tempdir())


  raw_data <- arrow::read_parquet(paste0(tempdir(),'/penguins.parquet'))

    cli::cli_alert_success('Downloaded data')
 
  raw_data
  }
  
if(!isTRUE(is.null(country))){

  country_string = rlang::ensym(country)

 tryCatch({
   
   raw_data <- raw_data |>
     dplyr::filter(island %in% {{country}}) 
   
   raw_data
   
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

 
   return(raw_data)
}
  
