% B-spline basis functions visualization in MATLAB
clc;
clear;
close all;

% Define the knot vector and degree
U = [0, 0, 0, 1, 2, 3, 4, 4, 5, 5, 5];  % Knot vector
p = 2;  % Degree of the B-spline

% Number of basis functions
n = length(U) - p - 1;  % Number of basis functions (n = m - p - 1)

% Define the range of u for plotting
u = linspace(0, 5, 100);  % Sample points from 0 to 5

% Preallocate array for basis functions
N = zeros(n+1, length(u));

% Compute the B-spline basis functions using the Cox-de Boor recursion
for i = 0:n
    N(i+1, :) = BSplineBasis(i, p, U, u);
end

% Plot the B-spline basis functions
figure;
hold on;
colors = lines(n+1);  % Get distinct colors for each function
for i = 0:n
    plot(u, N(i+1, :), 'Color', colors(i+1,:), 'LineWidth', 2);
end

% Mark knots on the plot
for knot = unique(U)
    xline(knot, '--', 'Color', 'k', 'LineWidth', 1);
end

% Add labels and legend
title('B-spline Basis Functions (p=2)');
xlabel('u');
ylabel('N_{i,2}(u)');
legend(arrayfun(@(x) sprintf('N_{%d,2}(u)', x), 0:n, 'UniformOutput', false), 'Location', 'Best');
grid on;
hold off;

% Function to compute B-spline basis functions using Cox-de Boor formula
function N = BSplineBasis(i, p, U, u)
    if p == 0
        % Base case for degree 0
        N = double(U(i+1) <= u & u < U(i+2));
    else
        % Initialize the basis function to zero
        N = zeros(size(u));
        
        % Calculate the first term if it's within bounds
        if i <= length(U) - p - 2 && U(i+p+1) - U(i+1) > 0  % Avoid index out of bounds
            term1 = (u - U(i+1)) / (U(i+p+1) - U(i+1)) .* BSplineBasis(i, p-1, U, u);
        else
            term1 = zeros(size(u));  % Set term1 to zero if out of bounds
        end
        
        % Calculate the second term if it's within bounds
        if i+1 <= length(U) - p - 2 && U(i+p+2) - U(i+2) > 0  % Avoid index out of bounds
            term2 = (U(i+p+2) - u) / (U(i+p+2) - U(i+2)) .* BSplineBasis(i+1, p-1, U, u);
        else
            term2 = zeros(size(u));  % Set term2 to zero if out of bounds
        end
        
        % Combine the two terms
        N = term1 + term2;
    end
end
