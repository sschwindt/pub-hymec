function[] = fMakeXgrid(xVec, yLim, lWidth)
% function plots black vertical lines at points given in xVec

for i = 1:numel(xVec)
    plot([xVec(i), xVec(i)],[yLim(1), yLim(2)],...
        'LineWidth', lWidth, ...
        'Color',[0.3,0.3,0.3],...
        'Marker','none');
end
end
