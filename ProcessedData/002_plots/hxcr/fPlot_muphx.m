function[] = fPlot_muphx(x_a,x_c,the_a, the_c, xInterp_a, ...
                y_b1,y_b3, yInterp_a, write2disc)
% Y = matrix with 3 columns

scrsz = get(0,'ScreenSize');
% scrsz =   1 1 1920 1200
% scrsz(4) = scrsz(4)*4;
fontS = 56;
MarkerS = 20;
yPos = 0.82; % y position of the textbox
% create gray scale colormap
cmap = contrast(ones(1,10));
colors = colormap(cmap);

colors=zeros(size(colors));
colors(7,:)=[0 0 0];
color_conf =[0 0 0 0.35];

lWidth_conf = 70;
%other:{'+','o','diamond','v','square','pentagram','x','^','*','>','h','<'};
mStyles = {'o','square','v','none'};
lStyles = {'none','-','-.'};

figure1 = figure('Color',[1 1 1],'Position',[1 scrsz(3) scrsz(3)/1.6 scrsz(3)]);


axes1 = axes('Parent',figure1,'FontSize',fontS,...
    'FontName','TimesNewRoman','GridLineStyle','-',...
    'XTickLabel',{'0.0','0.2','0.4','0.6','0.8','1.0'},...
    'XTick',0.0:0.2:1,...
    'YTickLabel',{'','0.2','0.4','0.6','0.8','1.0'},...
    'YTick',0.0:0.2:1.,...
    'LineWidth', 3);
hold(axes1,'all');
box(axes1,'on');
grid(axes1,'off');

xlim(axes1,[0. 1]);
ylim(axes1,[0. 1]);

% cut (clip) lines outside of axis !! does not work for markers!
set(axes1,'Layer','top','Clipping','on','ClippingStyle','rectangle');
legend('off')
%% VERT + LAT without Qb (for legend) -------------------------------------
% create plot of mu 2p-vert
plot1(1) = plot(x_a(:,1),y_b1(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,3},'MarkerSize',MarkerS,...
    'DisplayName',' \it S\rm = 0.020');

% create plot of mu 4p-vert
plot1(numel(plot1)+1) = plot(x_a(:,2),y_b1(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,2},'MarkerSize',MarkerS,...
    'DisplayName',' \it S\rm = 0.035');

% create plot of mu 6p-vert
plot1(numel(plot1)+1) = plot(x_a(:,3),y_b1(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'DisplayName',' \it S\rm = 0.055');


%% COMBINED without Qb ----------------------------------------------------

% create plot of mu 2p-comb
plot(x_c(:,1),y_b3(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,3},'MarkerSize',MarkerS,...
    'DisplayName','Pressurized');

% create plot of mu 4p-comb
plot(x_c(:,2),y_b3(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,2},'MarkerSize',MarkerS,...
    'DisplayName','Pressurized');

% create plot of mu 6p-comb
plot(x_c(:,3),y_b3(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'DisplayName','Pressurized');

%% VERT + LAT with Qb -----------------------------------------------------
% create plot of mu 2p-vert
plot(the_a(:,1),y_b1(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,3},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized (I = 0.020)');

% create plot of mu 4p-vert
plot(the_a(:,2),y_b1(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,2},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized (I = 0.035)');

% create plot of mu 6p-vert
plot(the_a(:,3),y_b1(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized (I = 0.055)');

%% COMBINED with Qb -------------------------------------------------------

% create plot of mu 2p-comb
plot(the_c(:,1),y_b3(:,1),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,3},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized');

% create plot of mu 4p-comb
plot(the_c(:,2),y_b3(:,2),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,2},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized');

% create plot of mu 6p-comb
plot(the_c(:,3),y_b3(:,3),...
    'Color',colors(7,:),...
    'LineWidth',1,'LineStyle',lStyles{1,1},...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Pressurized');

%% REGRESSION CURVES
% confidence 
plot(xInterp_a,yInterp_a,...
    'Color',color_conf,...
    'LineWidth',lWidth_conf,'LineStyle',lStyles{1,2},...
    'Marker',mStyles{1,4},...
    'DisplayName','Confidence interval');

% regression curve 
plot(xInterp_a,yInterp_a,...
    'Color',colors(7,:),...
    'LineWidth',3,'LineStyle',lStyles{1,2},...
    'Marker',mStyles{1,4},'MarkerSize',MarkerS,...
    'MarkerFaceColor',[0.502 0.502 0.502],...
    'DisplayName','Interpolation subcritical');

% LINE UP
fMakeXgrid(0.2:0.2:0.8,[0,1],0.5);
fMakeYgrid([0,1],0.2:0.2:0.8,0.5);

% Create xlabel
xlabel('Relative upstream water depth\it h_{*}\rm [-]','FontSize',fontS,'FontName','TimesNewRoman');
% Create ylabel
ylabel('Discharge coefficient\it \mu_{p}\rm [-]',...
    'FontSize',fontS,...
    'FontName','TimesNewRoman');  
annotation(figure1,'textbox',...
        [0.185 yPos  0.4 0.1],... % [x_begin y_begin length height]
        'String',{'b)'},...
        'FontName','TimesNewRoman','FontSize',fontS+2,...
        'FontWeight','bold',...
        'FitBoxToText','on',...
        'LineStyle','none');
% create legend here
lgnd = legend(plot1);
set(lgnd,'Location','SouthEast','LineWidth',1);
if write2disc
    cd('figures');
    export_fig muphx.pdf -pdf
    export_fig muphx.eps -eps
    cd ..
    disp('Figure (muphx) written to disc (figures folder).');
    close all;
end

