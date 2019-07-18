function [ ] = fPlot( Xdata, Ydata, fontS, dataName,b,Q,Qb,write2disc )
% Plots points of Xdata COLUMN against Ydata COLUMNS
% nTitle = figure title name
% dataName = data names for legend entries
% write2disc = optional argument

% PREAMBLE ----------------------------------------------------------------
if nargin < 8
    write2disc = 1;
end
% load necessary functions 
fileID = fopen('WriteFiguresFunctionNames.txt');
wffn = textscan(fileID, '%s', 'delimiter','\n'); 
fclose(fileID);
cd('WriteFiguresFunctions')
for i =  1:length(wffn{:})
    fCopyFunction([wffn{1}{i}])
end 
cd ..

fontN = 'Arial';

% MAIN --------------------------------------------------------------------
nC = numel(Ydata(1,:));
lineNames={'Channel bed',['Water level (b = ',num2str(b,'%0.3f'),' m)'],...
                'Water level non-constricted', 'Energy level'};

scrsz = get(0,'ScreenSize');
figure1 = figure('Color',[1 1 1],'Position',[1 scrsz(4) scrsz(3) scrsz(4)*0.5]);
%other:{'+','o','diamond','v','square','pentagram','x','^','*','>','h','<'};
mStyles = {'o','none','none','none'};
lStyles = {'none','-',':','-.','--'};
% create gray scale colormap
cmap = contrast(ones(1,5));
colors = colormap(cmap);

axes1 = axes('Parent',figure1,'YGrid','on',...
    'XGrid','on',...
    'XColor',[0 0 0],...
    'LineWidth',1,...
    'GridLineStyle','-',...
    'FontSize',fontS,...
    'FontName',fontN);
%     'XTickLabel',{'5+300','','5+350','','5+400','',...
%     '5+450','','5+500',''},...
%     'XTick',5.3:0.025:5.525,...
%     'YTickLabel',{'511','512','513','514','515','516',...
%     '517','518','519','520','521','522'}, 'YTick',[ 511 512 ...
%     513 514 515 516 517 518 519 520 521 522],...
xlim(axes1,[0 1.8]);
ylim(axes1,[0 0.2]);
box(axes1,'on');
hold(axes1,'all');
% CREATE SUPPLEMENTARY SHAPES ---------------------------------------------
xC = 0.848;
% constriction (LAT)
% annotation(figure1,'line',[xC xC],... %startX end X
%     [0.93 0.11],... % startY end Y
%     'LineWidth',15,...
%     'Color',[0.65 0.65 0.65]);

% [x_begin y_begin length height]
annotation(figure1,'rectangle',[0.8455 0.11  0.015 0.815],... %startX end X
    'FaceColor',[0.8 0.8 0.8],...
    'FaceAlpha',0.4,...
    'Color',[0.1 0.1 0.1]);

% CREATE PLOTS ------------------------------------------------------------
for i = 1:nC
    plot1(i) = plot(Xdata,Ydata(:,i),'Parent',axes1,...
        'Marker',mStyles{i},'MarkerSize',5,...
        'LineStyle',lStyles{i},...
        'Color',colors(i,:));
    hold on
    set(plot1(i),'DisplayName',lineNames{i});
end
% set(axes1,'xdir','reverse') % activate to revers axes order
xlabel('Distance to channel inlet [m]','FontSize',fontS,...
    'FontName',fontN);
ylabel('Level [m]','FontSize',fontS,'FontName',fontN);
if Qb
    nTitle = ['Q = ', num2str(Q*10^3,'%0.1f'), 'l/s, b = ',...
     num2str(b,'%0.3f'), ' m with bedload'];
else
    nTitle = ['Q = ', num2str(Q*10^3,'%0.1f'), 'l/s, b = ',...
     num2str(b,'%0.3f'), ' m without bedload'];
end
title({nTitle},'FontSize',fontS,'FontName',fontN);
legend1 = legend(axes1,'show');
set(legend1,'Location','NorthWest');




% WRITE 2 DISC ------------------------------------------------------------
if write2disc
    if Qb==0
        figPath = ['results_plots/Qb_off/b',num2str(b,'%0.3f')];
    else
        figPath = ['results_plots/Qb_on/b',num2str(b,'%0.3f')];
    end
    if not(exist(figPath,'dir')==7)
        mkdir(figPath)
    end
    cd(figPath)
    export_fig([dataName,'.png'], '-png')
    close all;
    cd ..\..\..
    %disp(['Figure ',dataName,'.png',' written to disc.'])
end
end



