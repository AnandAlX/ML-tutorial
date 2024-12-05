% Define control points
control_points = [0 2 4 6 8 10 12 14;  % x-coordinates
                  0 7 5 9 2 3 5 1];   % y-coordinates

% Degree of the B-spline (quadratic)
degree = 2;

% Number of control points
num_control_points = size(control_points, 2);

% Define a uniform knot vector
knot_vector = [0 1 2 3 4 5 6 7 8 9 10];

% Define the range of parameter values t
t_values = linspace(2, 8, 100);  % Parameter values where the curve is evaluated

% Initialize arrays to store the B-spline curve points
curve_x = zeros(size(t_values));
curve_y = zeros(size(t_values));

% Loop over each parameter value to compute the B-spline curve point
for j = 1:length(t_values)
    t = t_values(j);  % Current parameter value
    
    % Initialize point on the curve at t
    curve_point = [0; 0];
    
    % Sum up the basis functions times control points
    for i = 1:num_control_points
        % Compute the basis function N_{i, degree} at t
        N_i = bspline_basis(i-1, degree, knot_vector, t);
        
        % Update the point on the curve
        curve_point = curve_point + N_i * control_points(:, i);
    end
    
    % Store the computed curve point
    curve_x(j) = curve_point(1);
    curve_y(j) = curve_point(2);
end

% Plot the B-spline curve
figure;
hold on;
title('Quadratic B-spline Curve with Uniform Knots');
xlabel('x');
ylabel('y');
grid on;

% Plot the B-spline curve
plot(curve_x, curve_y, 'b-', 'LineWidth', 1.5);

% Plot control points
plot(control_points(1, :), control_points(2, :), 'ro-', 'MarkerFaceColor', 'r', 'LineWidth', 1.5);

% Label control points for clarity
for i = 1:num_control_points
    text(control_points(1, i), control_points(2, i), sprintf('P_%d', i-1), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

legend('B-spline Curve', 'Control Points');
hold off;

% Function to calculate the B-spline basis function N_{i,p} at t
function N = bspline_basis(i, p, knots, t)
    if p == 0
        % Degree 0 basis function
        if knots(i+1) <= t && t < knots(i+2)
            N = 1;
        else
            N = 0;
        end
    else
        % Recursive definition for degree > 0
        if knots(i+p+1) ~= knots(i+1)
            term1 = ((t - knots(i+1)) / (knots(i+p+1) - knots(i+1))) * bspline_basis(i, p-1, knots, t);
        else
            term1 = 0;
        end
        if knots(i+p+2) ~= knots(i+2)
            term2 = ((knots(i+p+2) - t) / (knots(i+p+2) - knots(i+2))) * bspline_basis(i+1, p-1, knots, t);
        else
            term2 = 0;
        end
        N = term1 + term2;
    end
end
