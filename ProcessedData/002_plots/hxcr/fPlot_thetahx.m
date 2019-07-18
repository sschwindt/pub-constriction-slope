function[] = fPlot_thetahx(x_a,x_b,x_c, xInterp_a, ...
                y_a,y_b,y_c, yInterp_a, write2disc)
% Y = matrix with 3 columns

scrsz = get(0,'ScreenSize');
% scrsz =   1 1 1920 1200
%scrsz(4) = scrsz(4)*4;
fontS = 36;
MarkerS = 17;

% create gray scale colormap
cmap = contrast(ones(1,10));
colors = colormap(cmap);

colors=zeros(size(colors));
colors(7,:)=[0 0 0];
color_conf =[0 0 0 0.35];
lWidth_conf = 50;
%other:{'+','o','diamond','v','square','pentagram','x','^','*','>','h','<'};
mStyles = {'o','square','v','none'};
mStyles_b = {'h','diamond','^','none'};
lStyles = {'none','-','-.'};

figure1 = figure('Color',[1 1 1],'Position',3*[1 scrsz(3) scrsz(3)/8 scrsz(3)]);


axes1 = axes('Parent',figure1,'FontSize',fontS,...
    'FontName','TimesNewRoman','GridLineStyle','-',...
    'XTickLabel',{'0.0','0.5','1.0','1.5','2.0'},...
    'XTick',0:0.5:2,...
    'YTickLabel',{'','0.2','0.4','0.6','0.8','1.0'},...
    'YTick',0.0:.2:1.,...
    'LineWidth', 3);

xlim(axes1,[0. 2]);
ylim(axes1,[0. 1]);
set(axes1,'Layer','top','Clipping','on','ClippingStyle','rectangle');
hold(axes1,'all');
box(axes1,'on');
grid(axes1,'off');


legend('off')
%% VERT + LAT with Qb (for legend)-----------------------------------------
% create plot of theta 2p-vert
plot0(1) = plot(x_a(:,1),y_a(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,3},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName',' Pressurized flow  (\it{S}\rm = 0.020)');

% create plot of theta 2p-lat
plot0(numel(plot0)+1) = plot(x_b(:,1),y_b(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,3},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName',' Free surface flow ({\itS} = 0.020)');

% create plot of theta 4p-vert
plot0(numel(plot0)+1) = plot(x_a(:,2),y_a(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,2},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName',' Pressurized flow  (\it{S}\rm = 0.035)');

% create plot of theta 4p-lat
plot0(numel(plot0)+1) = plot(x_b(:,1),y_b(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,2},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName',' Free surface flow (\it{S}\rm = 0.035)');

% create plot of theta 6p-vert
plot0(numel(plot0)+1) = plot(x_a(:,3),y_a(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName',' Pressurized flow  (\it{S}\rm = 0.055)');

% create plot of theta 6p-lat
plot0(numel(plot0)+1) = plot(x_b(:,3),y_b(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,1},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName',' Free surface flow (\it{S}\rm = 0.055)');




%% CONFIDENCE OF REG curve 
plot(xInterp_a,yInterp_a,...
    'Color',color_conf,...
    'LineWidth',lWidth_conf*1.5,'LineStyle',lStyles{1,2},...
    'Marker','none','MarkerSize',90,...
    'DisplayName','Confidence interval');
%set(plot1(numel(plot1)),'Color',[0.2 0.2 0.2 0.2])

%% COMBINED with Qb -------------------------------------------------------

% create plot of theta 2p-comb
plot(x_c(:,1),y_c(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,3},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized flow');

% create plot of theta 4p-comb
plot(x_c(:,2),y_c(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,2},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized flow');

% create plot of theta 6p-comb
plot(x_c(:,3),y_c(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized flow');

%%  REGRESSION
% regression curve - confidence 
plot(xInterp_a,yInterp_a,...
    'Color',colors(7,:),...
    'LineWidth',3,'LineStyle',lStyles{1,2},...
    'Marker','none',...
    'DisplayName','Interpolation subcritical');

%% LINE UP
fMakeXgrid(0.5:0.5:1.5,[0,1],0.5);
fMakeYgrid([0,2],0.2:0.2:0.8,0.5);
fMakeYgrid([0,2],0,3); % redraw y-axis

% Create xlabel
xlabel('Relative upstream water depth{\ith_{*}} [-]','FontSize',fontS,'FontName','TimesNewRoman');
% Create ylabel
ylabel('\theta [-]',...
    'FontSize',fontS,...
    'FontName','TimesNewRoman');
% create legend here
lgnd = legend(plot0);
set(lgnd,'Location','southoutside','EdgeColor',[1 1 1]);


if write2disc
    cd('figures');
    export_fig thetahx.eps -eps
    export_fig thetahx.pdf -pdf
    cd ..
    disp('Figure (thetahx) written to disc (figures folder).');
    close all;
end
