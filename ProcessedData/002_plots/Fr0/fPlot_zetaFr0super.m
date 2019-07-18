function[] = fPlot_zetaFr0super(x_b, the_b, xInterp_a, y_b, yInterp_a, write2disc)
% Y = matrix with 3 columns

scrsz = get(0,'ScreenSize');
% scrsz =   1 1 1920 1200
%scrsz(4) = scrsz(4)*4;
fontS = 30;
MarkerS = 17;

% create gray scale colormap
cmap = contrast(ones(1,10));
colors = colormap(cmap);

colors=zeros(size(colors));
colors(7,:)=[0 0 0];
color_conf =[0 0 0 0.35];
lWidth_conf = 70;
%other:{'+','o','diamond','v','square','pentagram','x','^','*','>','h','<'};
mStyles = {'o','square','v','none'};
mStyles_b = {'h','diamond','^','none'};
lStyles = {'none','-','-.'};

figure1 = figure('Color',[1 1 1],'Position',3*[1 scrsz(3) scrsz(3)/7 scrsz(3)]);


axes1 = axes('Parent',figure1,'FontSize',fontS,...
    'FontName','Arial','GridLineStyle','-',...
    'XTickLabel',{'0.05','0.08','0.11','0.14', '0.17','0.20'},...
    'XTick',0.05:0.03:0.2,...
    'YTickLabel',{'0.0','0.5','1.0','1.5','2.0'},...
    'YTick',0.0:0.5:2.,...
    'LineWidth', 3);
xlim(axes1,[0.05 0.2]);
ylim(axes1,[0. 2]);
set(axes1,'Layer','top','Clipping','on','ClippingStyle','rectangle');
hold(axes1,'all');
box(axes1,'on');
grid(axes1,'off');


%% LAT without Qb (for legend) -------------------------------------
% create plot of zetax 2p-lat
plot0(1) = plot(x_b(:,1),y_b(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,3},'MarkerSize',MarkerS,...
    'DisplayName',' Free surface flow (S = 0.020)');

% create plot of zetax 4p-lat
plot0(numel(plot0)+1) = plot(x_b(:,2),y_b(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,2},'MarkerSize',MarkerS,...
    'DisplayName',' Free surface flow (S = 0.035)');

% create plot of zetax 6p-lat
plot0(numel(plot0)+1) = plot(x_b(:,3),y_b(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,1},'MarkerSize',MarkerS,...
    'DisplayName',' Free surface flow (S = 0.055)');

% create legend here
lgnd = legend(axes1,'show');
set(lgnd,'Location','southoutside','EdgeColor',[1 1 1]);

%% CONFIDENCE INTERVALLS
% regression curve - confidence SUPERCRIT
plot0(numel(plot0)+1) = plot(xInterp_a,yInterp_a,...
    'Color',color_conf,...
    'LineWidth',lWidth_conf,'LineStyle',lStyles{1,2},...
    'Marker','none','MarkerSize',90,...
    'DisplayName','Confidence subcritical');
%set(plot0(1),'Color',[0.2 0.2 0.2 0.2])


%% LAT without Qb (for legend) -------------------------------------
% create plot of zetax 2p-lat
plot1(1) = plot(x_b(:,1),y_b(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,3},'MarkerSize',MarkerS,...
    'DisplayName',' Free surface flow\newline (S = 0.020)');

% create plot of zetax 4p-lat
plot1(numel(plot1)+1) = plot(x_b(:,2),y_b(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,2},'MarkerSize',MarkerS,...
    'DisplayName',' Free surface flow\newline (S = 0.035)');

% create plot of zetax 6p-lat
plot1(numel(plot1)+1) = plot(x_b(:,3),y_b(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,1},'MarkerSize',MarkerS,...
    'DisplayName',' Free surface flow\newline (S = 0.055)');


%% LAT with Qb -----------------------------------------------------

% create plot of zetax 2p-lat
plot1(numel(plot1)+1) = plot(the_b(:,1),y_b(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,3},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Free surface flow');

% create plot of zetax 4p-lat
plot1(numel(plot1)+1) = plot(the_b(:,2),y_b(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,2},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Free surface flow (S = 0.035)');

% create plot of zetax 6p-lat
plot1(numel(plot1)+1) = plot(the_b(:,3),y_b(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles_b{1,1},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Free surface flow (S = 0.055)');



%% REGRESSION CURVES

% regression curve SUPERCRIT
plot1(numel(plot1)+1) = plot(xInterp_a,yInterp_a,...
    'Color',colors(7,:),...
    'LineWidth',3,'LineStyle',lStyles{1,2},...
    'Marker',mStyles{1,4},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Interpolation subcritical');


%% LINE UP
fMakeXgrid(0.08:0.03:0.17,[0,2],0.5);
fMakeYgrid([0.05,0.2],0.5:0.5:1.5,0.5);


% Create xlabel
xlabel('Slope corrected contraction width b_*\cdot S [-]','FontSize',fontS,'FontName','Arial');
% Create ylabel
ylabel('Head loss coefficient \zeta [-]',...
    'FontSize',fontS,...
    'FontName','Arial');



if write2disc
    cd('figures');
    export_fig zetaFr0super.png -png
    export_fig zetaFr0super.eps -eps
    cd ..
    disp('Figure (zetaFr0) written to disc (figures folder).');
    close all;
end
