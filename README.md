# connCirclePlot
This is a custom code to plot connectivity values in the brain using a rwb colormap in a circlular graph in Matlab.

## Description
connCirclePlot Plot creates a circular graph to illustrate connections/connectivity in a network.
### Syntax
connCirclePlot(X)  
connCirclePlot(X,'PropertyName',propertyvalue,...)  
h = connCirclePlot(...)

#### Required input arguments.
X : A symmetric matrix of numeric or logical values.

#### Optional properties.
Label   : A cell array of N strings.  
MinVal  : A numeric value for the min value for the linewidth and colorbar.  
MaxVal  : A numeric value for the max value for the linewidth and colorbar.  
TextSize: A numeric value for the min value for the text size of the labels.  
MaxLineThickness  : A numeric value for the max thickness the lines.  
ShowColorbar: Boolean value that indicates whether to show the colorbar.


Author: Jan-Luca Schröder
