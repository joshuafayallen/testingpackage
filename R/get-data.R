#' Importing from s3 bucket
#'
#' This function imports our data from an s3 AWS bucket
#'
#' @param write_to_directory controls whether data is written to local directory. Defaults to `TRUE`
#' @param path name of directory you would like to write the dataset to
#' @param country If you want a subset of the data please provide a string for something coercible to a string.
#' @importFrom arrow arrow_with_s3, open_dataset, write_dataset
#' @importFrom rlang englue
#' @export


import_palmer_penguins = \(write_to_directory = FALSE,
  path = NULL,
  country = NULL,
  aws = FALSE){



checking_install_aws = arrow::arrow_with_s3()
  
check_string = rlang::ensyms(country)

check_path = rlang::ensym(path)

if(isTRUE(aws) && !isTRUE(checking_install_aws)){

cli::cli_abort(message = '{{aws}} but AWS is not configured correctly \n
           see "https://arrow.apache.org/docs/r/articles/install.html"')


}
else if(!isTRUE(check_path)){
  type_path = is.character(path)
  cli::cli_abort(message = "{{path}} should be a character vector but is {type_path}")
}
else if(!isTRUE(is.character(path)) && !isTRUE(is.null(path))){
type_path_argument = typeof(path)
cli::cli_abort(message = '{path} path is not string {type_path_argument} and should be a string', )
}
else if(!isTRUE(is.character(check_string))){

cli::cli_alert_info('Converting {.val {check_string}} to a character vector',
wrap = TRUE)


}

  return(print('hello world'))
  
}
