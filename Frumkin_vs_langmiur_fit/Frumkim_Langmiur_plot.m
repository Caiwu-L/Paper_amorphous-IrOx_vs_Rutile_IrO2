%input data
%%
filename='Population_base'
filename1=strcat(filename,'.csv');
Data=readtable(filename1)
Data=table2array(Data)
%select data range
Potential=Data(:,1); 
Pop1=Data(:,4);
%Pop2=Data(:,3);
%Pop3=Data(:,4);

%convert population to coverage, using maximum of Pop1 as upper bound.
Max_Pop=2.22E16 %check number from raw data, not usally as maxium but the mean of mxiumn
Theta1=Pop1./Max_Pop;
%Theta2=Pop2./Max_Pop;
%Theta3=Pop3./Max_Pop;

% cut potential range for fitting
Start_potential=1.05
End_potential=1.48
Potential_index=Potential>=Start_potential&Potential<=End_potential;
Potential_cut=Potential(Potential_index);
Theta_cut1=Theta1(Potential_index);
plot(Potential_cut,Theta_cut1)
%Theta_cut2=Pop2(Potential_index);
%Theta_cut3=Pop2(Potential_index);

%langmir fitting FE=DeltaG=Delta G0+ RTln[Theta/(1-theta)]
%R=8.314;
%T=298;
%F=96485;
%E0=1.3;
%E_over=Potential_cut-E0;
%K0=exp(-F*E0/(R*T))

%%
%Langmiur Function plot
E0=1.502;
x=[0.001:0.001:0.999];
%(r/F) value, unit eV/coverage
y_langmiur=0.0256*log(x./(1-x))+E0;
plot(x,y_langmiur)
hold on
plot(Theta_cut1,Potential_cut);
lang_fit=[x',y_langmiur'];
%write data
save_name='%s_langmiur_fit_E=%d.csv'
csvwrite(sprintf(save_name, filename, E0),lang_fit);
%%
%Frumkin function plot 
E0=1.395;
r=0.15;
x=[0.001:0.001:0.999];
y_frumkin=0.0256*log(x./(1-x))+r*x+E0;
plot(x,y_frumkin);
hold on
%plot(Theta_cut1,Potential_cut);
frumkin_fit=[x',y_frumkin'];
save_name_2='%s_frumkin_fit_E=%dr=%d.csv'
csvwrite('DFT_Frumkin_E0=1.55 r=0.20.csv',frumkin_fit)
%csvwrite(sprintf(save_name_2, filename,E0,r),frumkin_fit);
%langmuir function plot 


%%