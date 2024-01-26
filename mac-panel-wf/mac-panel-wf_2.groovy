/**
* Prep for script:
* 1. Create single measurement classifier to filter out "mega-cells"
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

// delete nucleus that are too big
runObjectClassifier("mega_cell")
selectObjectsByClassification(null);
clearSelectedObjects(true);
