% --- system parameters ---
l1 = 3;     
l2 = 2;
m1 = 1;
m2 = 2; % Added m2 which was missing in your blanks

% --- solve differential equation ---
% linspace(start, end, number_of_steps)
% initial conditions: [theta1, theta2, omega1, omega2]
[t,f] = ode45(@ode_function, linspace(0, 20, 1000), [pi/4; pi/2; 0; 0]);

theta_1 = f(:,1);
theta_2 = f(:,2);

% --- plot the solution (t, theta) ---
clf
axis square
xlim([-6,6])
ylim([-7,5])
shg
hold on

for n=1:length(t)
  if mod(n,10)==0 % Changed from 50 to 10 for a smoother animation
      x1 = l1 * sin(theta_1(n));
      z1 = - l1 * cos(theta_1(n));
      x2 = x1 + l2 * sin(theta_2(n));
      z2 = z1 - l2 * cos(theta_2(n));
      cla
      % Draw the rods
      plot([0,x1,x2],[0,z1,z2],'-','Color','black','LineWidth',2)
      % Draw Mass 1
      plot(x1,z1,'.','MarkerSize',20*m1,'Color','red')
      % Draw Mass 2
      plot(x2,z2,'.','MarkerSize',20*m2,'Color','blue')
      drawnow
  end
end
  
function dfdt = ode_function(t,f) 
  g = 9.81; % m/s^2
  l1 = 3;   % m
  l2 = 2;   % m
  m1 = 1;   % kg
  m2 = 2;   % kg
  
  theta_1 = f(1);
  theta_2 = f(2);
  omega_1 = f(3);
  omega_2 = f(4);
  
  % A is the mass matrix (Inertia)
  A = [ ( m1 + m2 ) * l1 , m2 * l2 * cos( theta_1 - theta_2 ); ...
        m2 * l1 * cos( theta_1 - theta_2 ) , m2 * l2 ];
    
  % B contains the gravitational and centripetal forces
  % This is the "physics" heart of the double pendulum
  B = [ -m2 * l2 * omega_2^2 * sin(theta_1 - theta_2) - (m1 + m2) * g * sin(theta_1); ...
         m2 * l1 * omega_1^2 * sin(theta_1 - theta_2) - m2 * g * sin(theta_2) ];
  
  % dfdt = [velocity1; velocity2; acceleration1; acceleration2]
  % inv(A)*B solves for the accelerations
  dfdt = [ omega_1; omega_2; inv(A)*B ];
end