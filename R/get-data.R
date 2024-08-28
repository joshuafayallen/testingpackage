#' Importing from s3 bucket
#'
#' This function imports our data from an s3 AWS bucket
#'
#' @param write_to_directory controls whether data is written to local directory. Defaults to `FALSE`
#' @param path name of directory you would like to write the dataset to
#' @param country If you want a subset of the data please provide a string for something coercible to a string.
#' @param file_type When write_to_directory is `TRUE` this will choose what file type to write to. Can be csv or parquet
#' @param file_name when write_directory is `TRUE` please specify a file name. Must be a character
#' @param partions if write_to_directory is set to TRUE asnd file_type is parquet this will control the partions. Can be character vector or unquoted column names. Defaults to null
#' @export


import_palmer_penguins = \(write_to_directory = FALSE,
  path = NULL,
  country = NULL,
  file_name = NULL, 
  file_type = c('csv', 'parquet'),
  partions = NULL){


checking_install_aws = arrow::arrow_with_s3()
  
if(!isTRUE(is.character(path)) && !isTRUE(is.null(path))){

type_path_argument = typeof(path)
  
cli::cli_abort(message = '{path} path is not string {type_path_argument} and should be a string')
  
}
  if(write_to_directory == TRUE && isTRUE(is.null(path)) || write_to_directory == TRUE && isTRUE(is.null(file_name))){

  cli::cli_abort('write_to_directory is set to TRUE and path is not specified or file_name is not specified. Please specify a path or file name as a character')

}

if(write_to_directory == TRUE && !isTRUE(is.null(path))){
    
   path = rlang::englue('{path}')
  
    if(!dir.exists(path)){
      dir.create(path)
    }else{

      invisible(print('directory already exists'))

    }

}
if(!isTRUE(is.character(country)) && !isTRUE(is.null(country)) ){

type_of_country = typeof(country)

cli::cli_abort(message = '{country} is {type_of_country} and should be a string')
}
  if(checking_install_aws == TRUE){

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

    raw_data = raw_data |>
      dplyr::filter(island %in% {{country}})




  }
 

  if(!isTRUE(is.null(country)) && checking_install_aws == FALSE){

      raw_data = raw_data |>
       dplyr::filter(island %in% {{country}})

  }

 if(!isTRUE(is.null(country)) && checking_install_aws == TRUE){
   
   raw_data = raw_data |>
     dplyr::filter(island %in% {{country}})
   
 }
  
 if(checking_install_aws == FALSE && write_to_directory == TRUE && !isTRUE(is.null(path)) && file_type == 'csv'){
  path = rlang::englue('{path}')
  file_name = rlang::englue('{file_name}')
   utils::write.csv(raw_data, paste0(path, file_name))

  
 }

 if(checking_install_aws == FALSE && write_to_directory == TRUE && !isTRUE(is.null(path)) && file_type == 'parquet'){
   
  path = rlang::englue('{path}')
  file_name = rlang::englue('{file_name}')

  arrow::write_parquet(raw_data, paste0(path, file_name))

 
 }

  
if(checking_install_aws == TRUE && !isTRUE(is.null(path)) && file_type == 'csv'){

  cli::cli_alert('Bringing data into memory')

  raw_data = raw_data |>
    dplyr::collect()

   
  utils::write.csv(raw_data, paste0(path, file_name))


}
  
if(checking_install_aws == TRUE && !isTRUE(is.null(path)) && file_type == 'parquet' && isTRUE(is.null(partions))){

  cli::cli_alert('Bringing data into memory to write_parquet')

  raw_data = raw_data |>
    dplyr::collect()

  arrow::write_parquet(raw_data, paste0(path, file_name))

}
  if(checking_install_aws == TRUE && !isTRUE(is.null(path)) && file_type == 'parquet' && !isTRUE(is.null(partions))){
 
  cli::cli_alert_warning('Bringing data into memory to write to {path}')

  raw_data |>
    dplyr::collect() |>
    dplyr::group_by(dplyr::pick(tidyselect::all_of({{partions}}))) |>
    arrow::write_dataset(path)

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



 
   return(raw_data)
}
  
  


