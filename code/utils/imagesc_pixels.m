function imagesc_pixels(bw)

figure, 
imagesc(bw), 

h = findobj(gcf,'type','image');
xdata = get(h, 'XData');
ydata = get(h, 'YData');

M = size(get(h,'CData'), 1);
N = size(get(h,'CData'), 2);

if M > 1
    pixel_height = diff(ydata) / (M-1);
else
    % Special case. Assume unit height.
    pixel_height = 1;
end

if N > 1
    pixel_width = diff(xdata) / (N-1);
else
    % Special case. Assume unit width.
    pixel_width = 1;
end

y_top = ydata(1) - (pixel_height/2);
y_bottom = ydata(2) + (pixel_height/2);
y = linspace(y_top, y_bottom, M+1);

x_left = xdata(1) - (pixel_width/2);
x_right = xdata(2) + (pixel_width/2);
x = linspace(x_left, x_right, N+1);


xv = zeros(1, 2*numel(x));
xv(1:2:end) = x;
xv(2:2:end) = x;

yv = repmat([y(1) ; y(end)], 1, numel(x));
yv(:,2:2:end) = flipud(yv(:,2:2:end));

xv = xv(:);
yv = yv(:);


yh = zeros(1, 2*numel(y));
yh(1:2:end) = y;
yh(2:2:end) = y;

xh = repmat([x(1) ; x(end)], 1, numel(y));
xh(:,2:2:end) = flipud(xh(:,2:2:end));

xh = xh(:);
yh = yh(:);


h = imshow(bw, 'InitialMagnification', 'fit');
ax = ancestor(h, 'axes');
line('Parent', ax, 'XData', xh, 'YData', yh, ...
    'Color', 'r', 'LineWidth', 2, 'Clipping', 'off');
line('Parent', ax, 'XData', xv, 'YData', yv, ...
    'Color', 'r', 'LineWidth', 2, 'Clipping', 'off');
title('All pixel edges')

dark = [.3 .3 .3];
light = [.8 .8 .8];
h = imshow(bw, 'InitialMagnification', 'fit');
ax = ancestor(h, 'axes');
line('Parent', ax, 'XData', xh, 'YData', yh, ...
    'Color', dark, 'LineStyle', '-', 'Clipping', 'off');
line('Parent', ax, 'XData', xh, 'YData', yh, ...
    'Color', light, 'LineStyle', '--', 'Clipping', 'off');
line('Parent', ax, 'XData', xv, 'YData', yv, ...
    'Color', dark, 'LineStyle', '-', 'Clipping', 'off');
line('Parent', ax, 'XData', xv, 'YData', yv, ...
    'Color', light, 'LineStyle', '--', 'Clipping', 'off');

end