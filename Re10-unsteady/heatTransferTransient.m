%% Computing the Nu-Number and heat transfer rate for each timestep for transient heat transfer 

clear all
clc
close all
format compact


%% 1: load data from postprocessing files (cellSource and FaceSource data)

filename1= 'postProcessing/bedOfSpheres/volumeIntegratedSolidTemperature/40/cellSource.dat';
filename2= 'postProcessing/bedOfSpheres/averageSolidTemperature/40/cellSource.dat';
filename3= 'postProcessing/bedOfSpheres/averageSurfaceTemperature/40/faceSource.dat';


%% 2: parameters to change for analytic solution:

Re_target = 10 ;  % analytical solution is computed for this Re number
steps     = 9000 ;   % length of datafile to read in (is used to cut off time 
                % steps where sphere is almost cooled down completely;
                % number depends on write control settings in controlDict;

                
% process and material parameters of real case
T_0_sphere = 600 ;   % start temperature of sphere [K]
T_inlet = 300;      % inlet temperature of fluid [K]
d_particle = 1 ;    % average particle diameter [m]

rho_s = 1500 ;     % density solid  [kg/m³]
cp_s = 1000 ;      % heat capacity  solid [J/kg K]
lambda_s = 714.29;           % heat conductivity solid [W/m K]

rho_l = 1;          % density liquid [kg/m³]
cp_l = 1000;          % heat capacity liquid [J/kg K]
Pr = 0.70;            % Pr-number 
D_l = 0.68*10^-9   ; 
mu = 0.1;            % dynamic viscosity of liquid [kg/m s]

%% ************** END OF USER INPUT *************************

A_sphere= d_particle ^2*pi ;    % sphere surface 
Us = Re_target*mu/(rho_l* d_particle)             % superficial fluid velocity of HPLC-Column 1 [m/s]

Re = rho_l*Us*d_particle/mu   % Re-number
Sc = mu/(rho_l*D_l) ;        % Schmidt number
deltaT_max = T_0_sphere-T_inlet;    % maximum of temperature difference  
lambda_l = mu*cp_l/Pr;        % heat conductivity liquid
a_s = lambda_s/ (rho_s *cp_s)  ;% thermal conductivity solid [m²/s]
a_l = lambda_l/ (rho_l *cp_l) ; % thermal conductivity solid [m²/s]
zeta = lambda_l/lambda_s;       % conductivity ratio of fluid vs. solid




% Nu-Number Correlation from Book: Bubbles, Drops and Particles (Clift,
% Grace, Weber, 1978, Chapter 5)
% Valid for single sphere at 1 <= Re <= 400
                        % 0.25 <= Pr <= 100                           
Nu_CGW = (1+(1/Re*Pr)) ^(1/3) *Re^0.41 *Pr^(1/3) +1

% Ranz-Marshall Correlation 
% Valid for single sphere at  10 < Re < 10e5,
                           % 0.6 < Pr < 380                   
Nu_Ranz_Marshall = 2    + 0.6* Re^(1/2) *Pr^(1/3)

Nu_corr =Nu_Ranz_Marshall ;
alpha_corr = Nu_corr *lambda_l /d_particle;
Bi= (alpha_corr *d_particle) / lambda_s 

%% 
data1 = dlmread(filename1,'',3,0);
data2 = dlmread(filename2,'',3,0);
data3 = dlmread(filename3,'',3,0);


time = data1(1:steps ,1);

volIntegral_T = data1(1:steps,3);     % volume-integrated temperature of sphere
volMean_T = data2(1:steps ,3);         % volume- averaged temperature of sphere
surfaceMean_T = data3(1:steps,3);     % average temperature on sphere surface
                                 % flow averaged fluid temperature at outlet                                 
sum_alpha_mean = 0; 
sum_Fo = 0; 
steps_end = steps -1;    % cut off one step before end to avoid signal oscillation

% computing enthalpy difference of sphere between two time steps,
% computing the according Fo number and then computing the the 
% analytical solution for comparison

for i = 1:(length(volMean_T)-1)
    
    t_step(i)  = time(i+1) - time(i) ;                            % dt
   
    deltaHeat_sphere(i) = volIntegral_T(i+1)- volIntegral_T(i) ;  % dh
    
    qdot(i) = rho_s*cp_s*deltaHeat_sphere(i)/(t_step(i)*A_sphere) ; %dq
    
    deltaT_volume(i) = volMean_T(i) -  T_inlet ; 
    deltaT_surface(i) = surfaceMean_T(i) -  T_inlet  ;
    
    alpha_volume(i) = - qdot(i) /deltaT_volume(i) ;  
    Nu_volume = alpha_volume*d_particle/lambda_l;
    
    alpha_surface(i) = - qdot(i) /deltaT_surface(i) ;
    Nu_surface = alpha_surface*d_particle/lambda_l;

    
    Fo(i) = time(i)*a_s/ ((d_particle/2)^2);
    
    sum_alpha_mean = alpha_surface(i)*t_step(i) + sum_alpha_mean;
    
    %heatTransferCrank(Fo,Bi,T_0_sphere, T_inlet, d_particle );
    
     i=i+1;
     
end

alpha_mean_t = sum_alpha_mean/ sum(t_step) ; % time weighted heat transfer coeff.
Nu_mean= alpha_mean_t*d_particle/lambda_l  ;% Nu calculated with surface temperatures!

relativeError_corr = (Nu_mean-Nu_corr)/Nu_corr*100;
NuSurfMax=max(Nu_surface);
Numax=max([Nu_CGW; Nu_corr; NuSurfMax]);

Nu_vector= Nu_corr.*ones(1,steps_end);


%%%%%%%%%% Plotting the time evolution of the Nusselt number %%%%%%%%
set(0, 'defaultTextInterpreter', 'latex'); 
run('formatting.m')
box on

plot(Fo, Nu_volume, symbolArrayC{9}, 'LineWidth', lineWidth*lineWidthMultiplicator{1} );
hold on 
plot(Fo, Nu_surface, symbolArrayC{5},  'LineWidth', lineWidth*lineWidthMultiplicator{1} );
hold on
plot(Fo, Nu_vector, symbolArrayC{1}, 'LineWidth', lineWidth*lineWidthMultiplicator{1} );

%title (['transient Nu-number, Re=',num2str(Re_target)], 'interpreter','latex');
xlabel('$Fo$','interpreter','latex');
ylabel('$Nu$','interpreter','latex');
axis([0 max(Fo) 0 Numax+1]);
leg = legend ('$Nu_{volume}$', '$Nu_{surface}$', '$Nu_{Ranz-Marshall}$');
legend('boxoff')
set(leg,'location','NorthEast'); 
set(leg,'interpreter', 'latex');

set(gca, 'Position', get(gca, 'OuterPosition') + 1 *...
    [0.25 0.25 -0.45 -0.35]);
cm=1-hot(40);
colormap(cm);
set(gcf, 'paperunits', 'centimeters', 'paperposition', [0 0 21 18])
makeXYPlotPretty
print('-dpdf','-r300', ['/home/diplo/Matlab_routines/Nu_developedT_Re',num2str(Re_target)] ) 

%%%%%%%%%%%%%% Plotting the average sphere temperature over time%%%%%%%%%%

 Fo(steps)= Fo(steps_end)+1e-20; % create an additional time step for computing the last increments 
                                 % (so that all vectors are of same length)
 %heatTransferCrank(Fo,Bi,T_0_sphere, T_inlet, d_particle );

 %load('/home/diplo/Matlab_routines/coolingSphere');
 
Theta_vol = (volMean_T-T_inlet) / deltaT_max;
Theta_surf = (surfaceMean_T-T_inlet) / deltaT_max;
% Theta_surfCranck = (coolingSphere.T_surfCranck-T_inlet) / deltaT_max;



figure
plot (Fo, Theta_vol ,  symbolArrayC{9}, 'LineWidth', lineWidth*lineWidthMultiplicator{1});
hold on
plot (Fo, Theta_surf, symbolArrayC{5}, 'LineWidth', lineWidth*lineWidthMultiplicator{1});
hold on
%plot (Fo, Theta_surfCranck, symbolArrayC{1}, 'LineWidth', lineWidth*lineWidthMultiplicator{1});

xlabel('$Fo$','interpreter','latex');
ylabel('$\Theta_{Sphere} =  \frac{T-T_0}{T_{0,Sphere}-T_0} $','interpreter','latex');
axis([ 0 max(Fo) 0 1]); 

title (['$Re$ =',num2str(Re_target)], 'interpreter','latex');
leg1 = legend ('$\Theta_{vol}$', '$\Theta_{surface}$', '$\Theta_{Ranz-Marshall}$' );
legend('boxoff')
set(leg1,'location','NorthEast'); 
set(leg1,'interpreter', 'latex');


xlhand = get(gca,'xlabel');ylhand = get(gca,'ylabel');
set(xlhand,'Position',get(xlhand,'Position') - [0 0 0])
makeXYPlotPretty
set(gca, 'Position', get(gca, 'OuterPosition') + 1 *...
    [0.25 0.25 -0.45 -0.35]);
cm=1-hot(40);
colormap(cm);
set(gcf, 'paperunits', 'centimeters', 'paperposition', [0 0 21 18])
print('-dpdf','-r300', ['/home/diplo/Matlab_routines/Theta_developedT_Re',num2str(Re_target)] ) 

%%%%%%%%%%%% Displaying results for Nu %%%%%%%%%%%%

disp('Nusselt Number from Ranz-Marshall correlation is')
disp(Nu_Ranz_Marshall)
disp('time averaged Nusselt Number from simulation (computed with surface temperature) is')
disp(Nu_mean)
disp('relative error is (in %)')
disp(relativeError_corr)
