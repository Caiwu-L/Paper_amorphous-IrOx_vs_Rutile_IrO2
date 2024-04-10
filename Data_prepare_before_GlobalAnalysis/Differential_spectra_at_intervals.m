%imput SEC_DOD data with iR correction 
filename1='A12_50_degree_SEC_0.6_1.53_measuredSECsmoothDOD_iR_23.14ohm_smooth200_interval_15mVs';
filename=strcat(filename1,'.csv')
Data=csvread(filename);
Potential_array=Data(1,2:end);
Wavelength_array=Data(2:end,1);
Spectra=Data(2:end,2:end)
length=length(Wavelength_array)
% add a zero colum in the initial and delete the final cloum
Reference=[(zeros(length,1)),Spectra]
Reference=Reference(:,1:end-1)

%subtract spectra with the one before
Spectra_difference=Spectra-Reference
%Plot

S = plot(Wavelength_array,Spectra_difference');

%write data
Wavelength_array=[0;Wavelength_array]
Potential_and_spectra=[Potential_array;Spectra_difference]
Differential_data=[Wavelength_array,Potential_and_spectra]

