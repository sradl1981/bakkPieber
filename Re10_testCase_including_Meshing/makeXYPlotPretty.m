grid off

box on

legend boxoff

set(0,'defaultaxesfontsize',fontSizeAxis);

set(0,'defaulttextfontsize',fontSizeAxis);

set(gca,'FontSize',fontSizeAxis);

set(gca,'FontWeight','normal');

xlhand = get(gca,'xlabel');

ylhand = get(gca,'ylabel');

set(xlhand,'fontsize',fontSizeLabel); set(ylhand,'fontsize',fontSizeLabel)

set(xlhand,'FontName','Times'); set(xlhand,'FontAngle','italic'); set(xlhand,'FontWeight','bold');

set(ylhand,'FontName','Times'); set(ylhand,'FontAngle','italic'); set(ylhand,'FontWeight','bold');

set(gcf, 'paperunits', 'centimeters')
