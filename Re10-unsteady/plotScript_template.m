clear
clc
close all

srcDir = 'D:\Dropbox\paper_FilteredDragForceModelforParcel-BasedApproaches\raw\comparePhiPDistribution';
cd(srcDir)

j=1;
fileName{j} = 'phiPStats_resolvedDEM_filter0.dat'; j=j+1;
fileName{j} = 'phiPStats_resolvedDEM_filter4.dat'; j=j+1;
fileName{j} = 'phiPStats_DPM_alpha8_filter0.dat'; j=j+1;

 
k=1;
comparePlotLegend{k}='$CFD-DEM, FG$';k=k+1;
comparePlotLegend{k}='$CFD-DEM, FG, filtered$';k=k+1;
comparePlotLegend{k}='$CFD-DPM, CG, \alpha=8$';k=k+1;


%main switches
plotSkip = 1;
xMinPlot = 0.0;
xMaxPlot = 0.275;
yMaxPlot = 0.60;
yMinPlot = 0.0;

run('D:\Dropbox\matlab\formatting')
symbolArrayCS{1}='ro--';
faceColorArray{1}='r';
lineWidthMultiplicator{1}=1;

symbolArrayCS{2}='bo--';
faceColorArray{2}='w';
lineWidthMultiplicator{2}=1;

symbolArrayCS{3}='k^-';
faceColorArray{3}='w';
lineWidthMultiplicator{3}=2;


%% Plot

plotId=1;
cd(srcDir)

for iF=1:size(fileName,2)
 [header, data] = hdrload(fileName{iF});
 h = ...
 errorbar( data(1:plotSkip:end,1), data(1:plotSkip:end,2), ...
           data(1:plotSkip:end,3), ...
           symbolArrayCS{plotId}, ...
           'LineWidth', lineWidth*lineWidthMultiplicator{plotId}, ...
           'MarkerSize', markerSize, ...
           'MarkerFaceColor', faceColorArray{plotId} ...
       )
 errorbar_tick(h, 30);
 plotId = plotId + 1;
 hold on
end

cd(srcDir)

set(0, 'defaultTextInterpreter', 'latex'); 
box on

xlim([xMinPlot xMaxPlot])
ylim([yMinPlot yMaxPlot])
set(gca, 'XTick', [0:.05:100])
%set(gca, 'YTick', [0:.2:100])
xlabel('$<\phi_{p}>$','interpreter','latex') 
ylabel('$\big\{ \bar{\phi}_{p,i} \big\}, \sigma_{\bar{\phi}_{p,i}} $','interpreter','latex') 

leg = legend( comparePlotLegend, 'interpreter', 'latex');
legend('boxoff')
set(leg,'location','NorthWest'); 

xlhand = get(gca,'xlabel');ylhand = get(gca,'ylabel');
set(xlhand,'Position',get(xlhand,'Position') - [0 0.0015 0])
set(ylhand,'Position',get(ylhand,'Position') - [0.001 0 0])
makeXYPlotPretty
set(gca, 'Position', get(gca, 'OuterPosition') + 1 *...
    [0.25 0.25 -0.45 -0.35]);
%cm=1-hot(40)
%colormap(cm)
set(gcf, 'paperunits', 'centimeters', 'paperposition', [0 0 20 18])
print('-depsc',[fileName{1}(1:end-4),'.eps'])
