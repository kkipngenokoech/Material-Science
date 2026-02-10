% system parameters
l1 = 3;     
l2 = 2;
m1 = 1.5;
m2 = 2;

% solve differential equation
[t,f] = ode45(@ode_function,linspace(0,20,1e5),[pi/2 pi/6 0 -3*pi/2+0.01]);
theta_1 = f(:,1);
theta_2 = f(:,2);
omega_1 = f(:,3);
omega_2 = f(:,4);

% plot the solution (t, theta)
clf
axis square
xlim([-6,6])
ylim([-7,5])
shg
hold on
for n=1:length(t)
  if mod(n,50)==0
  x1 = l1 * sin(theta_1(n));
  z1 = - l1 * cos(theta_1(n));
  x2 = x1 + l2 * sin(theta_2(n));
  z2 = z1 - l2 * cos(theta_2(n));
  %cla
  %plot([0,x1,x2],[0,z1,z2],'-','Color','black',LineWidth=2)
  plot(x1,z1,'.','MarkerSize',1,'Color','red')
  plot(x2,z2,'.','MarkerSize',1,'Color','blue')
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
  A = [ ( m1 + m2 ) * l1 , m2 * l2 * cos( theta_1 - theta_2 ); ...
        m2 * l1 * cos( theta_1 - theta_2 ) , m2 * l2 ];
  B = [ - m2 * l2 * omega_2^2 * sin(theta_1-theta_2) - (m1+m2) * g * sin(theta_1); ...
        m2 * l1 * omega_1^2 * sin(theta_1 - theta_2) - m2 * g * sin(theta_2) ];
  dfdt = [ omega_1; omega_2; inv(A)*B ];
end