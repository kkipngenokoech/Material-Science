%%
help ode45

%%



function dfdt = pendulum_ode(t, f, m, l, g)
    % f(1) is the current angle (theta)
    % f(2) is the current momentum (p_theta)
    theta = f(1);
    p_theta = f(2);

    % 1. Change in angle: dot{theta} = p_theta / (m * l^2)
    d_theta = p_theta / (m * l^2);

    % 2. Change in momentum: dot{p_theta} = -m * g * l * sin(theta)
    d_p_theta = -m * g * l * sin(theta);

    % Return as a column vector
    dfdt = [d_theta; d_p_theta];
end

%% --- System Constants ---
m = 2.0;    % kg 
l = 1.5;    % m 
g = 9.81;   % m/s^2

%%
% Initial conditions: angle and momentum
initialConditions = [pi/4; 0]; % Starting at 45 degrees with no initial momentum

% Time span for the simulation
timeSpan = [0, 10]; % Simulate from 0 to 10 seconds
% Solve the ODE using ode45 - step by step solver, takes the initial conditions, uses pendulume ode to solve the next conditions, iterate  until we go through the entire timestep
[t, f] = ode45(@(t, f) pendulum_ode(t, f, m, l, g), timeSpan, initialConditions);
%%

% Plot the results
figure;
plot(t, f(:, 1), 'b', 'LineWidth', 2); % Plot angle over time
xlabel('Time (s)');
ylabel('Angle (rad)');
title('Pendulum Angle vs Time');
grid on;
% Plot the momentum over time
figure;
plot(t, f(:, 2), 'r', 'LineWidth', 2); % Plot momentum over time
xlabel('Time (s)');
ylabel('Momentum (p_{\theta})');
title('Pendulum Momentum vs Time');
grid on;
% Display the final angle and momentum after the simulation
finalAngle = f(end, 1);
finalMomentum = f(end, 2);
fprintf('Final Angle: %.2f rad\n', finalAngle);
fprintf('Final Momentum: %.2f kg*m^2/s\n', finalMomentum);
