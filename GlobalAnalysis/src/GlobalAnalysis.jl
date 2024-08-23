module GlobalAnalysis

export importData, defineIRFTime, convolveIRF, maskData

include("TypeDefinitions.jl")
include("DataImport.jl")
include("IRFConvolution.jl")

directory = raw"C:\Users\lcw17\Desktop\Julia_deconvolution\test"

Data = importData(directory; miss="NaN")
Data = importData(directory)


end #module
