% Example control points (for illustration)
P = [0 0; 1 2; 3 3; 4 1; 2 -4]; % Control points matrix (n x 2)

% Degree of the B-spline
p = 3; % Cubic B-spline

% Extend control points for periodicity (add the first p points at the end)
P_extended = [P; P(1:p, :)];

% Number of control points after extension
n = size(P_extended, 1);

% Create a uniform, periodic knot vector
knot_vector = 0:(n + p); % Uniform knots

% Create a B-spline curve using MATLAB's bspline functions
figure;
hold on;
axis equal;

% Plot the extended control points
plot(P_extended(:, 1), P_extended(:, 2), 'ro--', 'DisplayName', 'Control Points');

% Sample parameter range for plotting the B-spline curve
u = linspace(p, n, 500);

% Evaluate the B-spline curve using a NURBS toolbox (such as the Curve Fitting Toolbox)
% Create and plot the curve
curve_points = zeros(length(u), 2);
for i = 1:length(u)
    % Use bspline_basis to evaluate the curve point at parameter u(i)
    for j = 1:n
        basis = bspline_basis(j, p, u(i), knot_vector);
        curve_points(i, :) = curve_points(i, :) + basis * P_extended(j, :);
    end
end

% Plot the B-spline curve
plot(curve_points(:, 1), curve_points(:, 2), 'b-', 'LineWidth', 1.5, 'DisplayName', 'B-Spline Curve');
legend('show');

% Functions needed for basis evaluation (these may be defined externally or adjusted as needed):
function val = bspline_basis(i, p, u, knot_vector)
    % Recursive definition of B-spline basis functions
    if p == 0
        % Base case: piecewise constant
        val = (u >= knot_vector(i) && u < knot_vector(i + 1));
    else
        % Recursive case
        denom1 = knot_vector(i + p) - knot_vector(i);
        denom2 = knot_vector(i + p + 1) - knot_vector(i + 1);
        
        term1 = 0;
        term2 = 0;
        
        if denom1 > 0
            term1 = ((u - knot_vector(i)) / denom1) * bspline_basis(i, p - 1, u, knot_vector);
        end
        if denom2 > 0
            term2 = ((knot_vector(i + p + 1) - u) / denom2) * bspline_basis(i + 1, p - 1, u, knot_vector);
        end
        
        val = term1 + term2;
    end
end
