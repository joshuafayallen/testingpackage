#' Guess write function from file extension
#'
#' This is a slight modification to the guess_write function from the piggyback paackage
#' 
#' `guess_write_function` understands the following file extensions:
#' 
#' - csv, csv.gz, csv.xz with `utils::read.csv`
#' - parquet with `arrow::read_parquet`
#'
#' @param file filename to parse
#' @return function for reading the file, if found
#' @keywords internal

guess_write_function <- function(file_name){
  file_ext <- tools::file_ext(gsub(x = file_name, pattern = ".gz$|.xz$", replacement = ""))
  if (file_ext == "parquet") rlang::check_installed("arrow")

  write_fn <- switch(
    file_ext,
    "csv" = utils::read.csv,
    "parquet" = arrow::read_parquet,
    cli::cli_abort("File type {.val {file_ext}} is not recognized, please provide a {.arg read_function}")
  )

  return(write_fn)
}


#' writing data to directory 
#' @keywords internal

write_data = \(data, path, file_name, write_function, partions){

  path_show = rlang::englue('{path}')


  if(dir.exists(path)){

    cli::cli_alert('writing to path')

  }
  else{

     dir.create(path)

  }

 if(is.null(partions)){
  
 cli::cli_alert_warning('Bringing data into memory to write to {path_show}')
  
  data = data |>
    dplyr::collect()

  if(is.null(write_function)){
    write_function = guess_write_function(file_name)
  }
  write_function(data, file.path(path, file_name))

}

  else{
    
    cli::cli_alert_warning('Bringing data into memory to write to {path_show}')

    data |>
      dplyr::collect() |>
      dplyr::group_by(dplyr::pick(tidyselect::all_of({{partitions}}))) |>
      arrow::write_dataset(path)


  }

}


