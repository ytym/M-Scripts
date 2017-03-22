function plot_circ (color)
% plot unit circle in current figure
% Manfred Lohöfener, Leipzig, Feb. 2017
% 
% Use plot_circ ('color')

  phi = linspace (0, 2*pi);
  x = cos (phi); 
  y = sin (phi);          % Einheitskreis
  line (x, y, 'Color', color, 'LineWidth', 1)
end
