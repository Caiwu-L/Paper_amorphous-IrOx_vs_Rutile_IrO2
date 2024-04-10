E=1.51; % Potential (in V vs RHE) for volcano intended to construct
r=0:0.05:0.4; % interation parameter r range 
E0=0.7:0.05:1.9; % binding strength r range  

% E0 here is not the experimental detected start point, it is the midwave of a langmiur fit
% The start point should be E0-1/2(langmiur window),
% the window from 1% to 99% is around 235 mV for langmiur(1/2 langmiur=117mV)

% here we solve coverage at every E0 and r at potential E, by numerical solving frumkin isotherm 
for i=1:length(r)
    for j=1:length(E0)
        syms x
        Frumkin=0.0256*log(x./(1-x))+r(i)*x+E0(j)-E;
        
        theta=vpasolve(Frumkin==0, x, [0.0,1.0]);
        %canot find solution will return empty 
        if isempty(theta); 
            if 0.0256*log(0.999./(1-0.999))+r(i)*0.999+E0(j)<E;
            theta = 1;
            else 
            theta = 0;
            end
        end
       a=double(theta);
       S(i,j)=a;
    end
end


T=ones(1,25)% number of points for E0
G=(r'*T).*S+E0 %G=r*theta+E0
activity=-abs((G-1.6))  %definition of relative activity 
figure
plot(E0,S)
figure
plot(E0,activity)

%export data
coverage_data=[E0;S]  
r_1=[0;r']
coverage_data_1=[r_1,coverage_data]
csvwrite('Coverage_constant_potential_280mV_x=fit_potential_with1p6.csv',coverage_data_1)

activity_data=[E0;activity]
activity_data_1=[r_1,activity_data]
csvwrite('Activity_constant_potential_280mV_x=fit_potential_with1p6.csv',activity_data_1)


