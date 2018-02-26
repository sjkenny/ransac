# RANSAC
### RANSAC geometric model fitting for point clouds

Fitting geometric models to data with outliers

RANSAC (RANdom SAmple Consensus) is an iterative method of fitting a given model to data containing outliers.
In the case of 2D or 3D point clouds, a geometric model is defined, and inliers are calculated according to some
relationship to the model geometry (e.g. points within a specified distance are marked as inliers).  The variable
model parameters are randomly generated N times, after which the set with the highest number of inliers is selected 
as the best fit.

### Dependencies
[STORM image I/O](https://github.com/sjkenny/common) for STORM molecule lists generated with Insight3
- OpenMolListTxt for .txt molecule lists
- OpenMolList for .bin molecule lists
- WriteMolBinNXcYcZc for saving molecule list corresponding to model inliers

### Usage

ransac_circle, ransac_line, ransac_ring, and ransac_plane can be run as MATLAB scripts with user-specified 2D or 3D
(for ransac_plane only) point cloud coordinates.  STORM molecule lists are loaded by default.  User-specified coordinates
should be x,y,z column vectors.  Fixed model parameters, as well as number of ransac iterations, must be specified.

### Example: ring fitting
![Example](https://i.imgur.com/4B8W2Co.gif)

In this case, random sets of three points are sampled in each iteration and are used to define a circle.  The number of inliers,
calculated as the number of points within a given distance threshold to the circle's edge, is used as the fitting score.

RANSAC model fitting rapidly approaches a good solution when the number of random parameters is small (for the ring-fitting case,
N=3):

![Goodness-of-fit](https://i.imgur.com/skFVGHh.png)
