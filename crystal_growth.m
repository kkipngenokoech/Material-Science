function []=crystal_growth()
  %
  % This program simulates snow crystal growth using a cellular model
  % [cf. C. A. Reiter, Chaos, Solitons and Fractals 23, 1111–1119 (2005)].
  %

  % define the lattice vectors
  lattice_parameter=1;
  lattice_vector=lattice_parameter*[1,1/2;0,sqrt(3)/2];
  list_neighbors=[1,0;-1,0;0,1;0,-1;1,-1;-1,1]';
  
  % define the number of points in the lattice
  n_point=500;

  % set the number of iterations
  n_iteration=input('number of iterations (1000-4000) = ');

  % define the growth parameters
  alpha=1;          % nearest neighbor average parameter
  beta=0.35;         % background level
  gamma=0.001;     % added constant

  
  % initialize arrays
  u=beta*ones(n_point,n_point);
  u(n_point/2,n_point/2)=1;
  draw_lattice(n_point,lattice_vector)

  % iterate cellular evolution
  for n=1:n_iteration
    receptivity=list_receptive(u,list_neighbors,n_point);
    u1=(u+gamma).*receptivity;
    u2=u.*(1-receptivity);
    u2=average(u2,alpha,list_neighbors,n_point);
    u=u1+u2;
    if mod(n,10)==0
     draw_crystal(u,beta,n_point,lattice_vector,n)
    end
  end
end

function [receptivity]=list_receptive(u,list_neighbors,n_point)
  %
  % This function determine the receptive cells as an array of
  % 0 (nonreceptive) and 1 (receptive)
  %
  receptivity=zeros(n_point,n_point);
  for i1=2:(n_point-1)
    for i2=2:(n_point-1)
      if u(i1,i2)>=1
        receptivity(i1,i2)=1;
      else
        for i_neighbor=1:6
          j1=i1+list_neighbors(1,i_neighbor);
          j2=i2+list_neighbors(2,i_neighbor);
          if u(j1,j2) >= 1
            receptivity(i1,i2)=1;
            break
          end
        end
      end
    end
  end
end

function [uout]=average(uin,alpha,list_neighbors,n_point)
  %
  % this function performs the average on the nonreceptive cells.
  %
  uout=uin;
  for i1=2:(n_point-1)
    for i2=2:(n_point-1)
      for i_neighbor=1:6
        j1=i1+list_neighbors(1,i_neighbor);
        j2=i2+list_neighbors(2,i_neighbor);
        uout(i1,i2)=uout(i1,i2)+alpha/12*(uin(j1,j2)-uin(i1,i2));
      end
    end
  end
end

function []=draw_lattice(n_point,lattice_vector)
  %
  % This function draws the lattice.
  %
  figure(1)
  clf
  hold all
  axis equal
  xlim([0,n_point*3/2])
  ylim([0,n_point*sqrt(3)/2])
  axis off
end

function []=draw_crystal(u,beta,n_point,lattice_vector,n)
  %
  % This function draws the crystal.
  %
  cla
  M=[];
  for i1=1:n_point
    for i2=1:n_point
      if abs(u(i1,i2)-beta)>0.05 && u(i1,i2)<1
        M=[M,lattice_vector*[i1;i2]];
      end
    end
  end
  plot(M(1,:),M(2,:),'h','Color',[0 0 0],'MarkerSize',2)
  text(0,0,'number of iterations = '+string(n),'FontSize',20)
  drawnow
end
    
   
     
  