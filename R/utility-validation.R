validationClass <- R6::R6Class(
  "validationClass",
  lock_objects = TRUE,
  public = list(
    isValidStorageContainerName = function(storageContainerName) {
      if (!grepl("^([a-z]|[0-9]|[-]){3,64}$", storageContainerName)) {
        stop(paste("Storage Container names can contain only lowercase letters, numbers,",
                   "and the dash (-) character. Names must be 3 through 64 characters long."))
      }
    },
    isValidPoolName = function(poolName) {
      if (!grepl("^([a-zA-Z0-9]|[-]|[_]){1,64}$", poolName)) {
        stop(paste("The pool name can contain any combination of alphanumeric characters",
                   "including hyphens and underscores, and cannot contain more",
                   "than 64 characters."))
      }
    },
    isValidJobName = function(jobName) {
      if (!grepl("^([a-zA-Z0-9]|[-]|[_]){1,64}$", jobName)) {
        stop(paste("The job name can contain any combination of alphanumeric characters",
                   "including hyphens and underscores, and cannot contain more",
                   "than 64 characters."))
      }
    },
    # Validating cluster configuration files below doAzureParallel version 0.3.2
    isValidDeprecatedClusterConfig = function(poolConfig) {
      if (is.null(poolConfig$pool$poolSize)) {
        stop("Missing poolSize entry")
      }

      if (is.null(poolConfig$pool$poolSize$dedicatedNodes)) {
        stop("Missing dedicatedNodes entry")
      }

      if (is.null(poolConfig$pool$poolSize$lowPriorityNodes)) {
        stop("Missing lowPriorityNodes entry")
      }

      if (is.null(poolConfig$pool$poolSize$autoscaleFormula)) {
        stop("Missing autoscaleFormula entry")
      }

      if (is.null(poolConfig$pool$poolSize$dedicatedNodes$min)) {
        stop("Missing dedicatedNodes$min entry")
      }

      if (is.null(poolConfig$pool$poolSize$dedicatedNodes$max)) {
        stop("Missing dedicatedNodes$max entry")
      }

      if (is.null(poolConfig$pool$poolSize$lowPriorityNodes$min)) {
        stop("Missing lowPriorityNodes$min entry")
      }

      if (is.null(poolConfig$pool$poolSize$lowPriorityNodes$max)) {
        stop("Missing lowPriorityNodes$max entry")
      }

      stopifnot(is.character(poolConfig$pool$name))
      stopifnot(is.character(poolConfig$pool$vmSize))
      stopifnot(is.character(poolConfig$pool$poolSize$autoscaleFormula))
      stopifnot(poolConfig$pool$poolSize$autoscaleFormula %in% names(autoscaleFormula))

      stopifnot(
        poolConfig$pool$poolSize$dedicatedNodes$min <= poolConfig$pool$poolSize$dedicatedNodes$max
      )
      stopifnot(
        poolConfig$pool$poolSize$lowPriorityNodes$min <= poolConfig$pool$poolSize$lowPriorityNodes$max
      )
      stopifnot(poolConfig$pool$maxTasksPerNode >= 1)

      stopifnot(is.double(poolConfig$pool$poolSize$dedicatedNodes$min))
      stopifnot(is.double(poolConfig$pool$poolSize$dedicatedNodes$max))
      stopifnot(is.double(poolConfig$pool$poolSize$lowPriorityNodes$min))
      stopifnot(is.double(poolConfig$pool$poolSize$lowPriorityNodes$max))
      stopifnot(is.double(poolConfig$pool$maxTasksPerNode))

      TRUE
    },
    isValidClusterConfig = function(cluster) {
      if (class(cluster) == "character") {
        clusterFilePath <- cluster
        if (file.exists(clusterFilePath)) {
          pool <- rjson::fromJSON(file = clusterFilePath)
        }
        else{
          pool <- rjson::fromJSON(file = file.path(getwd(), clusterFilePath))
        }
      } else if (class(cluster) == "list") {
        pool <- cluster
      } else {
        stop(sprintf(
          "cluster setting type is not supported: %s\n",
          class(cluster)
        ))
      }

      if (is.null(pool$poolSize)) {
        stop("Missing poolSize entry")
      }

      if (is.null(pool$poolSize$dedicatedNodes)) {
        stop("Missing dedicatedNodes entry")
      }

      if (is.null(pool$poolSize$lowPriorityNodes)) {
        stop("Missing lowPriorityNodes entry")
      }

      if (is.null(pool$poolSize$autoscaleFormula)) {
        stop("Missing autoscaleFormula entry")
      }

      if (is.null(pool$poolSize$dedicatedNodes$min)) {
        stop("Missing dedicatedNodes$min entry")
      }

      if (is.null(pool$poolSize$dedicatedNodes$max)) {
        stop("Missing dedicatedNodes$max entry")
      }

      if (is.null(pool$poolSize$lowPriorityNodes$min)) {
        stop("Missing lowPriorityNodes$min entry")
      }

      if (is.null(pool$poolSize$lowPriorityNodes$max)) {
        stop("Missing lowPriorityNodes$max entry")
      }

      stopifnot(is.character(pool$name))
      stopifnot(is.character(pool$vmSize))
      stopifnot(is.character(pool$poolSize$autoscaleFormula))
      stopifnot(pool$poolSize$autoscaleFormula %in% names(autoscaleFormula))

      stopifnot(pool$poolSize$dedicatedNodes$min <= pool$poolSize$dedicatedNodes$max)
      stopifnot(pool$poolSize$lowPriorityNodes$min <= pool$poolSize$lowPriorityNodes$max)
      stopifnot(pool$maxTasksPerNode >= 1)

      stopifnot(is.double(pool$poolSize$dedicatedNodes$min))
      stopifnot(is.double(pool$poolSize$dedicatedNodes$max))
      stopifnot(is.double(pool$poolSize$lowPriorityNodes$min))
      stopifnot(is.double(pool$poolSize$lowPriorityNodes$max))
      stopifnot(is.double(pool$maxTasksPerNode))

      TRUE
    }
  )
)

`validation` <- validationClass$new()
