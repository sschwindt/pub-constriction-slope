function[] = fPlot_cxFr0(x_c, the_c, xInterp_c, y_c, yInterp_c, write2disc)
% Y = matrix with 3 columns

scrsz = get(0,'ScreenSize');
% scrsz =   1 1 1920 1200
%scrsz(4) = scrsz(4)*4;
fontS = 46;
MarkerS = 24;

% create gray scale colormap
cmap = contrast(ones(1,10));
colors = colormap(cmap);

colors=zeros(size(colors));
colors(7,:)=[0 0 0];
color_conf =[0 0 0 0.35];
lWidth_conf = 90;
%other:{'+','o','diamond','v','square','pentagram','x','^','*','>','h','<'};
mStyles = {'o','square','v','none'};
lStyles = {'none','-','-.'};

figure1 = figure('Color',[1 1 1],'Position',[1 scrsz(3) scrsz(3)/1.6 scrsz(3)]);


axes1 = axes('Parent',figure1,'FontSize',fontS,...
    'FontName','Arial','GridLineStyle','-',...
    'XTickLabel',{'1.0','2.0','3.0','4.0','5.0'},...
    'XTick',1:1:5,...
    'YTickLabel',{'','0.2','0.4','0.6','0.8','1.0'},...
    'YTick',0.0:0.2:1.,...
    'LineWidth', 3);
hold(axes1,'all');
box(axes1,'on');
grid(axes1,'off');

xlim(axes1,[1. 5]);
ylim(axes1,[0. 1]);

% cut (clip) lines outside of axis !! does not work for markers!
set(axes1,'Layer','top','Clipping','on','ClippingStyle','rectangle');

% create plot of Fr0 2p
plot1(1) = plot(x_c(:,1),y_c(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,3},'MarkerSize',MarkerS,...
    'DisplayName',' S = 0.020');

% create plot of Fr0 4p
plot1(2) = plot(x_c(:,2),y_c(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,2},'MarkerSize',MarkerS,...
    'DisplayName',' S = 0.035');
% create plot of Fr0 6p
plot1(3) = plot(x_c(:,3),y_c(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'DisplayName',' S = 0.055');

% create legend here
lgnd = legend(axes1,'show');
set(lgnd,'Location','NorthWest','LineWidth',1);

% create plot of Fr0 2p with bedload
plot1(4) = plot(the_c(:,1),y_c(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,3},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName',' S = 0.02');

% create plot of Fr0 4p with bedload
plot1(5) = plot(the_c(:,2),y_c(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,2},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName',' S = 0.035');
% create plot of Fr0 6p with bedload
plot1(6) = plot(the_c(:,3),y_c(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'DisplayName',' S = 0.055');

%legend boxoff
%set(lgnd,'color','none');
% regression curve - confidence
plot1(7) = plot(xInterp_c,yInterp_c,...
    'Color',color_conf,...
    'LineWidth',lWidth_conf,'LineStyle',lStyles{1,2},...
    'Marker',mStyles{1,4},...
    'DisplayName',' S = 0.02');


% regression curve 
plot1(8) = plot(xInterp_c,yInterp_c,...
    'Color',colors(7,:),...
    'LineWidth',3,'LineStyle',lStyles{1,2},...
    'Marker',mStyles{1,4},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Interpolation curve 2p');

fMakeXgrid(2:1:4,[0,1],0.5);
fMakeYgrid([1,5],0.2:0.2:0.8,0.5);

% Create xlabel
xlabel('Relative contraction a_*\cdot b_* [-]','FontSize',fontS,'FontName','Arial');
% Create ylabel
ylabel('Upstream Froude number Fr_0 [-]',...
    'FontSize',fontS,...
    'FontName','Arial');



if write2disc
    cd('figures');
    export_fig cxFr0.png -png
    export_fig cxFr0.eps -eps
    cd ..
    disp('Figure (cxFr0) written to disc (figures folder).');
    close all;
end

