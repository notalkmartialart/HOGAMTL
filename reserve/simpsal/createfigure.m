%function createfigure(GN, GN_truth)
%CREATEFIGURE(XDATA1, YDATA1, XDATA2, YDATA2)
%  XDATA1:  line xdata
%  YDATA1:  line ydata
%  XDATA2:  line xdata
%  YDATA2:  line ydata

%  Auto-generated by MATLAB on 21-Nov-2019 19:35:26

% Create figure
figure1 = figure('Tag','Print CFTOOL to Figure',...
    'Color',[0.92156862745098 0.913725490196078 0.929411764705882]);

% Create axes
axes1 = axes('Parent',figure1,'Tag','sftool surface axes');
hold(axes1,'on');

% Create line
line(GN,GN_truth,'Parent',axes1,'DisplayName','GN',...
    'MarkerEdgeColor',[0 0 0],...
    'Marker','o',...
    'LineWidth',1,...
    'LineStyle','none');
line(GB,GB_truth,'Parent',axes1,'DisplayName','GB',...
    'MarkerEdgeColor',[1 0 0],...
    'Marker','o',...
    'LineWidth',1,...
    'LineStyle','none');
line(MB,MB_truth,'Parent',axes1,'DisplayName','MB',...
    'MarkerEdgeColor',[0 1 0],...
    'Marker','o',...
    'LineWidth',1,...
    'LineStyle','none');
line(CC,CC_truth,'Parent',axes1,'DisplayName','CC',...
    'MarkerEdgeColor',[0 0 1],...
    'Marker','o',...
    'LineWidth',1,...
    'LineStyle','none');
line(JC,JC_truth,'Parent',axes1,'DisplayName','JC',...
    'MarkerEdgeColor',[1 1 0],...
    'Marker','o',...
    'LineWidth',1,...
    'LineStyle','none');
line(J2C,J2C_truth,'Parent',axes1,'DisplayName','J2C',...
    'MarkerEdgeColor',[0 1 1],...
    'Marker','o',...
    'LineWidth',1,...
    'LineStyle','none');
line(LSC,LSC_truth,'Parent',axes1,'DisplayName','LSC',...
    'MarkerEdgeColor',[1 0 1],...
    'Marker','o',...
    'LineWidth',1,...
    'LineStyle','none');
line(XData2,YData2,'Parent',axes1,...
    'DisplayName','Curve fitted with logistic function',...
    'MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[1 0 0],...
    'MarkerSize',3,...
    'LineWidth',3,...
    'Color',[1 0 0]);


% Create xlabel
xlabel('predicted DMOS');

% Create zlabel
zlabel('Z');

% Create ylabel
ylabel('DMOS');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[36.2 79.977]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[34.994 87.284]);
% Uncomment the following line to preserve the Z-limits of the axes
% zlim(axes1,[-1 1]);
box(axes1,'on');
grid(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',14);
% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.57673856960742 0.147163069710891 0.307553949866364 0.0904255295053441],...
    'Interpreter','none',...
    'FontSize',12,...
    'EdgeColor',[0.15 0.15 0.15]);

