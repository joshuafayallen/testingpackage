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
                           country = NULL){

      checking_install = arrow_with_s3()

      if(!rlang::is_string(path)){
        tryCatch({
          path = englue("{{path}}")
        }
          error = function(e){


          }
        )

      }


}
