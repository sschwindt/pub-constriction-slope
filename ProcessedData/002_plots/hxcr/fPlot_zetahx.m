function[] = fPlot_zetahx(x_a,x_b,x_c,the_a, the_b, the_c, xInterp_a, xInterp_b, ...
                            y_a,y_b,y_c, yInterp_a, yInterp_b, write2disc)
% Y = matrix with 3 columns

scrsz = get(0,'ScreenSize');
% scrsz =   1 1 1920 1200
%scrsz(4) = scrsz(4)*4;
fontS = 28;
MarkerS = 17;

% create gray scale colormap
cmap = contrast(ones(1,10));
colors = colormap(cmap);

colors=zeros(size(colors));
colors(7,:)=[0 0 0];
color_conf =[0 0 0 0.35];
lWidth_conf = 90;
%other:{'+','o','diamond','v','square','pentagram','x','^','*','>','h','<'};
mStyles = {'o','square','v','none'};
mStyles_b = {'h','diamond','^','none'};
lStyles = {'none','-','-.'};

figure1 = figure('Color',[1 1 1],'Position',3*[1 scrsz(3) scrsz(3)/8 scrsz(3)]);


axes1 = axes('Parent',figure1,'FontSize',fontS,...
    'FontName','TimesNewRoman','GridLineStyle','-',...
    'XTickLabel',{'0.00','0.25','0.50','0.75','1.00'},...
    'XTick',0:0.25:1,...
    'YTickLabel',{'','1.0','2.0','3.0','4.0'},...
    'YTick',0.0:1:4.,...
    'LineWidth', 3);
xlim(axes1,[0. 1]);
ylim(axes1,[0. 4]);
set(axes1,'Layer','top','Clipping','on','ClippingStyle','rectangle');
hold(axes1,'all');
box(axes1,'on');
grid(axes1,'off');


%% VERT + LAT without Qb (for legend) -------------------------------------
% create plot of zetax 2p-vert
plot0(1) = plot(x_a(:,1),y_a(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,3},'MarkerSize',MarkerS,...
    'DisplayName',' Pressurized flow  (S = 0.020)');

% create plot of zetax 2p-lat
plot0(2) = plot(x_b(:,1),y_b(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,3},'MarkerSize',MarkerS,...
    'DisplayName',' Free surface flow (S = 0.020)');

% create plot of zetax 4p-vert
plot0(3) = plot(x_a(:,2),y_a(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,2},'MarkerSize',MarkerS,...
    'DisplayName',' Pressurized flow  (S = 0.035)');

% create plot of zetax 4p-lat
plot0(4) = plot(x_b(:,2),y_b(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,2},'MarkerSize',MarkerS,...
    'DisplayName',' Free surface flow (S = 0.035)');

% create plot of zetax 6p-vert
plot0(5) = plot(x_a(:,3),y_a(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'DisplayName',' Pressurized flow  (S = 0.055)');

% create plot of zetax 6p-lat
plot0(6) = plot(x_b(:,3),y_b(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,1},'MarkerSize',MarkerS,...
    'DisplayName',' Free surface flow (S = 0.055)');

% create legend here
lgnd = legend(axes1,'show');
set(lgnd,'Location','southoutside','EdgeColor',[1 1 1]);
%% CONFIDENCE INTERVALLS
% regression curve - confidence SUBCRIT
plot0(7) = plot(xInterp_a,yInterp_a,...
    'Color',color_conf,...
    'LineWidth',lWidth_conf,'LineStyle',lStyles{1,2},...
    'Marker','none','MarkerSize',90,...
    'DisplayName','Confidence subcritical');
set(plot0(1),'Color',[0.2 0.2 0.2 0.2])

% regression curve - confidence SUPERCRIT
plot0(8) = plot(xInterp_b,yInterp_b,...
    'Color',color_conf,...
    'LineWidth',lWidth_conf,'LineStyle',lStyles{1,1},...
    'Marker','o','MarkerSize',60,...
    'MarkerFaceColor',[0.702 0.702 0.702],...
    'MarkerEdgeColor',[0.702 0.702 0.702],...
    'DisplayName','Confidence subcritical');

%% VERT + LAT without Qb (for legend) -------------------------------------
% create plot of zetax 2p-vert
plot1(1) = plot(x_a(:,1),y_a(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,3},'MarkerSize',MarkerS,...
    'DisplayName',' Pressurized flow (S = 0.020)');

% create plot of zetax 2p-lat
plot1(2) = plot(x_b(:,1),y_b(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,3},'MarkerSize',MarkerS,...
    'DisplayName',' Free surface flow (S = 0.020)');

% create plot of zetax 4p-vert
plot1(3) = plot(x_a(:,2),y_a(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,2},'MarkerSize',MarkerS,...
    'DisplayName',' Pressurized flow (S = 0.035)');

% create plot of zetax 4p-lat
plot1(4) = plot(x_b(:,2),y_b(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,2},'MarkerSize',MarkerS,...
    'DisplayName',' Free surface flow (S = 0.035)');

% create plot of zetax 6p-vert
plot1(5) = plot(x_a(:,3),y_a(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'DisplayName',' Pressurized flow (S = 0.055)');

% create plot of zetax 6p-lat
plot1(6) = plot(x_b(:,3),y_b(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,1},'MarkerSize',MarkerS,...
    'DisplayName',' Free surface flow (S = 0.055)');
%% COMBINED without Qb ----------------------------------------------------

% create plot of zetax 2p-comb
plot1(7) = plot(x_c(:,1),y_c(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,3},'MarkerSize',MarkerS,...
    'DisplayName','Pressurized flow');

% create plot of zetax 4p-comb
plot1(8) = plot(x_c(:,2),y_c(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,2},'MarkerSize',MarkerS,...
    'DisplayName','Pressurized flow');

% create plot of zetax 6p-comb
plot1(9) = plot(x_c(:,3),y_c(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'DisplayName','Pressurized flow');

%% VERT + LAT with Qb -----------------------------------------------------
% create plot of zetax 2p-vert
plot1(10) = plot(the_a(:,1),y_a(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,3},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized flow (S = 0.020)');

% create plot of zetax 2p-lat
plot1(11) = plot(the_b(:,1),y_b(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,3},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Free surface flow');

% create plot of zetax 4p-vert
plot1(12) = plot(the_a(:,2),y_a(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,2},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized flow (S = 0.035)');

% create plot of zetax 4p-lat
plot1(13) = plot(the_b(:,2),y_b(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,2},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Free surface flow (S = 0.035)');

% create plot of zetax 6p-vert
plot1(14) = plot(the_a(:,3),y_a(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized flow (S = 0.055)');

% create plot of zetax 6p-lat
plot1(15) = plot(the_b(:,3),y_b(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,1},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Free surface flow (S = 0.055)');

%% COMBINED with Qb -------------------------------------------------------

% create plot of zetax 2p-comb
plot1(16) = plot(the_c(:,1),y_c(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,3},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized flow');

% create plot of zetax 4p-comb
plot1(17) = plot(the_c(:,2),y_c(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,2},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized flow');

% create plot of zetax 6p-comb
plot1(18) = plot(the_c(:,3),y_c(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized flow');

%% REGRESSION CURVES

% regression curve SUBCRIT
plot1(19) = plot(xInterp_a,yInterp_a,...
    'Color',colors(7,:),...
    'LineWidth',3,'LineStyle',lStyles{1,2},...
    'Marker',mStyles{1,4},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Interpolation subcritical');

% regression curve SUPERCRIT
plot1(20) = plot(xInterp_b,yInterp_b,...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,2},...
    'Marker',mStyles{1,4},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Interpolation subcritical');


%% LINE UP
fMakeXgrid(0.25:0.25:0.75,[0,4],0.5);
fMakeYgrid([0,2],1:1:3,0.5);
fMakeYgrid([0,2],0,3); % redraw y-axis



% Create xlabel
xlabel('Relative upstream water depth h_* [-]','FontSize',fontS,'FontName','TimesNewRoman');
% Create ylabel
ylabel('Head loss coefficient \zeta [-]',...
    'FontSize',fontS,...
    'FontName','TimesNewRoman');



if write2disc
    cd('figures');
    export_fig zetahx.png -png
    export_fig zetahx.eps -eps
    cd ..
    disp('Figure (zetahx) written to disc (figures folder).');
    close all;
end

