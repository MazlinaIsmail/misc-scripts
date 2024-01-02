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
*/

createAnnotationsFromPixelClassifier("detect_tissue", 0.0, 0.0, "SPLIT", "DELETE_EXISTING", "INCLUDE_IGNORED", "SELECT_NEW")
evaluate(new File("/Volumes/Elements_1/stampede_mif/groovy-scripts/stardist-fluorescence-cell-detection.groovy"))

