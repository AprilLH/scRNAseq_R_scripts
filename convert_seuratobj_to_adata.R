# One-shot setup for a clean reticulate + conda env that can run scCustomize::as.anndata()
# Run in a fresh R session

library(reticulate)

# 1) Install reticulate-managed Miniconda if needed

# 2) Point to conda executable
conda <- file.path(miniconda_path(), "condabin", "conda.bat")

# 3) Force classic solver to avoid the libmamba error
try(system2(conda, args = c("config", "--set", "solver", "classic")), silent = TRUE)

# 4) Recreate env cleanly
envname <- "scvelo_env"

# remove old env if it exists
envs <- tryCatch(conda_list()$name, error = function(e) character(0))
if (envname %in% envs) {
  conda_remove(envname = envname)
}

# create env with Python 3.10
conda_create(envname = envname, packages = c("python=3.10"))

# 5) Activate env in R
use_condaenv(envname, required = TRUE)

# 6) Install required Python packages
# anndata is required for scCustomize::as.anndata()
py_install(
  packages = c("anndata", "numpy", "pandas", "scipy", "h5py"),
  envname = envname,
  pip = TRUE
)

# 7) Verify
cat("Python config:\n")
print(py_config())

cat("\n'anndata' available? ", py_module_available("anndata"), "\n", sep = "")

# 8) Optional: run your export after verification
# library(scCustomize)
# as.anndata(
#   x = data_V3,
#   file_path = "~/",
#   file_name = "neutrophils_counts_only.h5ad"
# )
# Load Packages
library(Seurat)
library(rliger)
library(scCustomize)
library(qs)
data<-  seurat_obj_1
DefaultAssay(data) <- "RNA"

as.anndata(x = data, file_path = "./", file_name = "pbmc_anndata.h5ad")