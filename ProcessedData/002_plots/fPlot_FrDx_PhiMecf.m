function[] = fPlot_FrDx_PhiMecf(FxData, PhiData, nf, write2disc)
%% PREAMBLE
scrsz = get(0,'ScreenSize');
% scrsz =   1 1 1920 1200
%scrsz(4) = scrsz(4)*4;
fontS = 36; % best for 1x1: 46
MarkerS = 15;
CapS = 20;

gray0 = [0.4 0.4 0.4];
gray1 = [0.6 0.6 0.6]; 
black = [0. 0. 0.]; 

%other:{'+','o','diamond','v','square','pentagram','x','^','*','>','h','<'};
mStyles = {'v','^','o','<','square','>','none'};
lStyles = {'none','-',':','-.','--'};

figure1 = figure('Color',[1 1 1],'Position',[1 scrsz(3) scrsz(3)/1.6 scrsz(3)]);

axes1 = axes('Parent',figure1,'FontSize',fontS,...
    'FontName','Arial','GridLineStyle','-',...
    'XTick',0:0.5:2,...
    'XTickLabel',{'0.0','0.5','1.0','1.5','2.0'},...
    'YTick',0:10^-3:4*10^-3,...
    'LineWidth', 1.5);
% 'YTickLabel','YTickLabel',{'','2\cdot 10^{-4}','4\cdot 10^{-4}','6\cdot 10^{-4}','8\cdot 10^{-4}'},...
hold(axes1,'all');
box(axes1,'on');
grid(axes1,'off');

xlim(axes1,[0 2]);
ylim(axes1,[0. 4*10^-3]);

u_Fx = fGetErrFrRel(FxData)*1.5;
u_Phi= fGetErrPhiRel(PhiData);

plot1(1) = plot(FxData(:,1),PhiData(:,1),...
    'Marker',mStyles{1,1},'MarkerSize',MarkerS,...
    'MarkerEdgeColor',black,...
    'LineStyle','none',...
    'DisplayName',['f = ', num2str(nf(1),3)]);

for i = 2:numel(nf)
    plot1(numel(plot1)+i-1) = plot(FxData(:,i),PhiData(:,i),...
        'Marker',mStyles{1,i},'MarkerSize',MarkerS,...
        'MarkerEdgeColor',black,...
        'LineStyle','none',...
        'DisplayName',['f = ', num2str(nf(i),'%-1.2f')]);
end
lgnd = legend(axes1,'show','Location','NorthWest');
%set(lgnd,'TextColor',gray0,'EdgeColor',[1 1 1]);
for i = 1:numel(nf) %second plot necessary as errorbar destroys legend
    plot1(numel(plot1)+i) = errorbar(FxData(:,i),PhiData(:,i),...
        -u_Phi(:,i),u_Phi(:,i),-u_Fx(:,i),u_Fx(:,i),...
        'Marker',mStyles{1,i},'MarkerSize',MarkerS,...
        'MarkerEdgeColor',black,...
        'Color',gray1,...
        'LineStyle','none',...
        'CapSize',CapS,...
        'DisplayName',['f = ', num2str(nf(i),'%-1.2f')]);
end

% LINE UP
fMakeXgrid(0.5:0.5:1.5,[0,0.004],0.5);
fMakeYgrid([0,2],10^-3:10^-3:3*10^-3,0.5);
% Create xlabel
xlabel('Grain-related flow velocity F_* [-]','FontSize',fontS,'FontName','Arial');
% Create ylabel
ylabel('Bedload transport intensity \Phi [-]',...
    'FontSize',fontS,...
    'FontName','Arial');

if write2disc
    cd('UnsteadyFigures');
    export_fig FxPhiMecf.png -png
    export_fig FxPhiMecf.eps -eps
    cd ..
    disp('Figure (FrDxMecf) written to disc (unsteady figures folder).');
    close all;
end

