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
* 3. Create single measurement classifier to filter out "mega-cells"
*         Classify > Object classification > Create single measurement classifier
*         [Object filter= Detections (all)
*          Channel filter= No filter (allow all channels)
*          Measurement= Nucleus: Max diameter um
*          Threshold= 20
*          Above threshold= Unclassified
*          Below threshold= Ignore*
*          
*          Tick 'Live preview' just coz it's more fun that way
*          Classifier name = mega_cell]
* 
*       > Save
*/

// tissue detection
createAnnotationsFromPixelClassifier("detect_tissue", 0.0, 0.0, "DELETE_EXISTING", "INCLUDE_IGNORED", "SELECT_NEW")
// cell detection by DAPI
evaluate(new File("/Volumes/Elements_1/stampede_mif/groovy-scripts/stardist-fluorescence-cell-detection.groovy"))
// delete nucleus that are too big
runObjectClassifier("mega_cell")
selectObjectsByClassification(null);
clearSelectedObjects(true);

