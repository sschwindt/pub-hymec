function[] = fMakeYgrid(xLim, yVec, lWidth)
% function plots black horizontal lines at points given in xVec

for i = 1:numel(yVec)
    plot([xLim(1), xLim(2)],[yVec(i), yVec(i)],...
        'LineWidth', lWidth, ...
        'Color',[0.3,0.3,0.3],...
        'Marker','none');
end
end
