#' Validate input parameters
#'
#' keywords @internal 
validate_inputs <- function(write_to_directory, path, country, file_name, write_function) {
  if (write_to_directory) {
    if (is.null(path) || is.null(file_name)) {
      cli::cli_abort("When write_to_directory is TRUE, both path and file_name must be specified.")
    }
    if (!is.character(path) || !is.character(file_name)) {
      cli::cli_abort("path and file_name must be character strings.")
    }
  }

  if (!is.null(country) && !is.character(country)) {
    cli::cli_abort("country must be a character string or NULL.")
  }

  if (!is.null(write_function) && !is.function(write_function)) {
    cli::cli_abort("write_function must be a function or NULL.")
  }
}