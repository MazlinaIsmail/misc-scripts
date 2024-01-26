/**
* Prep for script:
* 1. Create project
* 2. Create thresholder for tissue detection:
*        Classify > Pixel classification > Create thresholder
*        [Resolution: Low
*         Channel: Average channels
*         Prefilter: Gaussian
*         Smoothing sigma: 5
*         Threshold: 1
*         Above threshold: Ignore
*         Below threshold: Unclassified
*         Region: Image (non-empty regions)
*         Classifier name: detect_tissue]
* 
*      > Save
* 3. Click Create objects
* 
*/


// tissue detection
createAnnotationsFromPixelClassifier("detect_tissue", 0.0, 0.0, "DELETE_EXISTING", "INCLUDE_IGNORED", "SELECT_NEW")
// cell detection by DAPI
evaluate(new File("/Volumes/Elements_1/stampede_mif/groovy-scripts/stardist-fluorescence-cell-detection.groovy"))


