% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/xgb.model.dt.tree.R
\name{xgb.model.dt.tree}
\alias{xgb.model.dt.tree}
\title{Parse a boosted tree model text dump}
\usage{
xgb.model.dt.tree(feature_names = NULL, model = NULL, text = NULL,
  n_first_tree = NULL)
}
\arguments{
\item{feature_names}{character vector of feature names. If the model already
contains feature names, this argument should be \code{NULL} (default value)}

\item{model}{object of class \code{xgb.Booster}}

\item{text}{\code{character} vector previously generated by the \code{xgb.dump} 
function  (where parameter \code{with_stats = TRUE} should have been set).}

\item{n_first_tree}{limit the parsing to the \code{n} first trees. 
If set to \code{NULL}, all trees of the model are parsed.}
}
\value{
A \code{data.table} with detailed information about model trees' nodes.

The columns of the \code{data.table} are:

\itemize{
 \item \code{Tree}: ID of a tree in a model
 \item \code{Node}: ID of a node in a tree
 \item \code{ID}: unique identifier of a node in a model
 \item \code{Feature}: for a branch node, it's a feature id or name (when available);
             for a leaf note, it simply labels it as \code{'Leaf'}
 \item \code{Split}: location of the split for a branch node (split condition is always "less than")
 \item \code{Yes}: ID of the next node when the split condition is met
 \item \code{No}: ID of the next node when the split condition is not met
 \item \code{Missing}: ID of the next node when branch value is missing
 \item \code{Quality}: either the split gain (change in loss) or the leaf value
 \item \code{Cover}: metric related to the number of observation either seen by a split
                     or collected by a leaf during training.
}
}
\description{
Parse a boosted tree model text dump into a \code{data.table} structure.
}
\examples{
# Basic use:

data(agaricus.train, package='xgboost')

bst <- xgboost(data = agaricus.train$data, label = agaricus.train$label, max_depth = 2, 
               eta = 1, nthread = 2, nrounds = 2,objective = "binary:logistic")

(dt <- xgb.model.dt.tree(colnames(agaricus.train$data), bst))


# How to match feature names of splits that are following a current 'Yes' branch:

merge(dt, dt[, .(ID, Y.Feature=Feature)], by.x='Yes', by.y='ID', all.x=TRUE)[order(Tree,Node)]
 
}

