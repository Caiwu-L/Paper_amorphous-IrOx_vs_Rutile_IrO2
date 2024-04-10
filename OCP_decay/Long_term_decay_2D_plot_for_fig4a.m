%Enter the value of t(0) 
t_val = 31.68;
filename1='OCV-1.05-1.22-1000sssOSP-SP_31.6_to_1000s';
filename=strcat(filename1,'.csv');
filename2='WL';
filename2_=strcat(filename2,'.csv');


%Enter the filename for the SEC data
SEC_data_array  = csvread(filename);
WL_array  = csvread(filename2_);

%Find potential and wavelength data from arrays
% get data array also removing padding 0 from potential array
time_array  = SEC_data_array(1,2:end);
wavelengths_array0 = SEC_data_array(:,1);
wavelengths_array=WL_array(:,1);
wavelengths_array=[0;wavelengths_array];
data_array= SEC_data_array(2:end,2:end);

%Find position of reference time in array
Delta_t=abs(time_array-t_val);
t_valmin=min(Delta_t);
time_TF=Delta_t==t_valmin;
t_val2=time_array(time_TF);

c = ismember(time_array, t_val2);
indexes = find(c);
time_array2=time_array(indexes:end)';


% get regerance array using logical indexing

Ref_array=data_array(:,c);
log_RA=log10(Ref_array);

% calculate DOD array
N=size(data_array);
N=N(2);

for i=1:N
    
    DOD(:,i)=-log10(data_array(:,i))+log_RA;
end 
N=size(data_array);
N=N(2);

for i=1:N
    
   DOD_smooth(:,i)=smooth(DOD(:,i),200,'sgolay',3);
end 
% get the data region that is more than the ref potential
output_data=DOD(:,indexes:end);
output_dataS=DOD_smooth(:,indexes:end);
% remove leading zero from WL array
output_wavelength=wavelengths_array(2:end);
%Plot data
columns = size(output_dataS);
columns = columns(2);
set(0,'DefaultAxesColorOrder',jet(columns))

%Figure
figure1 = figure('Color',[1 1 1]);
colormap(jet);

% Create axes
axes1 = axes('Parent',figure1,'units','centimeters',...
    'Position',[3 3 8 4]);
axes1.Box='on';
axes1.LineWidth = 0.5;
hold(axes1,'on');


% Create surface
surface(axes1,log10(time_array2-t_val2),output_wavelength,output_dataS,...
    'EdgeColor','None',...
    'CData',output_dataS);


% Create ylabel
ylab = ylabel('Wavelength (nm)','FontName','Arial','FontSize',9);
% Create xlabel
xlabel('Log [time (s)]','FontName','Arial','FontSize',9);

% preserve the X-limits of the axes
 xlim(axes1,[-1 3]);
% preserve the Y-limits of the axes
 ylim(axes1,[420 840]);

 
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'CLim',[-0.01 0],'Colormap',...
    [0.692307692307692 0 0;0.811339894673228 0.236157299490633 0.00249071915738583;0.874901641568308 0.459468186134853 0.0391398724732058;0.843088023088023 0.658619158619159 0.134534354534355;0.703747363747364 0.816292596292596 0.296252636252636;0.504884004884005 0.885592185592186 0.495115995115995;0.303747363747364 0.821762681762682 0.696252636252636;0.138192918192918 0.667570207570208 0.828240648240648;0.0402252068918735 0.468237688237688 0.830837064170398;0.00255978589311922 0.241489251489251 0.718186134852802;0 0 0.538461538461539],...
    'FontName','Arial','FontSize',8,'LabelFontSizeMultiplier',1,...
    'TitleFontSizeMultiplier',1,'XTick',[-1 0 1 2 3],'XTickLabel',...
    {'-1','0','1','2','3'},'YTick',[500 600 700 800],'YTickLabel',...
    {'500','600','700','800'});
% Create colorbar
cb = colorbar(axes1,'Position',...
    [0.757440476004212 0.269047619047619 0.0250952380952379 0.361904761904762],...
    'Ticks',[-0.01 -0.008 -0.006 -0.004 -0.002 0],...
    'TickLabels',{'-10','-8','-6','-4','-2','0'});
% Adding a label to the colorbar
ylabel(cb, 'Absorption decay (m ΔO.D.)', 'FontSize', 8, 'FontName', 'Arial');


%title('SEC data summary')
% put it all together
WL = SEC_data_array(:,1);
Final=[time_array;DOD];
Final=[WL,Final];

FinalS=[time_array;DOD_smooth];
FinalS=[WL,FinalS];

fileN=strcat(filename1,'_DOD.csv');
fileN2=strcat(filename1,'_SMOOTH_','DOD.csv');

export_fig('Decay_spectra_1.tif',figure1,'-r600')
%csvwrite(fileN,Final);
%csvwrite(fileN2,FinalS);
clear all
clc